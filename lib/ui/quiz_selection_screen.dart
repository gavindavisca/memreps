import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../logic/app_state.dart';
import '../logic/repository.dart';
import '../logic/quiz_service.dart';
import '../data/database.dart';
import 'quiz_screen.dart';

class QuizSelectionScreen extends StatefulWidget {
  const QuizSelectionScreen({super.key});

  @override
  State<QuizSelectionScreen> createState() => _QuizSelectionScreenState();
}

class _QuizSelectionScreenState extends State<QuizSelectionScreen> {
  String? _selectedRegion;
  String? _selectedParty;
  bool _showFilters = false;
  bool _duplicateLastNamesOnly = false;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final repository = Provider.of<Repository>(context);
    final leg = appState.currentLegislature!;
    final l10n = appState.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.get('quiz')),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(_showFilters ? Icons.filter_list_off : Icons.filter_list),
            onPressed: () => setState(() => _showFilters = !_showFilters),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_showFilters) ...[
              _buildSubsetSelector(repository, leg.id),
              const SizedBox(height: 24),
            ],
            _buildModeCard(
              context,
              l10n.get('name_match'),
              l10n.get('name_match_desc'),
              Icons.format_list_bulleted_rounded,
              QuizMode.nameMatch,
            ),
            const SizedBox(height: 16),
            _buildModeCard(
              context,
              l10n.get('party_match'),
              l10n.get('party_match_desc'),
              Icons.groups_rounded,
              QuizMode.partyMatch,
            ),
            const SizedBox(height: 16),
            _buildModeCard(
              context,
              l10n.get('riding_match'),
              l10n.get('riding_match_desc'),
              Icons.map_rounded,
              QuizMode.ridingMatch,
            ),
            const SizedBox(height: 16),
            _buildModeCard(
              context,
              l10n.get('face_match'),
              l10n.get('face_match_desc'),
              Icons.face_retouching_natural_rounded,
              QuizMode.faceMatch,
            ),
            const SizedBox(height: 16),
            _buildModeCard(
              context,
              l10n.get('name_recall'),
              l10n.get('name_recall_desc'),
              Icons.keyboard_rounded,
              QuizMode.nameRecall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubsetSelector(Repository repository, int legislatureId) {
    final l10n = Provider.of<AppState>(context).l10n;
    return FutureBuilder<List<Member>>(
      future: repository.getMembers(legislatureId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();
        final members = snapshot.data!;
        final parties = members.map((m) => m.party).whereType<String>().toSet().toList()..sort();
        final regions = members.map((m) => m.region).whereType<String>().toSet().toList()..sort();

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.get('party'), style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilterChip(
                    label: Text(l10n.get('all')),
                    selected: _selectedParty == null,
                    onSelected: (_) => setState(() => _selectedParty = null),
                  ),
                  ...parties.map((p) => FilterChip(
                    label: Text(p),
                    selected: _selectedParty == p,
                    onSelected: (sel) => setState(() => _selectedParty = sel ? p : null),
                  )),
                ],
              ),
              const SizedBox(height: 16),
              Text(l10n.get('region'), style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilterChip(
                    label: Text(l10n.get('all')),
                    selected: _selectedRegion == null,
                    onSelected: (_) => setState(() => _selectedRegion = null),
                  ),
                  ...regions.map((r) => FilterChip(
                    label: Text(r),
                    selected: _selectedRegion == r,
                    onSelected: (sel) => setState(() => _selectedRegion = sel ? r : null),
                  )),
                ],
              ),
              const SizedBox(height: 16),
              Text(l10n.get('last_name'), style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilterChip(
                    label: Text(l10n.get('all')),
                    selected: !_duplicateLastNamesOnly,
                    onSelected: (_) => setState(() => _duplicateLastNamesOnly = false),
                  ),
                  FilterChip(
                    label: Text(l10n.get('duplicate')),
                    selected: _duplicateLastNamesOnly,
                    onSelected: (_) => setState(() => _duplicateLastNamesOnly = true),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildModeCard(BuildContext context, String title, String subtitle, IconData icon, QuizMode mode) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Theme.of(context).dividerColor),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Theme.of(context).colorScheme.primary),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        onTap: () => _startQuiz(context, mode),
      ),
    );
  }

  Future<void> _startQuiz(BuildContext context, QuizMode mode) async {
    final appState = Provider.of<AppState>(context, listen: false);
    final repository = Provider.of<Repository>(context, listen: false);
    final legId = appState.currentLegislature!.id;

    final members = await repository.getMembers(
      legId,
      party: _selectedParty,
      region: _selectedRegion,
    );

    if (members.isEmpty) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(appState.l10n.get('no_members_found')),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (!context.mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizScreen(
          mode: mode,
          partyFilter: _selectedParty,
          regionFilter: _selectedRegion,
          duplicateLastNamesOnly: _duplicateLastNamesOnly,
        ),
      ),
    );
  }
}
