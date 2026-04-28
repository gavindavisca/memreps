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
        future: repository.getQuizResults(userId),
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

          // Group by mode
          final Map<String, List<QuizResult>> grouped = {};
          for (final r in filteredResults) {
            grouped.putIfAbsent(r.quizModeId, () => []).add(r);
          }

          final modes = grouped.keys.toList()..sort();

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: modes.length,
            itemBuilder: (context, index) {
              final modeId = modes[index];
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
            Text(
              l10n.get(modeId),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 80,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.grey.withOpacity(0.2),
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
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
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
}
