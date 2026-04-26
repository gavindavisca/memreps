import 'package:flutter/material.dart';
import '../data/database.dart';
import 'repository.dart';
import 'l10n.dart';

class AppState extends ChangeNotifier {
  final Repository repository;
  
  Profile? _currentProfile;
  Legislature? _currentLegislature;
  L10n _l10n = L10n('en');
  int _currentTabIndex = 0;

  AppState(this.repository) {
    _init();
  }

  Profile? get currentProfile => _currentProfile;
  Legislature? get currentLegislature => _currentLegislature;
  L10n get l10n => _l10n;
  int get currentTabIndex => _currentTabIndex;

  Future<void> _init() async {
    final lastProfile = await repository.getLastUsedProfile();
    if (lastProfile != null) {
      await setCurrentProfile(lastProfile);
    }
  }

  Future<void> setCurrentProfile(Profile? profile) async {
    _currentProfile = profile;
    _l10n = L10n(profile?.language ?? 'en');
    
    if (profile != null) {
      await repository.markProfileAsUsed(profile.id);
      
      if (profile.lastLegislatureId != null) {
        final legislatures = await repository.getLegislatures();
        _currentLegislature = legislatures.cast<Legislature?>().firstWhere(
          (l) => l?.id == profile.lastLegislatureId, 
          orElse: () => null
        );
      } else {
        _currentLegislature = null;
      }
    } else {
      _currentLegislature = null;
    }
    
    notifyListeners();
  }

  Future<void> setLanguage(String language) async {
    if (_currentProfile != null) {
      final updatedProfile = await repository.updateProfileLanguage(_currentProfile!.id, language);
      _currentProfile = updatedProfile;
      _l10n = L10n(language);
      notifyListeners();
    }
  }

  void setCurrentLegislature(Legislature? legislature) {
    _currentLegislature = legislature;
    // Only update DB if a real selection is made
    if (_currentProfile != null && legislature != null) {
      repository.updateProfileLastLegislature(_currentProfile!.id, legislature.id);
      _currentTabIndex = 0; // Reset to Browse tab
    }
    notifyListeners();
  }

  void setTabIndex(int index) {
    _currentTabIndex = index;
    notifyListeners();
  }

  Future<void> cancelLegislatureSelection() async {
    if (_currentProfile != null && _currentProfile!.lastLegislatureId != null) {
      final legislatures = await repository.getLegislatures();
      _currentLegislature = legislatures.cast<Legislature?>().firstWhere(
        (l) => l?.id == _currentProfile!.lastLegislatureId,
        orElse: () => null
      );
      notifyListeners();
    }
  }
}
