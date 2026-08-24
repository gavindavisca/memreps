import 'dart:math';

class StringUtils {
  /// Removes common accents/diacritics from a string while preserving case.
  static String removeAccents(String str) {
    var result = str;
    
    // Manual mapping of common accented characters found in Canadian names
    const accents = {
      'à': 'a', 'á': 'a', 'â': 'a', 'ã': 'a', 'ä': 'a', 'å': 'a',
      'À': 'A', 'Á': 'A', 'Â': 'A', 'Ã': 'A', 'Ä': 'A', 'Å': 'A',
      'è': 'e', 'é': 'e', 'ê': 'e', 'ë': 'e',
      'È': 'E', 'É': 'E', 'Ê': 'E', 'Ë': 'E',
      'ì': 'i', 'í': 'i', 'î': 'i', 'ï': 'i',
      'Ì': 'I', 'Í': 'I', 'Î': 'I', 'Ï': 'I',
      'ò': 'o', 'ó': 'o', 'ô': 'o', 'õ': 'o', 'ö': 'o',
      'Ò': 'O', 'Ó': 'O', 'Ô': 'O', 'Õ': 'O', 'Ö': 'O',
      'ù': 'u', 'ú': 'u', 'û': 'u', 'ü': 'u',
      'Ù': 'U', 'Ú': 'U', 'Û': 'U', 'Ü': 'U',
      'ç': 'c', 'Ç': 'C', 'ñ': 'n', 'Ñ': 'N',
    };

    accents.forEach((key, value) {
      result = result.replaceAll(key, value);
    });

    return result;
  }

  /// Normalizes a string by trimming, converting to lowercase, 
  /// and removing common accents/diacritics.
  static String normalize(String str) {
    return removeAccents(str.trim().toLowerCase());
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

  /// Checks if a query matches a target string either as a substring (after normalization)
  /// or as a fuzzy match. This is ideal for search boxes.
  static bool isFuzzySearch(String query, String target) {
    final normalizedQ = normalize(query);
    if (normalizedQ.isEmpty) return true;
    
    final normalizedT = normalize(target);
    if (normalizedT.contains(normalizedQ)) return true;
    
    return isFuzzyMatch(query, target);
  }

  /// Checks if two last names are considered duplicate last names (either identical
  /// after accent normalization, or matching a specific set of similar-sounding groups).
  static bool isDuplicateLastName(String name1, String name2) {
    final n1 = normalize(name1);
    final n2 = normalize(name2);
    
    if (n1 == n2) return true;
    
    // Homophones / confusable last name groups in the legislatures
    const phoneticGroups = [
      {'lewis', 'louis'},
      {'genereux', 'jeneroux'},
      {'mackinnon', 'mckinnon'},
      {'sarai', 'sari'},
    ];
    
    for (final group in phoneticGroups) {
      if (group.contains(n1) && group.contains(n2)) {
        return true;
      }
    }
    
    return false;
  }

  static const Map<String, String> _partyAliases = {
    // Liberal -> LIB
    'lib': 'liberal',
    'liberal': 'liberal',
    'liberals': 'liberal',
    'liberal party': 'liberal',
    'liberal party of canada': 'liberal',
    'parti liberal': 'liberal',
    'parti liberal du canada': 'liberal',
    'parti libéral': 'liberal',
    'parti libéral du canada': 'liberal',

    // Conservative -> CON
    'con': 'conservative',
    'conservative': 'conservative',
    'conservatives': 'conservative',
    'conservative party': 'conservative',
    'conservative party of canada': 'conservative',
    'parti conservateur': 'conservative',
    'parti conservateur du canada': 'conservative',
    'pc': 'conservative',
    'progressive conservative': 'conservative',
    'progressive conservative party': 'conservative',
    'ucp': 'conservative',
    'united conservative': 'conservative',
    'united conservative party': 'conservative',

    // New Democrat Party -> NDP
    'ndp': 'ndp',
    'npd': 'ndp',
    'new democrat': 'ndp',
    'new democrats': 'ndp',
    'new democrat party': 'ndp',
    'new democratic': 'ndp',
    'new democratic party': 'ndp',
    'new democratic party of canada': 'ndp',
    'nouveau parti democratique': 'ndp',
    'nouveau parti democratique du canada': 'ndp',
    'nouveau parti démocratique': 'ndp',
    'nouveau parti démocratique du canada': 'ndp',

    // Green -> GRN
    'grn': 'green',
    'green': 'green',
    'greens': 'green',
    'green party': 'green',
    'green party of canada': 'green',
    'parti vert': 'green',
    'parti vert du canada': 'green',

    // Bloc Quebois -> BQ
    'bq': 'bloc_quebecois',
    'bloc': 'bloc_quebecois',
    'bloc quebecois': 'bloc_quebecois',
    'bloc quebois': 'bloc_quebecois',
    'bloc quebec': 'bloc_quebecois',
    'bloc québécois': 'bloc_quebecois',
    'bloc québec': 'bloc_quebecois',

    // Indepenetn -> IND
    'ind': 'independent',
    'independent': 'independent',
    'independents': 'independent',
    'indepenetn': 'independent',
    'independant': 'independent',
    'indépendant': 'independent',

    // Regional parties
    'caq': 'caq',
    'coalition avenir quebec': 'caq',
    'coalition avenir québec': 'caq',
    'pq': 'parti_quebecois',
    'parti quebecois': 'parti_quebecois',
    'parti québécois': 'parti_quebecois',
    'qs': 'quebec_solidaire',
    'quebec solidaire': 'quebec_solidaire',
    'québec solidaire': 'quebec_solidaire',
    'sp': 'saskatchewan_party',
    'sask party': 'saskatchewan_party',
    'saskatchewan party': 'saskatchewan_party',
    'yp': 'yukon_party',
    'yukon party': 'yukon_party',
  };

  /// Returns canonical party identifier if recognized.
  static String? getCanonicalParty(String str) {
    final norm = normalize(str);
    return _partyAliases[norm];
  }

  /// Checks if a party input matches a target party name, allowing for abbreviations
  /// (case-insensitive, accent-insensitive) and party synonyms.
  static bool isPartyMatch(String input, String target) {
    final normInput = normalize(input);
    final normTarget = normalize(target);

    if (normInput.isEmpty || normTarget.isEmpty) return false;
    if (normInput == normTarget) return true;

    final inputCanonical = getCanonicalParty(normInput);
    final targetCanonical = getCanonicalParty(normTarget);

    if (inputCanonical != null && targetCanonical != null) {
      return inputCanonical == targetCanonical;
    }

    return false;
  }
}
