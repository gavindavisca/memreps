import 'dart:math';

class StringUtils {
  /// Normalizes a string by trimming, converting to lowercase, 
  /// and removing common accents/diacritics.
  static String normalize(String str) {
    var result = str.trim().toLowerCase();
    
    // Manual mapping of common accented characters found in Canadian names
    const accents = {
      'à': 'a', 'á': 'a', 'â': 'a', 'ã': 'a', 'ä': 'a', 'å': 'a',
      'è': 'e', 'é': 'e', 'ê': 'e', 'ë': 'e',
      'ì': 'i', 'í': 'i', 'î': 'i', 'ï': 'i',
      'ò': 'o', 'ó': 'o', 'ô': 'o', 'õ': 'o', 'ö': 'o',
      'ù': 'u', 'ú': 'u', 'û': 'u', 'ü': 'u',
      'ç': 'c', 'ñ': 'n',
    };

    accents.forEach((key, value) {
      result = result.replaceAll(key, value);
    });

    return result;
  }

  /// Calculates the Levenshtein distance between two strings.
  /// This is the minimum number of single-character edits (insertions, 
  /// deletions or substitutions) required to change one word into the other.
  static int levenshtein(String s, String t) {
    if (s == t) return 0;
    if (s.isEmpty) return t.length;
    if (t.isEmpty) return s.length;

    List<int> v0 = List<int>.generate(t.length + 1, (i) => i);
    List<int> v1 = List<int>.filled(t.length + 1, 0);

    for (int i = 0; i < s.length; i++) {
      v1[0] = i + 1;

      for (int j = 0; j < t.length; j++) {
        int cost = (s[i] == t[j]) ? 0 : 1;
        v1[j + 1] = min(v1[j] + 1, min(v0[j + 1] + 1, v0[j] + cost));
      }

      for (int j = 0; j < v0.length; j++) {
        v0[j] = v1[j];
      }
    }

    return v0[t.length];
  }

  /// Checks if two strings are a fuzzy match based on normalization 
  /// and a Levenshtein distance threshold.
  static bool isFuzzyMatch(String input, String target) {
    final s1 = normalize(input);
    final s2 = normalize(target);

    if (s1 == s2) return true;
    if (s1.isEmpty || s2.isEmpty) return false;

    final distance = levenshtein(s1, s2);
    
    // Tolerance threshold logic:
    // For very short names (<= 3 chars), must be exact after normalization.
    // For names 4-7 chars, allow 1 typo.
    // For names 8+ chars, allow up to 2 typos.
    if (s2.length <= 3) return distance == 0;
    if (s2.length <= 7) return distance <= 1;
    return distance <= 2;
  }
}
