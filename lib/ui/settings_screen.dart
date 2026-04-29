import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/link.dart';
import '../logic/app_state.dart';
import '../logic/repository.dart';
import '../logic/scraper_service.dart';
import '../logic/l10n.dart';
import '../data/database.dart';
import 'package:intl/intl.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final repository = Provider.of<Repository>(context);
    final scraper = Provider.of<ScraperService>(context);
    final profile = appState.currentProfile!;
    final leg = appState.currentLegislature;
    final l10n = appState.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.get('settings')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildSection(context, l10n.get('whos_learning')),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: const Icon(Icons.person, size: 32),
                    title: Text(profile.firstName, style: const TextStyle(fontWeight: FontWeight.bold)),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _confirmDelete(context, repository, appState, l10n),
                      tooltip: l10n.get('delete'),
                    ),
                  ),
                ),
                const Divider(height: 0),
                ListTile(
                  title: Text(l10n.get('change')),
                  leading: const Icon(Icons.swap_horiz),
                  onTap: () => appState.setCurrentProfile(null),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _buildSection(context, l10n.get('language')),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              leading: const Icon(Icons.language),
              title: Text(profile.language == 'fr' ? 'Français' : 'English'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showLanguageDialog(context, appState, l10n),
            ),
          ),
          const SizedBox(height: 32),
          _buildSection(context, l10n.get('legislature')),
          if (leg != null)
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 8, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                leg.name,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.refresh),
                              onPressed: () async {
                                final confirmed = await _confirmLegAction(context, l10n);
                                if (confirmed && context.mounted) {
                                  _refreshData(context, leg, repository, scraper, appState);
                                }
                              },
                            ),
                          ],
                        ),
                        if (leg.lastUpdated != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 0.0),
                            child: Text(
                              'Last updated: ${DateFormat.yMMMd().add_jm().format(leg.lastUpdated!)}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const Divider(height: 0),
                  ListTile(
                    title: Text(l10n.get('change')),
                    leading: const Icon(Icons.swap_horiz),
                    onTap: () async {
                      final confirmed = await _confirmLegAction(context, l10n);
                      if (confirmed && context.mounted) {
                        appState.setCurrentLegislature(null);
                      }
                    },
                  ),
                ],
              ),
            ),
          const SizedBox(height: 48),
          Center(
            child: TextButton.icon(
              onPressed: () => _showCredits(context, l10n),
              icon: const Icon(Icons.info_rounded, color: Colors.blue),
              label: Text(
                l10n.get('credits'),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.7),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, left: 4.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, Repository repository, AppState appState, L10n l10n) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.get('delete')),
        content: const Text('This will permanently delete your progress.'), // Could localize this too
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l10n.get('cancel'))),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.get('delete')),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await repository.deleteProfile(appState.currentProfile!.id);
      appState.setCurrentProfile(null);
    }
  }

  Future<bool> _confirmLegAction(BuildContext context, L10n l10n) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.get('legislature')),
        content: Text(l10n.get('confirm_change_leg')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.get('cancel')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.get('proceed')),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }

  void _showLanguageDialog(BuildContext context, AppState appState, L10n l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.get('language')),
        content: RadioGroup<String>(
          groupValue: appState.currentProfile!.language,
          onChanged: (val) {
            if (val != null) {
              appState.setLanguage(val);
              _syncProfileToBackend(appState.currentProfile!, appState.currentLegislature!);
              Navigator.pop(context);
            }
          },
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: Text('English'),
                value: 'en',
              ),
              RadioListTile<String>(
                title: Text('Français'),
                value: 'fr',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _refreshData(
    BuildContext context,
    Legislature legislature,
    Repository repository,
    ScraperService scraper,
    AppState appState,
  ) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SpinKitPulse(color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 16),
            const Text('Refreshing data...'),
          ],
        ),
      ),
    );

    try {
      final members = await scraper.fetchMembers(legislature.openNorthId, name: legislature.name);
      await repository.populateLegislature(legislature.name, legislature.openNorthId, members);
      if (context.mounted) Navigator.pop(context);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data refreshed successfully.')),
        );
        _syncProfileToBackend(appState.currentProfile!, legislature);
        appState.setTabIndex(0);
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Refresh failed: $e')),
        );
      }
    }
  }

  void _showCredits(BuildContext context, L10n l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.info_outline_rounded, color: Colors.blue),
            const SizedBox(width: 12),
            Text(l10n.get('credits')),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.get('credits_data_web'),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                children: [
                  Text(l10n.get('credits_opennorth_pre')),
                  Link(
                    uri: Uri.parse('https://represent.opennorth.ca/'),
                    builder: (context, followLink) => GestureDetector(
                      onTap: followLink,
                      child: Text(
                        l10n.get('credits_opennorth_link'),
                        style: const TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  Text(l10n.get('credits_opennorth_post')),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                l10n.get('credits_legislatures'),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(l10n.get('credits_legislatures_desc')),
              const SizedBox(height: 12),
              Text(
                l10n.get('credits_thanks'),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(l10n.get('credits_team')),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              Text(
                l10n.get('credits_feedback'),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Link(
                uri: Uri.parse('mailto:guydavis.ca@gmail.com'),
                builder: (context, followLink) => GestureDetector(
                  onTap: followLink,
                  child: Text(
                    'guydavis.ca@gmail.com',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      decoration: TextDecoration.underline,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.get('close')),
          ),
        ],
      ),
    );
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
      debugPrint('Error syncing updated profile: $e');
    }
  }
}
