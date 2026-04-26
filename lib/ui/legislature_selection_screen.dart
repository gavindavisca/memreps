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
            Text('Fetching data for ${legislature.name}...'),
          ],
        ),
      ),
    );

    try {
      // 1. Fetch data
      final members = await scraper.fetchMembers(legislature.openNorthId, name: legislature.name);
      
      // 2. Populate database
      await repository.populateLegislature(legislature.name, legislature.openNorthId, members);
      
      // 3. Update state
      appState.setCurrentLegislature(legislature);
      
      // 4. Close dialog
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
}
