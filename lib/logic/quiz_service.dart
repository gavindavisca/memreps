import '../data/database.dart';

enum QuizMode {
  multipleChoice,
  activeRecall,
  reverseRecall,
}

class QuizQuestion {
  final Member member;
  final List<String>? options; // For Multiple Choice names
  final List<Member>? memberOptions; // For Reverse Recall faces
  final List<String>? partyOptions; // For Reverse Recall parties
  final List<String>? ridingOptions; // For Active Recall riding distinction
  final String? correctAnswer;
  final Member? correctMember;

  QuizQuestion({
    required this.member,
    this.options,
    this.memberOptions,
    this.partyOptions,
    this.ridingOptions,
    this.correctAnswer,
    this.correctMember,
  });
}

class QuizService {

  List<QuizQuestion> generateQuestions({
    required List<Member> members,
    required QuizMode mode,
    required List<Member> allLegislatureMembers,
  }) {
    return members.map((member) {
      switch (mode) {
        case QuizMode.multipleChoice:
          return _generateMultipleChoice(member, allLegislatureMembers);
        case QuizMode.activeRecall:
          return _generateActiveRecall(member, allLegislatureMembers);
        case QuizMode.reverseRecall:
          return _generateReverseRecall(member, allLegislatureMembers);
      }
    }).toList();
  }

  QuizQuestion _generateMultipleChoice(Member member, List<Member> allMembers) {
    final distractors = allMembers
        .where((m) => m.id != member.id)
        .toList()
      ..shuffle();
    
    final options = distractors.take(3).map((m) => '${m.firstName} ${m.lastName}').toList();
    options.add('${member.firstName} ${member.lastName}');
    options.shuffle();

    return QuizQuestion(
      member: member,
      options: options,
      correctAnswer: '${member.firstName} ${member.lastName}',
    );
  }

  QuizQuestion _generateActiveRecall(Member member, List<Member> allMembers) {
    // Requires typing the last name. 
    // If there's another member with the same last name (case-insensitive),
    // we must also ask for the riding.
    
    final normalizedLastName = member.lastName.toLowerCase().trim();
    final collisions = allMembers.where((m) => 
      m.id != member.id && 
      m.lastName.toLowerCase().trim() == normalizedLastName
    ).toList();

    List<String>? ridingOptions;
    if (collisions.isNotEmpty) {
      final otherRidings = collisions.map((m) => m.riding).whereType<String>().toSet().toList();
      final distractors = allMembers
          .where((m) => m.riding != null && m.riding != member.riding && !otherRidings.contains(m.riding))
          .map((m) => m.riding!)
          .toSet()
          .toList()
        ..shuffle();
      
      ridingOptions = [member.riding!];
      ridingOptions.addAll(otherRidings);
      ridingOptions.addAll(distractors.take(4 - ridingOptions.length));
      ridingOptions.shuffle();
    }

    return QuizQuestion(
      member: member,
      correctAnswer: member.lastName,
      ridingOptions: ridingOptions,
    );
  }

  QuizQuestion _generateReverseRecall(Member member, List<Member> allMembers) {
    // Show last name, identify member by image (1 of 4) and party (full list).
    final memberDistractors = allMembers
        .where((m) => m.id != member.id)
        .toList()
      ..shuffle();
    
    final memberOptions = memberDistractors.take(3).toList();
    memberOptions.add(member);
    memberOptions.shuffle();

    final partyOptions = allMembers
        .map((m) => m.party)
        .whereType<String>()
        .toSet()
        .toList()
      ..sort();

    return QuizQuestion(
      member: member,
      memberOptions: memberOptions,
      partyOptions: partyOptions,
      correctMember: member,
      correctAnswer: member.party,
    );
  }
}
