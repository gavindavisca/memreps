import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../logic/app_state.dart';
import '../logic/repository.dart';
import '../logic/quiz_service.dart';
import '../logic/l10n.dart';
import '../data/database.dart';
import 'widgets/member_image.dart';
import '../logic/string_utils.dart';
import '../logic/config.dart';

import 'package:fsrs/fsrs.dart' as fsrs;

class QuizScreen extends StatefulWidget {
  final QuizMode mode;
  final String? partyFilter;
  final String? regionFilter;
  final bool duplicateLastNamesOnly;

  const QuizScreen({
    super.key,
    required this.mode,
    this.partyFilter,
    this.regionFilter,
    this.duplicateLastNamesOnly = false,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<QuizQuestion> _questions = [];
  int _currentIndex = 0;
  bool _isLoading = true;
  double _filterPercentage = 0.0;
  bool _isAnswered = false;
  String? _selectedAnswer;
  bool _isCorrect = false;
  String? _selectedRiding;
  final TextEditingController _textController = TextEditingController();
  int _correctCount = 0;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    final appState = Provider.of<AppState>(context, listen: false);
    final repository = Provider.of<Repository>(context, listen: false);
    final quizService = Provider.of<QuizService>(context, listen: false);
    final legId = appState.currentLegislature!.id;
    final userId = appState.currentProfile!.id;
    final now = DateTime.now();

    // 1. Get all members with their current stats
    final membersWithStats = await repository.getMembersWithStats(userId, legId);

    // 2. Filter based on user selection (Party/Region)
    var filtered = membersWithStats.where((ms) =>
        (widget.partyFilter == null || ms.member.party == widget.partyFilter) &&
        (widget.regionFilter == null || ms.member.region == widget.regionFilter)).toList();

    // 2.5 Filter for duplicates if requested
    if (widget.duplicateLastNamesOnly) {
      final counts = <String, int>{};
      for (final ms in membersWithStats) {
        final name = ms.member.lastName.toLowerCase().trim();
        counts[name] = (counts[name] ?? 0) + 1;
      }
      filtered = filtered.where((ms) => counts[ms.member.lastName.toLowerCase().trim()]! > 1).toList();
    }

    final totalCount = membersWithStats.length;
    final filteredCount = filtered.length;
    _filterPercentage = totalCount > 0 ? (filteredCount / totalCount) : 0.0;

    // 3. Categorize for priority selection
    final due = filtered.where((ms) => ms.review != null && ms.review!.due.isBefore(now)).toList();
    final isNew = filtered.where((ms) => ms.review == null).toList();
    final learned = filtered.where((ms) => ms.review != null && ms.review!.due.isAfter(now)).toList();

    // Sort due by how overdue they are (earliest first)
    due.sort((a, b) => a.review!.due.compareTo(b.review!.due));
    // Shuffle new for variety
    isNew.shuffle();
    // Sort learned by accuracy (lowest first) then by due date
    learned.sort((a, b) {
      final accuracyA = a.memorizationPercentage;
      final accuracyB = b.memorizationPercentage;
      if (accuracyA != accuracyB) {
        return accuracyA.compareTo(accuracyB);
      }
      return a.review!.due.compareTo(b.review!.due);
    });

    // 4. Build the final 10-member subset
    final List<Member> quizSubset = [];
    
    if (appState.currentProfile!.nextQuizIsRandom) {
      // Priority: Purely Random (from filtered set)
      final randomPool = filtered.map((ms) => ms.member).toList()..shuffle();
      quizSubset.addAll(randomPool.take(10));
      debugPrint('Quiz Selection Method: Random');
    } else {
      // Priority: FSRS (Due -> New -> Learned)
      // Priority 1: Due reviews
      quizSubset.addAll(due.take(10).map((ms) => ms.member));
      
      // Priority 2: New members
      if (quizSubset.length < 10) {
        quizSubset.addAll(isNew.take(10 - quizSubset.length).map((ms) => ms.member));
      }
      
      // Priority 3: Learned members (reviewing ahead)
      if (quizSubset.length < 10) {
        quizSubset.addAll(learned.take(10 - quizSubset.length).map((ms) => ms.member));
      }
      debugPrint('Quiz Selection Method: FSRS');
    }

    try {
      final questions = quizService.generateQuestions(
        members: quizSubset,
        mode: widget.mode,
        allLegislatureMembers: membersWithStats.map((ms) => ms.member).toList(),
      );

      setState(() {
        _questions = questions;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error generating questions: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = Provider.of<AppState>(context).l10n;

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.get(_getModeKey()))),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.search_off_rounded, size: 80, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  l10n.get('no_members_found'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(l10n.get('cancel')),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_currentIndex >= _questions.length) {
      return _buildResults(l10n);
    }

    final question = _questions[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('${l10n.get(_getModeKey())} - ${_currentIndex + 1}/${_questions.length}'),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: Column(
              children: [
                _buildQuestionCard(question, l10n),
                const SizedBox(height: 16),
                _buildInputArea(question, l10n),
                if (_isAnswered) ...[
                  const SizedBox(height: 16),
                  if (widget.mode == QuizMode.partyMatch || widget.mode == QuizMode.ridingMatch) ...[
                    Text(
                      '${question.member.firstName} ${question.member.lastName}',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                  ],
                  _buildNextButton(l10n),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getModeKey() {
    switch (widget.mode) {
      case QuizMode.nameMatch: return 'name_match';
      case QuizMode.partyMatch: return 'party_match';
      case QuizMode.ridingMatch: return 'riding_match';
      case QuizMode.nameRecall: return 'name_recall';
      case QuizMode.faceMatch: return 'face_match';
    }
  }

  Widget _buildQuestionCard(QuizQuestion question, L10n l10n) {
    if (widget.mode == QuizMode.faceMatch) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _isAnswered 
                    ? (_selectedAnswer == question.member.id.toString() ? 'Correct' : 'Incorrect')
                    : l10n.get('last_name'),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _isAnswered 
                      ? (_selectedAnswer == question.member.id.toString() ? Colors.green : Colors.red)
                      : Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _isAnswered 
                    ? '${question.member.firstName} ${question.member.lastName}'
                    : question.member.lastName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: _isAnswered ? 20 : 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: AspectRatio(
        aspectRatio: 4 / 5,
        child: Card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: MemberImage(
            imageUrl: question.member.imageUrl,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
        ),
      ),
    );
  }

  Widget _buildInputArea(QuizQuestion question, L10n l10n) {
    switch (widget.mode) {
      case QuizMode.nameMatch:
      case QuizMode.partyMatch:
      case QuizMode.ridingMatch:
        return Column(
          children: question.options!.map((option) {
            final isSelected = _selectedAnswer == option;
            Color? color;
            if (_isAnswered) {
              if (option == question.correctAnswer) {
                color = Colors.green;
              } else if (isSelected) {
                color = Colors.red;
              }
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: OutlinedButton(
                onPressed: _isAnswered ? null : () => _handleAnswer(option),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  backgroundColor: color?.withValues(alpha: 0.1),
                  side: color != null ? BorderSide(color: color, width: 2) : null,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(
                  option,
                  style: TextStyle(
                    color: color ?? Theme.of(context).colorScheme.onSurface,
                    fontWeight: isSelected ? FontWeight.bold : null,
                  ),
                ),
              ),
            );
          }).toList(),
        );

      case QuizMode.nameRecall:
        return Column(
          children: [
            TextField(
              controller: _textController,
              enabled: !_isAnswered,
              decoration: InputDecoration(
                hintText: l10n.get('last_name'),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onSubmitted: (value) => _handleAnswer(value),
            ),
            if (question.ridingOptions != null) ...[
              const SizedBox(height: 16),
              Text(l10n.get('select_riding')),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: question.ridingOptions!.map((riding) {
                  final isCorrectRiding = riding == question.member.riding;
                  Color? chipColor;
                  if (_isAnswered) {
                    if (isCorrectRiding) {
                      chipColor = Colors.green;
                    } else if (_selectedRiding == riding) {
                      chipColor = Colors.red;
                    }
                  }

                  return ChoiceChip(
                    label: Text(riding),
                    selected: _selectedRiding == riding,
                    onSelected: _isAnswered ? null : (selected) {
                      setState(() => _selectedRiding = selected ? riding : null);
                      if (selected && _textController.text.trim().isNotEmpty) {
                        _handleAnswer(_textController.text);
                      }
                    },
                    selectedColor: chipColor?.withValues(alpha: 0.2) ?? Theme.of(context).colorScheme.primaryContainer,
                    side: chipColor != null ? BorderSide(color: chipColor) : null,
                  );
                }).toList(),
              ),
            ],
            if (_isAnswered) ...[
              const SizedBox(height: 16),
              Text(
                _isCorrect ? l10n.get('correct') : l10n.get('incorrect'),
                style: TextStyle(
                  color: _isCorrect ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${l10n.get('answer')}${question.correctAnswer}${question.ridingOptions != null ? ' (${question.member.riding})' : ''}',
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ],
        );

      case QuizMode.faceMatch:
        return Column(
          children: [
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 4 / 5,
              ),
              itemCount: question.memberOptions!.length,
              itemBuilder: (context, index) {
                final m = question.memberOptions![index];
                final isSelected = _selectedAnswer == m.id.toString();
                Color? color;
                if (_isAnswered) {
                  if (m.id == question.member.id) {
                    color = Colors.green;
                  } else if (isSelected) {
                    color = Colors.red;
                  }
                }

                return GestureDetector(
                  onTap: _isAnswered ? null : () => _handleAnswer(m.id.toString()),
                  child: Container(
                    decoration: BoxDecoration(
                      border: color != null ? Border.all(color: color, width: 3) : null,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: MemberImage(
                      imageUrl: m.imageUrl,
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                    ),
                  ),
                );
              },
            ),
          ],
        );
    }
  }

  void _handleAnswer(String answer) {
    final question = _questions[_currentIndex];
    bool correct = false;

    if (widget.mode == QuizMode.nameMatch || 
        widget.mode == QuizMode.partyMatch ||
        widget.mode == QuizMode.ridingMatch) {
      correct = answer == question.correctAnswer;
    } else if (widget.mode == QuizMode.nameRecall) {
      if (question.ridingOptions != null && _selectedRiding == null) {
        return;
      }
      final nameCorrect = StringUtils.isFuzzyMatch(answer, question.correctAnswer!);
      final ridingCorrect = question.ridingOptions == null || _selectedRiding == question.member.riding;
      correct = nameCorrect && ridingCorrect;
    } else if (widget.mode == QuizMode.faceMatch) {
      correct = answer == question.member.id.toString();
    }

    setState(() {
      _isAnswered = true;
      _selectedAnswer = answer;
      _isCorrect = correct;
      if (correct) _correctCount++;
    });

    _submitSrsReview(correct);
  }

  Future<void> _submitSrsReview(bool correct) async {
    final appState = Provider.of<AppState>(context, listen: false);
    final repository = Provider.of<Repository>(context, listen: false);
    final memberId = _questions[_currentIndex].member.id;
    final userId = appState.currentProfile!.id;

    final rating = correct ? fsrs.Rating.good : fsrs.Rating.again;
    await repository.submitReview(userId, memberId, rating);
  }

  Future<void> _saveQuizResult() async {
    final appState = Provider.of<AppState>(context, listen: false);
    final repository = Provider.of<Repository>(context, listen: false);
    final profile = appState.currentProfile!;
    final leg = appState.currentLegislature!;
    final score = _correctCount / _questions.length;
    
    // 1. Local Save
    await repository.saveQuizResult(
      userId: profile.id,
      userName: profile.firstName,
      legislatureId: leg.id,
      quizModeId: _getModeKey(),
      filterPercentage: _filterPercentage,
      scorePercentage: score,
    );

    // 2. Backend Sync
    await _syncQuizResultToBackend(profile, leg, score);

    // 3. Toggle Selection Method for next time
    await appState.toggleQuizSelectionMethod();
  }

  Future<void> _syncQuizResultToBackend(Profile profile, Legislature leg, double score) async {
    final url = Config.getFunctionUrl('syncQuizResult');

    try {
      await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userUuid': profile.uuid,
          'userName': profile.firstName,
          'legislatureId': leg.id,
          'legislatureName': leg.name,
          'quizModeId': _getModeKey(),
          'filterPercentage': _filterPercentage,
          'scorePercentage': score,
        }),
      );
    } catch (e) {
      debugPrint('Error syncing quiz result to backend: $e');
      // We don't block the user on sync failure
    }
  }

  Widget _buildNextButton(L10n l10n) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
        child: ElevatedButton(
          onPressed: () {
            FocusScope.of(context).unfocus();
            if (_currentIndex < _questions.length - 1) {
              setState(() {
                _currentIndex++;
                _isAnswered = false;
                _selectedAnswer = null;
                _selectedRiding = null;
                _textController.clear();
              });
            } else {
              _saveQuizResult();
              setState(() {
                _currentIndex++;
              });
            }
          },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(56),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: Text(_currentIndex < _questions.length - 1 ? l10n.get('next') : l10n.get('finish')),
        ),
      ),
    );
  }

  Widget _buildResults(L10n l10n) {
    return Scaffold(
      appBar: AppBar(title: Text(l10n.get('finish'))),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_rounded, size: 100, color: Colors.green),
            const SizedBox(height: 24),
            Text(
              '${l10n.get('score')}: ${(_correctCount / _questions.length * 100).round()}%',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '$_correctCount / ${_questions.length}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Text(l10n.get('finish')),
            ),
          ],
        ),
      ),
    );
  }
}
