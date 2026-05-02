import 'package:flutter/foundation.dart';

class Config {
  static const String projectId = 'openclaw-bot-486015';
  static const String region = 'us-central1';
  
  /// Determines if the app is running locally (debug mode or on localhost).
  static bool get isLocal {
    if (kDebugMode) return true;
    if (kIsWeb) {
      final host = Uri.base.host;
      return host == 'localhost' || host == '127.0.0.1';
    }
    return false;
  }

  /// Returns the base URL for Firebase Functions.
  static String get functionsBaseUrl {
    if (isLocal) {
      return 'http://127.0.0.1:5001/$projectId/$region';
    }
    // Production base URL (using absolute paths as requested for GitHub Pages compatibility)
    return 'https://$region-$projectId.cloudfunctions.net';
  }

  /// Returns the full URL for a specific function.
  static String getFunctionUrl(String functionName) {
    if (isLocal) {
      return '$functionsBaseUrl/$functionName';
    }
    
    // In production, the URLs follow the pattern: https://[functionName]-[suffix].run.app
    // based on the existing code patterns.
    final Map<String, String> productionUrls = {
      'proxyData': 'https://proxydata-wq27mxu42a-uc.a.run.app',
      'proxyImage': 'https://proxyimage-wq27mxu42a-uc.a.run.app',
      'syncProfile': 'https://syncprofile-wq27mxu42a-uc.a.run.app',
      'syncQuizResult': 'https://syncquizresult-wq27mxu42a-uc.a.run.app',
      'getLeaderboard': 'https://getleaderboard-wq27mxu42a-uc.a.run.app',
    };

    return productionUrls[functionName] ?? 'https://$functionName-wq27mxu42a-uc.a.run.app';
  }
}
