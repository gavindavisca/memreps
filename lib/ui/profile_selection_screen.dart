import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../logic/app_state.dart';
import '../logic/repository.dart';
import '../data/database.dart';
import '../logic/l10n.dart';
import '../logic/scraper_service.dart';
import '../logic/recaptcha_service.dart';
import '../logic/config.dart';

class ProfileSelectionScreen extends StatefulWidget {
  const ProfileSelectionScreen({super.key});

  @override
  State<ProfileSelectionScreen> createState() => _ProfileSelectionScreenState();
}

class _ProfileSelectionScreenState extends State<ProfileSelectionScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool _isCreating = false;
  bool _isLoading = false;
  int _loadingStage = 0;
  String _selectedLanguage = 'en';
  Legislature? _selectedLegislature;
  List<Legislature> _legislatures = [];
  Future<List<Profile>>? _profilesFuture;
  bool _isVerified = false;
  bool _isVerifying = false;
  final String _siteKey = '6Lf07s4sAAAAALoVLAHH-cTu37py7XhutcCPsFUR';

  @override
  void initState() {
    super.initState();
    _determineDefaultLanguage();
    _nameController.addListener(() => setState(() {}));
    _loadLegislatures();
    
    // Stabilize the profiles future to prevent focus loss during typing
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _profilesFuture = Provider.of<Repository>(context, listen: false).getProfiles();
        });
      }
    });
    _initRecaptcha();
  }

  Future<void> _initRecaptcha() async {
    // Enterprise script is already loaded in index.html
    debugPrint('Recaptcha Enterprise service ready');
  }

  Future<void> _verifyHuman() async {
    setState(() => _isVerifying = true);
    try {
      final token = await RecaptchaService.execute(_siteKey, 'onboarding');
      if (token != null && token.isNotEmpty) {
        setState(() => _isVerified = true);
      }
    } catch (e) {
      debugPrint('Recaptcha Enterprise verification failed: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verification failed: $e')),
        );
      }
    } finally {
      setState(() => _isVerifying = false);
    }
  }

  void _determineDefaultLanguage() {
    final locale = WidgetsBinding.instance.platformDispatcher.locale;
    if (locale.languageCode.toLowerCase().startsWith('fr')) {
      _selectedLanguage = 'fr';
    } else {
      _selectedLanguage = 'en';
    }
  }

  Future<void> _loadLegislatures() async {
    try {
      final repo = Provider.of<Repository>(context, listen: false);
      final legs = await repo.getLegislatures();
      
      legs.sort((a, b) => a.name.compareTo(b.name));
      if (mounted) {
        setState(() {
          _legislatures = legs;
          // Set House of Commons as default if available
          try {
            _selectedLegislature = legs.firstWhere((l) => l.name == 'House of Commons');
          } catch (_) {
            _selectedLegislature = legs.isNotEmpty ? legs.first : null;
          }
        });
      }
    } catch (e) {
      debugPrint('Error loading legislatures: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error initializing database: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final l10n = L10n(_selectedLanguage); // Local preview during onboarding

    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 24),
              Text(
                _loadingStage == 1 
                  ? l10n.get('loading_reps')
                  : _loadingStage == 2
                    ? l10n.get('enhancing_status')
                    : 'Setting up your profile...',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primaryContainer,
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: FutureBuilder<List<Profile>>(
            future: _profilesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final profiles = snapshot.data ?? [];

              if (profiles.isEmpty || _isCreating) {
                return _buildOnboarding(context, appState, l10n);
              }

              return _buildProfileList(context, profiles, appState);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildOnboarding(BuildContext context, AppState appState, L10n l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          Icon(
            Icons.person_add_rounded,
            size: 80,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 24),
          Text(
            l10n.get('welcome'),
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.get('start_memorizing'),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: l10n.get('first_name'),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              prefixIcon: const Icon(Icons.badge),
            ),
          ),
          const SizedBox(height: 24),
          DropdownButtonFormField<String>(
            initialValue: _selectedLanguage,
            decoration: InputDecoration(
              labelText: l10n.get('language'),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              prefixIcon: const Icon(Icons.language),
            ),
            items: const [
              DropdownMenuItem(value: 'en', child: Text('English')),
              DropdownMenuItem(value: 'fr', child: Text('Français')),
            ],
            onChanged: (val) => setState(() => _selectedLanguage = val!),
          ),
          const SizedBox(height: 24),
          DropdownButtonFormField<Legislature>(
            isExpanded: true,
            initialValue: _selectedLegislature,
            decoration: InputDecoration(
              labelText: l10n.get('legislature'),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              prefixIcon: const Icon(Icons.account_balance),
            ),
            items: _legislatures.map((l) => DropdownMenuItem(
              value: l,
              child: Text(
                l.name,
                style: const TextStyle(fontSize: 14),
                softWrap: true,
              ),
            )).toList(),
            onChanged: (val) => setState(() => _selectedLegislature = val),
          ),
          const SizedBox(height: 24),
          if (!_isVerified) ...[
            OutlinedButton.icon(
              onPressed: _isVerifying ? null : _verifyHuman,
              icon: _isVerifying 
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.security),
              label: Text(_isVerifying ? 'Verifying...' : 'Verify you are human'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size.fromHeight(56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
            const SizedBox(height: 16),
          ],
          ElevatedButton(
            onPressed: (_nameController.text.trim().isEmpty || !_isVerified) ? null : () => _createProfile(appState),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(56),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: Text(l10n.get('start')),
          ),
          if (_isCreating)
            TextButton(
              onPressed: () => setState(() => _isCreating = false),
              child: Text(l10n.get('cancel')),
            ),
        ],
      ),
    );
  }

  Widget _buildProfileList(BuildContext context, List<Profile> profiles, AppState appState) {
    final l10n = appState.l10n;
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.get('whos_learning'),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              itemCount: profiles.length,
              itemBuilder: (context, index) {
                final profile = profiles[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: Text(
                        profile.firstName[0].toUpperCase(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      profile.firstName,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(profile.language == 'fr' ? 'Français' : 'English'),
                        if (profile.lastLegislatureId != null)
                          Text(
                            _legislatures.firstWhere(
                              (l) => l.id == profile.lastLegislatureId,
                              orElse: () => _legislatures.isNotEmpty ? _legislatures.first : Legislature(id: 0, name: '', openNorthId: '')
                            ).name,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.7),
                            ),
                          ),
                      ],
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => appState.setCurrentProfile(profile),
                  ),
                );
              },
            ),
          ),
          ElevatedButton.icon(
            onPressed: () => setState(() => _isCreating = true),
            icon: const Icon(Icons.add),
            label: Text(l10n.get('add_profile')),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(56),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _createProfile(AppState appState) async {
    final name = _nameController.text.trim();
    if (name.isEmpty || _selectedLegislature == null) return;

    setState(() => _isLoading = true);

    try {
      final scraper = Provider.of<ScraperService>(context, listen: false);
      final repository = Provider.of<Repository>(context, listen: false);

      // 1. Download data for the selected legislature
      final members = await scraper.fetchMembers(
        _selectedLegislature!.openNorthId, 
        name: _selectedLegislature!.name,
        onProgress: (stage) {
          if (mounted) setState(() => _loadingStage = stage);
        },
      );
      await repository.populateLegislature(_selectedLegislature!.name, _selectedLegislature!.openNorthId, members);

      // 2. Create the profile
      final profile = await repository.createProfile(
        name, 
        language: _selectedLanguage,
        lastLegislatureId: _selectedLegislature?.id,
      );

      // 3. Sync to backend
      await _syncProfileToBackend(profile, _selectedLegislature!);

      // 4. Set as current profile (this will transition to Home/Browse)
      await appState.setCurrentProfile(profile);
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Setup failed: $e')),
        );
      }
    }
  }

  Future<void> _syncProfileToBackend(Profile profile, Legislature leg) async {
    final url = Config.getFunctionUrl('syncProfile');

    try {
      final response = await http.post(
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

      if (response.statusCode != 200) {
        debugPrint('Backend sync failed: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error syncing profile to backend: $e');
      // We don't block the user if sync fails, but we log it.
    }
  }
}
