import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../logic/app_state.dart';
import 'legislature_selection_screen.dart';
import 'browse_screen.dart';
import 'quiz_selection_screen.dart';
import 'stats_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    if (appState.currentLegislature == null) {
      return const LegislatureSelectionScreen();
    }

    final screens = [
      const BrowseScreen(),
      const QuizSelectionScreen(),
      const StatsScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: appState.currentTabIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: appState.currentTabIndex,
        onDestinationSelected: (index) => appState.setTabIndex(index),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.search_rounded),
            label: appState.l10n.get('browse'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.school_rounded),
            label: appState.l10n.get('quiz'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.bar_chart_rounded),
            label: appState.l10n.get('results'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_rounded),
            label: appState.l10n.get('settings'),
          ),
        ],
      ),
    );
  }
}
