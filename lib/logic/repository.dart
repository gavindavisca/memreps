import 'package:fsrs/fsrs.dart' as fsrs;
import '../data/database.dart';
import 'package:drift/drift.dart';

class MemberWithStats {
  final Member member;
  final FsrsReview? review;

  MemberWithStats(this.member, this.review);

  double get memorizationPercentage {
    if (review == null || review!.totalQuestions == 0) return 0.0;
    return (review!.correctQuestions / review!.totalQuestions) * 100.0;
  }
}

class Repository {
  final AppDatabase db;
  final fsrs.FSRS scheduler = fsrs.FSRS();

  Repository(this.db);

  // Profile Management
  Future<List<Profile>> getProfiles() => db.select(db.profiles).get();
  
  Future<Profile> createProfile(String firstName, {String language = 'en', int? lastLegislatureId}) async {
    final companion = ProfilesCompanion.insert(
      firstName: firstName,
      language: Value(language),
      lastLegislatureId: Value(lastLegislatureId),
      lastUsedAt: Value(DateTime.now()),
      createdAt: Value(DateTime.now()),
    );
    final id = await db.into(db.profiles).insert(companion);
    return (db.select(db.profiles)..where((tbl) => tbl.id.equals(id))).getSingle();
  }

  Future<void> deleteProfile(int id) async {
    await db.transaction(() async {
      await (db.delete(db.fsrsReviews)..where((tbl) => tbl.userId.equals(id))).go();
      await (db.delete(db.profiles)..where((tbl) => tbl.id.equals(id))).go();
    });
  }

  Future<void> updateProfile(int id, String firstName) async {
    await (db.update(db.profiles)..where((tbl) => tbl.id.equals(id)))
        .write(ProfilesCompanion(firstName: Value(firstName)));
  }

  Future<Profile> updateProfileLanguage(int id, String language) async {
    await (db.update(db.profiles)..where((tbl) => tbl.id.equals(id)))
        .write(ProfilesCompanion(language: Value(language)));
    return (db.select(db.profiles)..where((tbl) => tbl.id.equals(id))).getSingle();
  }

  Future<void> updateProfileLastLegislature(int profileId, int? legislatureId) async {
    await (db.update(db.profiles)..where((tbl) => tbl.id.equals(profileId)))
        .write(ProfilesCompanion(lastLegislatureId: Value(legislatureId), lastUsedAt: Value(DateTime.now())));
  }

  Future<Profile?> getLastUsedProfile() async {
    final query = db.select(db.profiles)
      ..orderBy([(tbl) => OrderingTerm.desc(tbl.lastUsedAt)])
      ..limit(1);
    return query.getSingleOrNull();
  }

  Future<void> markProfileAsUsed(int id) async {
    await (db.update(db.profiles)..where((tbl) => tbl.id.equals(id)))
        .write(ProfilesCompanion(lastUsedAt: Value(DateTime.now())));
  }

  // Legislature Management
  Future<List<Legislature>> getLegislatures() => db.select(db.legislatures).get();

  // Used to initially populate a legislature after scraping
  Future<void> populateLegislature(String name, String openNorthId, List<MembersCompanion> members) async {
    return db.transaction(() async {
      // Create or update legislature
      final legQuery = db.select(db.legislatures)..where((tbl) => tbl.name.equals(name));
      Legislature? leg = await legQuery.getSingleOrNull();
      
      if (leg == null) {
        final legId = await db.into(db.legislatures).insert(
          LegislaturesCompanion.insert(
            name: name, 
            openNorthId: openNorthId,
            lastUpdated: Value(DateTime.now())
          ),
        );
        leg = await (db.select(db.legislatures)..where((tbl) => tbl.id.equals(legId))).getSingle();
      } else {
        // Clear existing members if refreshing
        await (db.delete(db.members)..where((tbl) => tbl.legislatureId.equals(leg!.id))).go();
        await (db.update(db.legislatures)..where((tbl) => tbl.id.equals(leg!.id)))
            .write(LegislaturesCompanion(lastUpdated: Value(DateTime.now())));
      }

      // Check for duplicate names to set requiresRidingDistinction
      final lastNames = members.map((m) => _normalizeName(m.lastName.value)).toList();
      final duplicateLastNames = <String>{};
      final seen = <String>{};
      for (var name in lastNames) {
        if (!seen.add(name)) {
          duplicateLastNames.add(name);
        }
      }

      // Add members
      for (var member in members) {
        final normalizedLastName = _normalizeName(member.lastName.value);
        final requiresDistinction = duplicateLastNames.contains(normalizedLastName);
        
        final comp = member.copyWith(
          legislatureId: Value(leg.id),
          requiresRidingDistinction: Value(requiresDistinction),
        );
        await db.into(db.members).insert(comp);
      }
    });
  }

  String _normalizeName(String name) {
    // Simple normalization: lowercase and trim. 
    // Further normalization (removing accents) could be added if needed.
    return name.toLowerCase().trim();
  }

