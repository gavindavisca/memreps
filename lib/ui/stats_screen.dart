import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../logic/app_state.dart';
import '../logic/repository.dart';
import '../data/database.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final repository = Provider.of<Repository>(context);
    final userId = appState.currentProfile!.id;
    final l10n = appState.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.get('results'))),
      body: FutureBuilder<List<QuizResult>>(
        future: repository.getQuizResults(userId, legislatureId: appState.currentLegislature?.id),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          
          final allResults = snapshot.data!;
          if (allResults.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.bar_chart_rounded, size: 80, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    l10n.get('no_quiz_results'),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          final filteredResults = allResults.where((r) => r.filterPercentage >= 0.2).toList();
          if (filteredResults.isEmpty) {
             return const Center(
               child: Padding(
                 padding: EdgeInsets.all(32.0),
                 child: Text(
                   "Not enough data yet. Complete quizzes with at least 20% of members to see progress charts.",
                   textAlign: TextAlign.center,
                   style: TextStyle(color: Colors.grey),
                 ),
               ),
             );
          }

          // Group by mode (handling legacy multi_choice)
          final Map<String, List<QuizResult>> grouped = {};
          for (final r in filteredResults) {
            String modeId = r.quizModeId;
            if (modeId == 'multi_choice') modeId = 'name_match';
            grouped.putIfAbsent(modeId, () => []).add(r);
          }

          // Define explicit order matching QuizSelectionScreen
          final List<String> orderedModes = [
            'name_match',
            'party_match',
            'riding_match',
            'face_match',
            'name_recall',
          ];

          // Only show modes that have data
          final displayModes = orderedModes.where((m) => grouped.containsKey(m)).toList();

          if (displayModes.isEmpty) {
            return const Center(child: Text("No relevant quiz data found."));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: displayModes.length,
            itemBuilder: (context, index) {
              final modeId = displayModes[index];
              final results = grouped[modeId]!;
              return _buildModeChart(modeId, results, l10n);
            },
          );
        },
      ),
    );
  }

  Widget _buildModeChart(String modeId, List<QuizResult> results, l10n) {
    // Calculate rolling average (SMA)
    // Window size: 5 for smoothing
    const windowSize = 5;
    List<double> dataPoints = [];
    
    for (int i = 0; i < results.length; i++) {
      int start = (i - windowSize + 1).clamp(0, results.length);
      double sum = 0;
      int count = 0;
      for (int j = start; j <= i; j++) {
        sum += results[j].scorePercentage;
        count++;
      }
      dataPoints.add(sum / count);
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Theme.of(context).dividerColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.get(modeId),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.emoji_events_rounded, color: Colors.amber),
                  onPressed: () => _showLeaderboard(context, modeId),
                  tooltip: 'Leaderboard',
                ),
              ],
            ),
            const SizedBox(height: 4),
            SizedBox(
              height: 100,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.grey.withValues(alpha: 0.2),
                      strokeWidth: 1,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 0.5,
                        getTitlesWidget: (value, meta) {
                          if (value == 0 || (value - 0.5).abs() < 0.01 || (value - 1.0).abs() < 0.01) {
                            return Text('${(value * 100).toInt()}%', style: const TextStyle(fontSize: 10, color: Colors.grey));
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  minY: 0,
                  maxY: 1.05,
                  lineBarsData: [
                    LineChartBarData(
                      spots: dataPoints.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
                      isCurved: true,
                      color: Theme.of(context).primaryColor,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLeaderboard(BuildContext context, String modeId) {
    final appState = Provider.of<AppState>(context, listen: false);
    final l10n = appState.l10n;
    final legId = appState.currentLegislature!.id.toString();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.emoji_events_rounded, color: Colors.amber),
            const SizedBox(width: 12),
            Expanded(child: Text('${l10n.get(modeId)} Leaderboard')),
          ],
        ),
        content: FutureBuilder<List<dynamic>>(
          future: _fetchLeaderboard(legId, modeId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (snapshot.hasError || !snapshot.hasData) {
              return const SizedBox(
                height: 100,
                child: Center(child: Text('Failed to load leaderboard.')),
              );
            }

            final entries = snapshot.data!;
            if (entries.isEmpty) {
              return const SizedBox(
                height: 100,
                child: Center(child: Text('No results yet this week.')),
              );
            }

            return SizedBox(
              width: double.maxFinite,
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: entries.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final entry = entries[index];
                  final name = entry['name'] as String;
                  final score = (entry['averageScore'] as num) * 100;
                  
                  Widget leading;
                  if (index == 0) {
                    leading = const Icon(Icons.workspace_premium, color: Colors.amber);
                  } else if (index == 1) {
                    leading = const Icon(Icons.workspace_premium, color: Colors.grey);
                  } else if (index == 2) {
                    leading = const Icon(Icons.workspace_premium, color: Colors.brown);
                  } else {
                    leading = CircleAvatar(
                      radius: 14,
                      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                      child: Text('${index + 1}', style: const TextStyle(fontSize: 12)),
                    );
                  }

                  return ListTile(
                    dense: true,
                    leading: leading,
                    title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    trailing: Text(
                      '${score.toStringAsFixed(1)}%',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<List<dynamic>> _fetchLeaderboard(String legislatureId, String quizModeId) async {
    final url = kDebugMode 
      ? 'http://127.0.0.1:5001/openclaw-bot-486015/us-central1/getLeaderboard'
      : 'https://getleaderboard-wq27mxu42a-uc.a.run.app';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'legislatureId': legislatureId,
          'quizModeId': quizModeId,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['leaderboard'] as List<dynamic>;
      }
    } catch (e) {
      debugPrint('Error fetching leaderboard: $e');
    }
    return [];
  }
}
