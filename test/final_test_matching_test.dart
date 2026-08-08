import 'package:flutter_test/flutter_test.dart';
import 'package:memreps/logic/string_utils.dart';

bool isExactAnswerMatch(String input, String target) {
  final normInput = StringUtils.normalize(input);
  final normTarget = StringUtils.normalize(target);
  if (normInput.isEmpty || normTarget.isEmpty) return false;
  return normInput == normTarget;
}

bool isExactSingleNameMatch(String input, String lastName) {
  final normInput = StringUtils.normalize(input);
  final normLast = StringUtils.normalize(lastName);
  if (normInput.isEmpty || normLast.isEmpty) return false;
  return normInput == normLast;
}

bool isExactFullNameMatch(String input, String firstName, String lastName) {
  final normInput = StringUtils.normalize(input);
  final normFirst = StringUtils.normalize(firstName);
  final normLast = StringUtils.normalize(lastName);

  if (normInput.isEmpty) return false;

  if (normInput == '$normFirst $normLast') return true;
  if (normInput == '$normLast $normFirst') return true;
  if (normInput == '$normLast, $normFirst') return true;

  final inputWords = normInput.replaceAll(',', ' ').split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
  final firstWords = normFirst.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
  final lastWords = normLast.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();

  if (inputWords.length != (firstWords.length + lastWords.length)) return false;

  final joinedInput = inputWords.join(' ');
  final expectedFirstLast = [...firstWords, ...lastWords].join(' ');
  final expectedLastFirst = [...lastWords, ...firstWords].join(' ');

  return joinedInput == expectedFirstLast || joinedInput == expectedLastFirst;
}

bool checkNameRecallMatch(String answer, String firstName, String lastName, bool hasRidingOptions) {
  if (hasRidingOptions) {
    final fullName = '$firstName $lastName';
    return StringUtils.isFuzzyMatch(answer, fullName) || StringUtils.isFuzzyMatch(answer, '$lastName $firstName');
  } else {
    return StringUtils.isFuzzyMatch(answer, lastName);
  }
}

void main() {
  group('Final Test Exact Matching Tests', () {
    test('Party exact spell check and case insensitivity', () {
      const actualParty = 'Liberal';

      expect(isExactAnswerMatch('Liberal', actualParty), isTrue);
      expect(isExactAnswerMatch('liberal', actualParty), isTrue);
      expect(isExactAnswerMatch('LIBERAL', actualParty), isTrue);
      expect(isExactAnswerMatch('  liberal ', actualParty), isTrue);

      // Typos or partial strings should fail
      expect(isExactAnswerMatch('Lib', actualParty), isFalse);
      expect(isExactAnswerMatch('Libeal', actualParty), isFalse);
      expect(isExactAnswerMatch('Liberals', actualParty), isFalse);
    });

    test('Riding exact spell check and word order matching', () {
      const actualRiding = 'Vancouver Centre';

      expect(isExactAnswerMatch('Vancouver Centre', actualRiding), isTrue);
      expect(isExactAnswerMatch('vancouver centre', actualRiding), isTrue);

      // Reversed word order must fail
      expect(isExactAnswerMatch('Centre Vancouver', actualRiding), isFalse);

      // Typos or partial strings must fail
      expect(isExactAnswerMatch('Vancouver Center', actualRiding), isFalse);
      expect(isExactAnswerMatch('Vancouver', actualRiding), isFalse);
    });

    test('Name exact spell check', () {
      const first = 'Justin';
      const last = 'Trudeau';

      // Full name matches
      expect(isExactFullNameMatch('Justin Trudeau', first, last), isTrue);
      expect(isExactFullNameMatch('justin trudeau', first, last), isTrue);
      expect(isExactFullNameMatch('Trudeau, Justin', first, last), isTrue);
      expect(isExactFullNameMatch('Trudeau Justin', first, last), isTrue);

      // Typos in name must fail
      expect(isExactFullNameMatch('Justn Trudeau', first, last), isFalse);
      expect(isExactFullNameMatch('Justin Trudau', first, last), isFalse);

      // Single name alone when full name required must fail full name match
      expect(isExactFullNameMatch('Trudeau', first, last), isFalse);

      // Single last name match when full name not required
      expect(isExactSingleNameMatch('Trudeau', last), isTrue);
      expect(isExactSingleNameMatch('trudeau', last), isTrue);
      expect(isExactSingleNameMatch('Trudau', last), isFalse);
    });

    test('Name Recall matching with and without duplicate name (riding options)', () {
      const first = 'Pierre';
      const last = 'Poilievre';

      // Without riding options (no duplicate name): last name is sufficient
      expect(checkNameRecallMatch('Poilievre', first, last, false), isTrue);
      expect(checkNameRecallMatch('poilievre', first, last, false), isTrue);

      // With riding options (duplicate name present): full name required
      expect(checkNameRecallMatch('Pierre Poilievre', first, last, true), isTrue);
      expect(checkNameRecallMatch('poilievre pierre', first, last, true), isTrue);
      expect(checkNameRecallMatch('Poilievre', first, last, true), isFalse);
    });
  });
}