  // Fetch Members for Browse or Quizzes
  Future<List<MemberWithStats>> getMembersWithStats(int userId, int legislatureId, {String? party, String? region}) async {
    final query = db.select(db.members).join([
      leftOuterJoin(db.fsrsReviews, 
        db.fsrsReviews.memberId.equalsExp(db.members.id) & 
        db.fsrsReviews.userId.equals(userId)
      ),
    ])..where(db.members.legislatureId.equals(legislatureId));
    
    if (party != null && party.isNotEmpty) {
      query.where(db.members.party.equals(party));
    }
    if (region != null && region.isNotEmpty) {
      query.where(db.members.region.equals(region));
    }
    
    // Sort by last name by default
    query.orderBy([OrderingTerm.asc(db.members.lastName)]);

    final rows = await query.get();
    return rows.map((row) {
      return MemberWithStats(
        row.readTable(db.members),
        row.readTableOrNull(db.fsrsReviews),
      );
    }).toList();
  }

  // Legacy getter (can be refactored or kept for simple uses)
  Future<List<Member>> getMembers(int legislatureId, {String? party, String? riding, String? region}) {
    final query = db.select(db.members)..where((tbl) => tbl.legislatureId.equals(legislatureId));
    
    if (party != null && party.isNotEmpty) {
      query.where((tbl) => tbl.party.equals(party));
    }
    if (riding != null && riding.isNotEmpty) {
      query.where((tbl) => tbl.riding.equals(riding));
    }
    if (region != null && region.isNotEmpty) {
      query.where((tbl) => tbl.region.equals(region));
    }
    
    return query.get();
  }

  // FSRS Scheduling Integration
  Future<FsrsReview?> getReviewState(int userId, int memberId) async {
    final query = db.select(db.fsrsReviews)
      ..where((tbl) => tbl.userId.equals(userId))
      ..where((tbl) => tbl.memberId.equals(memberId));
    return query.getSingleOrNull();
  }

  Future<void> submitReview(int userId, int memberId, fsrs.Rating rating) async {
    final currentReview = await getReviewState(userId, memberId);
    
    fsrs.Card card = fsrs.Card();
    if (currentReview != null) {
      card = fsrs.Card()
        ..state = fsrs.State.values[currentReview.state]
        ..due = currentReview.due
        ..stability = currentReview.stability
        ..difficulty = currentReview.difficulty
        ..elapsedDays = currentReview.elapsedDays
        ..scheduledDays = currentReview.scheduledDays
        ..reps = currentReview.reps
        ..lapses = currentReview.lapses
        ..lastReview = currentReview.lastReview ?? DateTime.now();
    }

    final schedulingCards = scheduler.repeat(card, DateTime.now());
    final nextCard = schedulingCards[rating]!.card;

    final companion = FsrsReviewsCompanion.insert(
      userId: userId,
      memberId: memberId,
      state: nextCard.state.index,
      due: nextCard.due,
      stability: nextCard.stability,
      difficulty: nextCard.difficulty,
      elapsedDays: nextCard.elapsedDays,
      scheduledDays: nextCard.scheduledDays,
      reps: nextCard.reps,
      lapses: nextCard.lapses,
      lastReview: Value(nextCard.lastReview),
      totalQuestions: Value((currentReview?.totalQuestions ?? 0) + 1),
      correctQuestions: Value((currentReview?.correctQuestions ?? 0) + (rating != fsrs.Rating.again ? 1 : 0)),
    );

    if (currentReview == null) {
      await db.into(db.fsrsReviews).insert(companion);
    } else {
      await (db.update(db.fsrsReviews)
        ..where((tbl) => tbl.id.equals(currentReview.id)))
        .write(companion);
    }
  }

  // Get members due for review
  Future<List<Member>> getDueReviews(int userId, int legislatureId) async {
    final now = DateTime.now();
    final query = db.select(db.members).join([
      innerJoin(db.fsrsReviews, db.fsrsReviews.memberId.equalsExp(db.members.id)),
    ])
      ..where(db.fsrsReviews.userId.equals(userId))
      ..where(db.members.legislatureId.equals(legislatureId))
      ..where(db.fsrsReviews.due.isSmallerOrEqualValue(now));
      
    final results = await query.get();
    return results.map((row) => row.readTable(db.members)).toList();
  }

  Future<void> saveQuizResult({
    required int userId,
    required String userName,
    required int legislatureId,
    required String quizModeId,
    required double filterPercentage,
    required double scorePercentage,
  }) async {
    await db.into(db.quizResults).insert(
      QuizResultsCompanion.insert(
        userId: userId,
        userName: userName,
        legislatureId: legislatureId,
        quizModeId: quizModeId,
        filterPercentage: filterPercentage,
        scorePercentage: scorePercentage,
        timestamp: Value(DateTime.now()),
      ),
    );
  }

  Future<List<QuizResult>> getQuizResults(int userId) {
    return (db.select(db.quizResults)
          ..where((tbl) => tbl.userId.equals(userId))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.timestamp)]))
        .get();
  }
}

