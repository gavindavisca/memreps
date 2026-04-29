import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../logic/app_state.dart';
import '../logic/repository.dart';
import '../logic/scraper_service.dart';
import '../logic/l10n.dart';
import '../data/database.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LegislatureSelectionScreen extends StatelessWidget {
  const LegislatureSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final repository = Provider.of<Repository>(context);
    final scraper = Provider.of<ScraperService>(context);
    final l10n = appState.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.get('legislature')),
        centerTitle: true,
        leading: appState.currentProfile?.lastLegislatureId != null
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => appState.cancelLegislatureSelection(),
            )
          : null,
      ),
      body: FutureBuilder<List<Legislature>>(
        future: repository.getLegislatures().then((list) {
          list.sort((a, b) => a.name.compareTo(b.name));
          return list;
        }),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          final legislatures = snapshot.data ?? [];

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: legislatures.length,
            itemBuilder: (context, index) {
              final leg = legislatures[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(
                    leg.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  trailing: const Icon(Icons.download_rounded),
                  onTap: () => _handleSelection(context, leg, appState, repository, scraper, l10n),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _handleSelection(
    BuildContext context,
    Legislature legislature,
    AppState appState,
    Repository repository,
    ScraperService scraper,
    L10n l10n,
  ) async {
    final statusNotifier = ValueNotifier<String>(l10n.get('loading_reps'));

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SpinKitPulse(color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 16),
            ValueListenableBuilder<String>(
              valueListenable: statusNotifier,
              builder: (context, value, _) => Text(
                value,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );

    try {
      // 1. Delete previous legislature data if it exists and is different
      final previousLegId = appState.currentProfile?.lastLegislatureId;
      if (previousLegId != null && previousLegId != legislature.id) {
        await repository.clearLegislatureData(previousLegId);
      }

      // 2. Fetch data with progress updates
      final members = await scraper.fetchMembers(
        legislature.openNorthId, 
        name: legislature.name,
        onProgress: (step) {
          if (step == 1) statusNotifier.value = l10n.get('loading_reps');
          if (step == 2) statusNotifier.value = l10n.get('enhancing_status');
        },
      );
      
      // 3. Populate database (Full reload)
      await repository.populateLegislature(legislature.name, legislature.openNorthId, members);
      
      // 4. Update state
      appState.setCurrentLegislature(legislature);
      
      // 5. Sync to backend if profile exists
      if (appState.currentProfile != null) {
        _syncProfileToBackend(appState.currentProfile!, legislature);
      }
      
      // 6. Close dialog
      if (context.mounted) Navigator.pop(context);
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _syncProfileToBackend(Profile profile, Legislature leg) async {
    final url = kDebugMode 
      ? 'http://127.0.0.1:5001/openclaw-bot-486015/us-central1/syncProfile'
      : 'https://syncprofile-wq27mxu42a-uc.a.run.app';

    try {
      await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'uuid': profile.uuid,
          'firstName': profile.firstName,
          'language': profile.language,
          'legislatureId': leg.id,
          'legislatureName': leg.name,
        }),
      );
    } catch (e) {
      debugPrint('Error syncing profile update: $e');
    }
  }
}
