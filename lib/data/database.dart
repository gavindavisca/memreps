import 'package:drift/drift.dart';
import 'connection/connection.dart' as impl;

part 'database.g.dart';

class Profiles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get firstName => text().withLength(min: 1, max: 50)();
  IntColumn get lastLegislatureId => integer().nullable().references(Legislatures, #id)();
  TextColumn get language => text().withDefault(const Constant('en'))();
  TextColumn get uuid => text().nullable()(); // Using nullable for migration safety
  DateTimeColumn get lastUsedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class Legislatures extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get openNorthId => text().unique()();
  DateTimeColumn get lastUpdated => dateTime().nullable()();
}

class Members extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get legislatureId => integer().references(Legislatures, #id)();
  TextColumn get firstName => text()();
  TextColumn get lastName => text()();
  TextColumn get riding => text().nullable()();
  TextColumn get party => text().nullable()();
  TextColumn get title => text().nullable()();
  TextColumn get imageUrl => text()();
  TextColumn get region => text().nullable()();
  BoolColumn get requiresRidingDistinction => boolean().withDefault(const Constant(false))();
}

class FsrsReviews extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(Profiles, #id)();
  IntColumn get memberId => integer().references(Members, #id)();
  
  // FSRS specific fields
  IntColumn get state => integer()(); // 0: New, 1: Learning, 2: Review, 3: Relearning
  DateTimeColumn get due => dateTime()();
  RealColumn get stability => real()();
  RealColumn get difficulty => real()();
  IntColumn get elapsedDays => integer()();
  IntColumn get scheduledDays => integer()();
  IntColumn get reps => integer()();
  IntColumn get lapses => integer()();
  DateTimeColumn get lastReview => dateTime().nullable()();

  // Custom stats
  IntColumn get totalQuestions => integer().withDefault(const Constant(0))();
  IntColumn get correctQuestions => integer().withDefault(const Constant(0))();

  @override
  List<Set<Column>> get uniqueKeys => [{userId, memberId}];
}

class QuizResults extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get timestamp => dateTime().withDefault(currentDateAndTime)();
  IntColumn get userId => integer().references(Profiles, #id)();
  TextColumn get userName => text()();
  IntColumn get legislatureId => integer().references(Legislatures, #id)();
  TextColumn get quizModeId => text()(); // short name id
  RealColumn get filterPercentage => real()();
  RealColumn get scorePercentage => real()();
}

@DriftDatabase(tables: [Profiles, Legislatures, Members, FsrsReviews, QuizResults])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(impl.connect());

  @override
  int get schemaVersion => 10;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        await _seedLegislatures();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) await m.addColumn(members, members.region);
        if (from < 3) await m.addColumn(profiles, profiles.lastLegislatureId);
        if (from < 4) await m.addColumn(profiles, profiles.lastUsedAt);
        if (from < 5) await m.addColumn(profiles, profiles.language);
        if (from < 6) await m.addColumn(legislatures, legislatures.openNorthId);
        if (from < 7) {
          await m.addColumn(fsrsReviews, fsrsReviews.totalQuestions);
          await m.addColumn(fsrsReviews, fsrsReviews.correctQuestions);
        }
        if (from < 8) {
          // No structural changes, just seeding updated slugs
        }
        if (from < 9) {
          await m.createTable(quizResults);
        }
        if (from < 10) {
          await m.addColumn(profiles, profiles.uuid);
        }
        
        await _seedLegislatures();
      },
    );
  }

  Future<void> _seedLegislatures() async {
    final seedData = [
      ('House of Commons', 'house-of-commons'),
      ('Legislative Assembly of Alberta', 'alberta-legislature'),
      ('Legislative Assembly of British Columbia', 'bc-legislature'),
      ('Legislative Assembly of Manitoba', 'manitoba-legislature'),
      ('Legislative Assembly of New Brunswick', 'new-brunswick-legislature'),
      ('Newfoundland and Labrador House of Assembly', 'newfoundland-labrador-legislature'),
      ('Legislative Assembly of the Northwest Territories', 'northwest-territories-legislature'),
      ('Nova Scotia House of Assembly', 'nova-scotia-legislature'),
      ('Legislative Assembly of Ontario', 'ontario-legislature'),
      ('Legislative Assembly of Prince Edward Island', 'pei-legislature'),
      ('Assemblée nationale du Québec', 'quebec-assemblee-nationale'),
      ('Legislative Assembly of Saskatchewan', 'saskatchewan-legislature'),
      ('Legislative Assembly of Yukon', 'yukon-legislature'),
    ];

    for (final data in seedData) {
      // Use name as the key to update slugs if they change
      final existing = await (select(legislatures)..where((tbl) => tbl.name.equals(data.$1))).getSingleOrNull();
      if (existing != null) {
        await (update(legislatures)..where((tbl) => tbl.id.equals(existing.id)))
            .write(LegislaturesCompanion(openNorthId: Value(data.$2)));
      } else {
        await into(legislatures).insertOnConflictUpdate(
          LegislaturesCompanion.insert(
            name: data.$1, 
            openNorthId: data.$2,
          ),
        );
      }
    }
  }
}
