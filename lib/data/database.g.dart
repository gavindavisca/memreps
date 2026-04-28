// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $LegislaturesTable extends Legislatures
    with TableInfo<$LegislaturesTable, Legislature> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LegislaturesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _openNorthIdMeta = const VerificationMeta(
    'openNorthId',
  );
  @override
  late final GeneratedColumn<String> openNorthId = GeneratedColumn<String>(
    'open_north_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _lastUpdatedMeta = const VerificationMeta(
    'lastUpdated',
  );
  @override
  late final GeneratedColumn<DateTime> lastUpdated = GeneratedColumn<DateTime>(
    'last_updated',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, openNorthId, lastUpdated];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'legislatures';
  @override
  VerificationContext validateIntegrity(
    Insertable<Legislature> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('open_north_id')) {
      context.handle(
        _openNorthIdMeta,
        openNorthId.isAcceptableOrUnknown(
          data['open_north_id']!,
          _openNorthIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_openNorthIdMeta);
    }
    if (data.containsKey('last_updated')) {
      context.handle(
        _lastUpdatedMeta,
        lastUpdated.isAcceptableOrUnknown(
          data['last_updated']!,
          _lastUpdatedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Legislature map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Legislature(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      openNorthId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}open_north_id'],
      )!,
      lastUpdated: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_updated'],
      ),
    );
  }

  @override
  $LegislaturesTable createAlias(String alias) {
    return $LegislaturesTable(attachedDatabase, alias);
  }
}

class Legislature extends DataClass implements Insertable<Legislature> {
  final int id;
  final String name;
  final String openNorthId;
  final DateTime? lastUpdated;
  const Legislature({
    required this.id,
    required this.name,
    required this.openNorthId,
    this.lastUpdated,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['open_north_id'] = Variable<String>(openNorthId);
    if (!nullToAbsent || lastUpdated != null) {
      map['last_updated'] = Variable<DateTime>(lastUpdated);
    }
    return map;
  }

  LegislaturesCompanion toCompanion(bool nullToAbsent) {
    return LegislaturesCompanion(
      id: Value(id),
      name: Value(name),
      openNorthId: Value(openNorthId),
      lastUpdated: lastUpdated == null && nullToAbsent
          ? const Value.absent()
          : Value(lastUpdated),
    );
  }

  factory Legislature.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Legislature(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      openNorthId: serializer.fromJson<String>(json['openNorthId']),
      lastUpdated: serializer.fromJson<DateTime?>(json['lastUpdated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'openNorthId': serializer.toJson<String>(openNorthId),
      'lastUpdated': serializer.toJson<DateTime?>(lastUpdated),
    };
  }

  Legislature copyWith({
    int? id,
    String? name,
    String? openNorthId,
    Value<DateTime?> lastUpdated = const Value.absent(),
  }) => Legislature(
    id: id ?? this.id,
    name: name ?? this.name,
    openNorthId: openNorthId ?? this.openNorthId,
    lastUpdated: lastUpdated.present ? lastUpdated.value : this.lastUpdated,
  );
  Legislature copyWithCompanion(LegislaturesCompanion data) {
    return Legislature(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      openNorthId: data.openNorthId.present
          ? data.openNorthId.value
          : this.openNorthId,
      lastUpdated: data.lastUpdated.present
          ? data.lastUpdated.value
          : this.lastUpdated,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Legislature(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('openNorthId: $openNorthId, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, openNorthId, lastUpdated);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Legislature &&
          other.id == this.id &&
          other.name == this.name &&
          other.openNorthId == this.openNorthId &&
          other.lastUpdated == this.lastUpdated);
}

class LegislaturesCompanion extends UpdateCompanion<Legislature> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> openNorthId;
  final Value<DateTime?> lastUpdated;
  const LegislaturesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.openNorthId = const Value.absent(),
    this.lastUpdated = const Value.absent(),
  });
  LegislaturesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String openNorthId,
    this.lastUpdated = const Value.absent(),
  }) : name = Value(name),
       openNorthId = Value(openNorthId);
  static Insertable<Legislature> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? openNorthId,
    Expression<DateTime>? lastUpdated,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (openNorthId != null) 'open_north_id': openNorthId,
      if (lastUpdated != null) 'last_updated': lastUpdated,
    });
  }

  LegislaturesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? openNorthId,
    Value<DateTime?>? lastUpdated,
  }) {
    return LegislaturesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      openNorthId: openNorthId ?? this.openNorthId,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (openNorthId.present) {
      map['open_north_id'] = Variable<String>(openNorthId.value);
    }
    if (lastUpdated.present) {
      map['last_updated'] = Variable<DateTime>(lastUpdated.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LegislaturesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('openNorthId: $openNorthId, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }
}

class $ProfilesTable extends Profiles with TableInfo<$ProfilesTable, Profile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _firstNameMeta = const VerificationMeta(
    'firstName',
  );
  @override
  late final GeneratedColumn<String> firstName = GeneratedColumn<String>(
    'first_name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastLegislatureIdMeta = const VerificationMeta(
    'lastLegislatureId',
  );
  @override
  late final GeneratedColumn<int> lastLegislatureId = GeneratedColumn<int>(
    'last_legislature_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES legislatures (id)',
    ),
  );
  static const VerificationMeta _languageMeta = const VerificationMeta(
    'language',
  );
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
    'language',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('en'),
  );
  static const VerificationMeta _lastUsedAtMeta = const VerificationMeta(
    'lastUsedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastUsedAt = GeneratedColumn<DateTime>(
    'last_used_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    firstName,
    lastLegislatureId,
    language,
    lastUsedAt,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<Profile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('first_name')) {
      context.handle(
        _firstNameMeta,
        firstName.isAcceptableOrUnknown(data['first_name']!, _firstNameMeta),
      );
    } else if (isInserting) {
      context.missing(_firstNameMeta);
    }
    if (data.containsKey('last_legislature_id')) {
      context.handle(
        _lastLegislatureIdMeta,
        lastLegislatureId.isAcceptableOrUnknown(
          data['last_legislature_id']!,
          _lastLegislatureIdMeta,
        ),
      );
    }
    if (data.containsKey('language')) {
      context.handle(
        _languageMeta,
        language.isAcceptableOrUnknown(data['language']!, _languageMeta),
      );
    }
    if (data.containsKey('last_used_at')) {
      context.handle(
        _lastUsedAtMeta,
        lastUsedAt.isAcceptableOrUnknown(
          data['last_used_at']!,
          _lastUsedAtMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Profile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Profile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      firstName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}first_name'],
      )!,
      lastLegislatureId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_legislature_id'],
      ),
      language: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language'],
      )!,
      lastUsedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_used_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ProfilesTable createAlias(String alias) {
    return $ProfilesTable(attachedDatabase, alias);
  }
}

class Profile extends DataClass implements Insertable<Profile> {
  final int id;
  final String firstName;
  final int? lastLegislatureId;
  final String language;
  final DateTime? lastUsedAt;
  final DateTime createdAt;
  const Profile({
    required this.id,
    required this.firstName,
    this.lastLegislatureId,
    required this.language,
    this.lastUsedAt,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['first_name'] = Variable<String>(firstName);
    if (!nullToAbsent || lastLegislatureId != null) {
      map['last_legislature_id'] = Variable<int>(lastLegislatureId);
    }
    map['language'] = Variable<String>(language);
    if (!nullToAbsent || lastUsedAt != null) {
      map['last_used_at'] = Variable<DateTime>(lastUsedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ProfilesCompanion toCompanion(bool nullToAbsent) {
    return ProfilesCompanion(
      id: Value(id),
      firstName: Value(firstName),
      lastLegislatureId: lastLegislatureId == null && nullToAbsent
          ? const Value.absent()
          : Value(lastLegislatureId),
      language: Value(language),
      lastUsedAt: lastUsedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastUsedAt),
      createdAt: Value(createdAt),
    );
  }

  factory Profile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Profile(
      id: serializer.fromJson<int>(json['id']),
      firstName: serializer.fromJson<String>(json['firstName']),
      lastLegislatureId: serializer.fromJson<int?>(json['lastLegislatureId']),
      language: serializer.fromJson<String>(json['language']),
      lastUsedAt: serializer.fromJson<DateTime?>(json['lastUsedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'firstName': serializer.toJson<String>(firstName),
      'lastLegislatureId': serializer.toJson<int?>(lastLegislatureId),
      'language': serializer.toJson<String>(language),
      'lastUsedAt': serializer.toJson<DateTime?>(lastUsedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Profile copyWith({
    int? id,
    String? firstName,
    Value<int?> lastLegislatureId = const Value.absent(),
    String? language,
    Value<DateTime?> lastUsedAt = const Value.absent(),
    DateTime? createdAt,
  }) => Profile(
    id: id ?? this.id,
    firstName: firstName ?? this.firstName,
    lastLegislatureId: lastLegislatureId.present
        ? lastLegislatureId.value
        : this.lastLegislatureId,
    language: language ?? this.language,
    lastUsedAt: lastUsedAt.present ? lastUsedAt.value : this.lastUsedAt,
    createdAt: createdAt ?? this.createdAt,
  );
  Profile copyWithCompanion(ProfilesCompanion data) {
    return Profile(
      id: data.id.present ? data.id.value : this.id,
      firstName: data.firstName.present ? data.firstName.value : this.firstName,
      lastLegislatureId: data.lastLegislatureId.present
          ? data.lastLegislatureId.value
          : this.lastLegislatureId,
      language: data.language.present ? data.language.value : this.language,
      lastUsedAt: data.lastUsedAt.present
          ? data.lastUsedAt.value
          : this.lastUsedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Profile(')
          ..write('id: $id, ')
          ..write('firstName: $firstName, ')
          ..write('lastLegislatureId: $lastLegislatureId, ')
          ..write('language: $language, ')
          ..write('lastUsedAt: $lastUsedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    firstName,
    lastLegislatureId,
    language,
    lastUsedAt,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Profile &&
          other.id == this.id &&
          other.firstName == this.firstName &&
          other.lastLegislatureId == this.lastLegislatureId &&
          other.language == this.language &&
          other.lastUsedAt == this.lastUsedAt &&
          other.createdAt == this.createdAt);
}

class ProfilesCompanion extends UpdateCompanion<Profile> {
  final Value<int> id;
  final Value<String> firstName;
  final Value<int?> lastLegislatureId;
  final Value<String> language;
  final Value<DateTime?> lastUsedAt;
  final Value<DateTime> createdAt;
  const ProfilesCompanion({
    this.id = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastLegislatureId = const Value.absent(),
    this.language = const Value.absent(),
    this.lastUsedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ProfilesCompanion.insert({
    this.id = const Value.absent(),
    required String firstName,
    this.lastLegislatureId = const Value.absent(),
    this.language = const Value.absent(),
    this.lastUsedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : firstName = Value(firstName);
  static Insertable<Profile> custom({
    Expression<int>? id,
    Expression<String>? firstName,
    Expression<int>? lastLegislatureId,
    Expression<String>? language,
    Expression<DateTime>? lastUsedAt,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (firstName != null) 'first_name': firstName,
      if (lastLegislatureId != null) 'last_legislature_id': lastLegislatureId,
      if (language != null) 'language': language,
      if (lastUsedAt != null) 'last_used_at': lastUsedAt,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ProfilesCompanion copyWith({
    Value<int>? id,
    Value<String>? firstName,
    Value<int?>? lastLegislatureId,
    Value<String>? language,
    Value<DateTime?>? lastUsedAt,
    Value<DateTime>? createdAt,
  }) {
    return ProfilesCompanion(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastLegislatureId: lastLegislatureId ?? this.lastLegislatureId,
      language: language ?? this.language,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    if (lastLegislatureId.present) {
      map['last_legislature_id'] = Variable<int>(lastLegislatureId.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (lastUsedAt.present) {
      map['last_used_at'] = Variable<DateTime>(lastUsedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProfilesCompanion(')
          ..write('id: $id, ')
          ..write('firstName: $firstName, ')
          ..write('lastLegislatureId: $lastLegislatureId, ')
          ..write('language: $language, ')
          ..write('lastUsedAt: $lastUsedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $MembersTable extends Members with TableInfo<$MembersTable, Member> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MembersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _legislatureIdMeta = const VerificationMeta(
    'legislatureId',
  );
  @override
  late final GeneratedColumn<int> legislatureId = GeneratedColumn<int>(
    'legislature_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES legislatures (id)',
    ),
  );
  static const VerificationMeta _firstNameMeta = const VerificationMeta(
    'firstName',
  );
  @override
  late final GeneratedColumn<String> firstName = GeneratedColumn<String>(
    'first_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastNameMeta = const VerificationMeta(
    'lastName',
  );
  @override
  late final GeneratedColumn<String> lastName = GeneratedColumn<String>(
    'last_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ridingMeta = const VerificationMeta('riding');
  @override
  late final GeneratedColumn<String> riding = GeneratedColumn<String>(
    'riding',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _partyMeta = const VerificationMeta('party');
  @override
  late final GeneratedColumn<String> party = GeneratedColumn<String>(
    'party',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _regionMeta = const VerificationMeta('region');
  @override
  late final GeneratedColumn<String> region = GeneratedColumn<String>(
    'region',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _requiresRidingDistinctionMeta =
      const VerificationMeta('requiresRidingDistinction');
  @override
  late final GeneratedColumn<bool> requiresRidingDistinction =
      GeneratedColumn<bool>(
        'requires_riding_distinction',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("requires_riding_distinction" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    legislatureId,
    firstName,
    lastName,
    riding,
    party,
    title,
    imageUrl,
    region,
    requiresRidingDistinction,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'members';
  @override
  VerificationContext validateIntegrity(
    Insertable<Member> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('legislature_id')) {
      context.handle(
        _legislatureIdMeta,
        legislatureId.isAcceptableOrUnknown(
          data['legislature_id']!,
          _legislatureIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_legislatureIdMeta);
    }
    if (data.containsKey('first_name')) {
      context.handle(
        _firstNameMeta,
        firstName.isAcceptableOrUnknown(data['first_name']!, _firstNameMeta),
      );
    } else if (isInserting) {
      context.missing(_firstNameMeta);
    }
    if (data.containsKey('last_name')) {
      context.handle(
        _lastNameMeta,
        lastName.isAcceptableOrUnknown(data['last_name']!, _lastNameMeta),
      );
    } else if (isInserting) {
      context.missing(_lastNameMeta);
    }
    if (data.containsKey('riding')) {
      context.handle(
        _ridingMeta,
        riding.isAcceptableOrUnknown(data['riding']!, _ridingMeta),
      );
    }
    if (data.containsKey('party')) {
      context.handle(
        _partyMeta,
        party.isAcceptableOrUnknown(data['party']!, _partyMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    } else if (isInserting) {
      context.missing(_imageUrlMeta);
    }
    if (data.containsKey('region')) {
      context.handle(
        _regionMeta,
        region.isAcceptableOrUnknown(data['region']!, _regionMeta),
      );
    }
    if (data.containsKey('requires_riding_distinction')) {
      context.handle(
        _requiresRidingDistinctionMeta,
        requiresRidingDistinction.isAcceptableOrUnknown(
          data['requires_riding_distinction']!,
          _requiresRidingDistinctionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Member map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Member(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      legislatureId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}legislature_id'],
      )!,
      firstName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}first_name'],
      )!,
      lastName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_name'],
      )!,
      riding: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}riding'],
      ),
      party: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}party'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      ),
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      )!,
      region: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}region'],
      ),
      requiresRidingDistinction: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}requires_riding_distinction'],
      )!,
    );
  }

  @override
  $MembersTable createAlias(String alias) {
    return $MembersTable(attachedDatabase, alias);
  }
}

class Member extends DataClass implements Insertable<Member> {
  final int id;
  final int legislatureId;
  final String firstName;
  final String lastName;
  final String? riding;
  final String? party;
  final String? title;
  final String imageUrl;
  final String? region;
  final bool requiresRidingDistinction;
  const Member({
    required this.id,
    required this.legislatureId,
    required this.firstName,
    required this.lastName,
    this.riding,
    this.party,
    this.title,
    required this.imageUrl,
    this.region,
    required this.requiresRidingDistinction,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['legislature_id'] = Variable<int>(legislatureId);
    map['first_name'] = Variable<String>(firstName);
    map['last_name'] = Variable<String>(lastName);
    if (!nullToAbsent || riding != null) {
      map['riding'] = Variable<String>(riding);
    }
    if (!nullToAbsent || party != null) {
      map['party'] = Variable<String>(party);
    }
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    map['image_url'] = Variable<String>(imageUrl);
    if (!nullToAbsent || region != null) {
      map['region'] = Variable<String>(region);
    }
    map['requires_riding_distinction'] = Variable<bool>(
      requiresRidingDistinction,
    );
    return map;
  }

  MembersCompanion toCompanion(bool nullToAbsent) {
    return MembersCompanion(
      id: Value(id),
      legislatureId: Value(legislatureId),
      firstName: Value(firstName),
      lastName: Value(lastName),
      riding: riding == null && nullToAbsent
          ? const Value.absent()
          : Value(riding),
      party: party == null && nullToAbsent
          ? const Value.absent()
          : Value(party),
      title: title == null && nullToAbsent
          ? const Value.absent()
          : Value(title),
      imageUrl: Value(imageUrl),
      region: region == null && nullToAbsent
          ? const Value.absent()
          : Value(region),
      requiresRidingDistinction: Value(requiresRidingDistinction),
    );
  }

  factory Member.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Member(
      id: serializer.fromJson<int>(json['id']),
      legislatureId: serializer.fromJson<int>(json['legislatureId']),
      firstName: serializer.fromJson<String>(json['firstName']),
      lastName: serializer.fromJson<String>(json['lastName']),
      riding: serializer.fromJson<String?>(json['riding']),
      party: serializer.fromJson<String?>(json['party']),
      title: serializer.fromJson<String?>(json['title']),
      imageUrl: serializer.fromJson<String>(json['imageUrl']),
      region: serializer.fromJson<String?>(json['region']),
      requiresRidingDistinction: serializer.fromJson<bool>(
        json['requiresRidingDistinction'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'legislatureId': serializer.toJson<int>(legislatureId),
      'firstName': serializer.toJson<String>(firstName),
      'lastName': serializer.toJson<String>(lastName),
      'riding': serializer.toJson<String?>(riding),
      'party': serializer.toJson<String?>(party),
      'title': serializer.toJson<String?>(title),
      'imageUrl': serializer.toJson<String>(imageUrl),
      'region': serializer.toJson<String?>(region),
      'requiresRidingDistinction': serializer.toJson<bool>(
        requiresRidingDistinction,
      ),
    };
  }

  Member copyWith({
    int? id,
    int? legislatureId,
    String? firstName,
    String? lastName,
    Value<String?> riding = const Value.absent(),
    Value<String?> party = const Value.absent(),
    Value<String?> title = const Value.absent(),
    String? imageUrl,
    Value<String?> region = const Value.absent(),
    bool? requiresRidingDistinction,
  }) => Member(
    id: id ?? this.id,
    legislatureId: legislatureId ?? this.legislatureId,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    riding: riding.present ? riding.value : this.riding,
    party: party.present ? party.value : this.party,
    title: title.present ? title.value : this.title,
    imageUrl: imageUrl ?? this.imageUrl,
    region: region.present ? region.value : this.region,
    requiresRidingDistinction:
        requiresRidingDistinction ?? this.requiresRidingDistinction,
  );
  Member copyWithCompanion(MembersCompanion data) {
    return Member(
      id: data.id.present ? data.id.value : this.id,
      legislatureId: data.legislatureId.present
          ? data.legislatureId.value
          : this.legislatureId,
      firstName: data.firstName.present ? data.firstName.value : this.firstName,
      lastName: data.lastName.present ? data.lastName.value : this.lastName,
      riding: data.riding.present ? data.riding.value : this.riding,
      party: data.party.present ? data.party.value : this.party,
      title: data.title.present ? data.title.value : this.title,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      region: data.region.present ? data.region.value : this.region,
      requiresRidingDistinction: data.requiresRidingDistinction.present
          ? data.requiresRidingDistinction.value
          : this.requiresRidingDistinction,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Member(')
          ..write('id: $id, ')
          ..write('legislatureId: $legislatureId, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('riding: $riding, ')
          ..write('party: $party, ')
          ..write('title: $title, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('region: $region, ')
          ..write('requiresRidingDistinction: $requiresRidingDistinction')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    legislatureId,
    firstName,
    lastName,
    riding,
    party,
    title,
    imageUrl,
    region,
    requiresRidingDistinction,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Member &&
          other.id == this.id &&
          other.legislatureId == this.legislatureId &&
          other.firstName == this.firstName &&
          other.lastName == this.lastName &&
          other.riding == this.riding &&
          other.party == this.party &&
          other.title == this.title &&
          other.imageUrl == this.imageUrl &&
          other.region == this.region &&
          other.requiresRidingDistinction == this.requiresRidingDistinction);
}

class MembersCompanion extends UpdateCompanion<Member> {
  final Value<int> id;
  final Value<int> legislatureId;
  final Value<String> firstName;
  final Value<String> lastName;
  final Value<String?> riding;
  final Value<String?> party;
  final Value<String?> title;
  final Value<String> imageUrl;
  final Value<String?> region;
  final Value<bool> requiresRidingDistinction;
  const MembersCompanion({
    this.id = const Value.absent(),
    this.legislatureId = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.riding = const Value.absent(),
    this.party = const Value.absent(),
    this.title = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.region = const Value.absent(),
    this.requiresRidingDistinction = const Value.absent(),
  });
  MembersCompanion.insert({
    this.id = const Value.absent(),
    required int legislatureId,
    required String firstName,
    required String lastName,
    this.riding = const Value.absent(),
    this.party = const Value.absent(),
    this.title = const Value.absent(),
    required String imageUrl,
    this.region = const Value.absent(),
    this.requiresRidingDistinction = const Value.absent(),
  }) : legislatureId = Value(legislatureId),
       firstName = Value(firstName),
       lastName = Value(lastName),
       imageUrl = Value(imageUrl);
  static Insertable<Member> custom({
    Expression<int>? id,
    Expression<int>? legislatureId,
    Expression<String>? firstName,
    Expression<String>? lastName,
    Expression<String>? riding,
    Expression<String>? party,
    Expression<String>? title,
    Expression<String>? imageUrl,
    Expression<String>? region,
    Expression<bool>? requiresRidingDistinction,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (legislatureId != null) 'legislature_id': legislatureId,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (riding != null) 'riding': riding,
      if (party != null) 'party': party,
      if (title != null) 'title': title,
      if (imageUrl != null) 'image_url': imageUrl,
      if (region != null) 'region': region,
      if (requiresRidingDistinction != null)
        'requires_riding_distinction': requiresRidingDistinction,
    });
  }

  MembersCompanion copyWith({
    Value<int>? id,
    Value<int>? legislatureId,
    Value<String>? firstName,
    Value<String>? lastName,
    Value<String?>? riding,
    Value<String?>? party,
    Value<String?>? title,
    Value<String>? imageUrl,
    Value<String?>? region,
    Value<bool>? requiresRidingDistinction,
  }) {
    return MembersCompanion(
      id: id ?? this.id,
      legislatureId: legislatureId ?? this.legislatureId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      riding: riding ?? this.riding,
      party: party ?? this.party,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      region: region ?? this.region,
      requiresRidingDistinction:
          requiresRidingDistinction ?? this.requiresRidingDistinction,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (legislatureId.present) {
      map['legislature_id'] = Variable<int>(legislatureId.value);
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    if (lastName.present) {
      map['last_name'] = Variable<String>(lastName.value);
    }
    if (riding.present) {
      map['riding'] = Variable<String>(riding.value);
    }
    if (party.present) {
      map['party'] = Variable<String>(party.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (region.present) {
      map['region'] = Variable<String>(region.value);
    }
    if (requiresRidingDistinction.present) {
      map['requires_riding_distinction'] = Variable<bool>(
        requiresRidingDistinction.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MembersCompanion(')
          ..write('id: $id, ')
          ..write('legislatureId: $legislatureId, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('riding: $riding, ')
          ..write('party: $party, ')
          ..write('title: $title, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('region: $region, ')
          ..write('requiresRidingDistinction: $requiresRidingDistinction')
          ..write(')'))
        .toString();
  }
}

class $FsrsReviewsTable extends FsrsReviews
    with TableInfo<$FsrsReviewsTable, FsrsReview> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FsrsReviewsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES profiles (id)',
    ),
  );
  static const VerificationMeta _memberIdMeta = const VerificationMeta(
    'memberId',
  );
  @override
  late final GeneratedColumn<int> memberId = GeneratedColumn<int>(
    'member_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES members (id)',
    ),
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<int> state = GeneratedColumn<int>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dueMeta = const VerificationMeta('due');
  @override
  late final GeneratedColumn<DateTime> due = GeneratedColumn<DateTime>(
    'due',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stabilityMeta = const VerificationMeta(
    'stability',
  );
  @override
  late final GeneratedColumn<double> stability = GeneratedColumn<double>(
    'stability',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _difficultyMeta = const VerificationMeta(
    'difficulty',
  );
  @override
  late final GeneratedColumn<double> difficulty = GeneratedColumn<double>(
    'difficulty',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _elapsedDaysMeta = const VerificationMeta(
    'elapsedDays',
  );
  @override
  late final GeneratedColumn<int> elapsedDays = GeneratedColumn<int>(
    'elapsed_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scheduledDaysMeta = const VerificationMeta(
    'scheduledDays',
  );
  @override
  late final GeneratedColumn<int> scheduledDays = GeneratedColumn<int>(
    'scheduled_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repsMeta = const VerificationMeta('reps');
  @override
  late final GeneratedColumn<int> reps = GeneratedColumn<int>(
    'reps',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lapsesMeta = const VerificationMeta('lapses');
  @override
  late final GeneratedColumn<int> lapses = GeneratedColumn<int>(
    'lapses',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastReviewMeta = const VerificationMeta(
    'lastReview',
  );
  @override
  late final GeneratedColumn<DateTime> lastReview = GeneratedColumn<DateTime>(
    'last_review',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalQuestionsMeta = const VerificationMeta(
    'totalQuestions',
  );
  @override
  late final GeneratedColumn<int> totalQuestions = GeneratedColumn<int>(
    'total_questions',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _correctQuestionsMeta = const VerificationMeta(
    'correctQuestions',
  );
  @override
  late final GeneratedColumn<int> correctQuestions = GeneratedColumn<int>(
    'correct_questions',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    memberId,
    state,
    due,
    stability,
    difficulty,
    elapsedDays,
    scheduledDays,
    reps,
    lapses,
    lastReview,
    totalQuestions,
    correctQuestions,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'fsrs_reviews';
  @override
  VerificationContext validateIntegrity(
    Insertable<FsrsReview> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('member_id')) {
      context.handle(
        _memberIdMeta,
        memberId.isAcceptableOrUnknown(data['member_id']!, _memberIdMeta),
      );
    } else if (isInserting) {
      context.missing(_memberIdMeta);
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    } else if (isInserting) {
      context.missing(_stateMeta);
    }
    if (data.containsKey('due')) {
      context.handle(
        _dueMeta,
        due.isAcceptableOrUnknown(data['due']!, _dueMeta),
      );
    } else if (isInserting) {
      context.missing(_dueMeta);
    }
    if (data.containsKey('stability')) {
      context.handle(
        _stabilityMeta,
        stability.isAcceptableOrUnknown(data['stability']!, _stabilityMeta),
      );
    } else if (isInserting) {
      context.missing(_stabilityMeta);
    }
    if (data.containsKey('difficulty')) {
      context.handle(
        _difficultyMeta,
        difficulty.isAcceptableOrUnknown(data['difficulty']!, _difficultyMeta),
      );
    } else if (isInserting) {
      context.missing(_difficultyMeta);
    }
    if (data.containsKey('elapsed_days')) {
      context.handle(
        _elapsedDaysMeta,
        elapsedDays.isAcceptableOrUnknown(
          data['elapsed_days']!,
          _elapsedDaysMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_elapsedDaysMeta);
    }
    if (data.containsKey('scheduled_days')) {
      context.handle(
        _scheduledDaysMeta,
        scheduledDays.isAcceptableOrUnknown(
          data['scheduled_days']!,
          _scheduledDaysMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scheduledDaysMeta);
    }
    if (data.containsKey('reps')) {
      context.handle(
        _repsMeta,
        reps.isAcceptableOrUnknown(data['reps']!, _repsMeta),
      );
    } else if (isInserting) {
      context.missing(_repsMeta);
    }
    if (data.containsKey('lapses')) {
      context.handle(
        _lapsesMeta,
        lapses.isAcceptableOrUnknown(data['lapses']!, _lapsesMeta),
      );
    } else if (isInserting) {
      context.missing(_lapsesMeta);
    }
    if (data.containsKey('last_review')) {
      context.handle(
        _lastReviewMeta,
        lastReview.isAcceptableOrUnknown(data['last_review']!, _lastReviewMeta),
      );
    }
    if (data.containsKey('total_questions')) {
      context.handle(
        _totalQuestionsMeta,
        totalQuestions.isAcceptableOrUnknown(
          data['total_questions']!,
          _totalQuestionsMeta,
        ),
      );
    }
    if (data.containsKey('correct_questions')) {
      context.handle(
        _correctQuestionsMeta,
        correctQuestions.isAcceptableOrUnknown(
          data['correct_questions']!,
          _correctQuestionsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {userId, memberId},
  ];
  @override
  FsrsReview map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FsrsReview(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      )!,
      memberId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}member_id'],
      )!,
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}state'],
      )!,
      due: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due'],
      )!,
      stability: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}stability'],
      )!,
      difficulty: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}difficulty'],
      )!,
      elapsedDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}elapsed_days'],
      )!,
      scheduledDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}scheduled_days'],
      )!,
      reps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reps'],
      )!,
      lapses: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lapses'],
      )!,
      lastReview: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_review'],
      ),
      totalQuestions: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_questions'],
      )!,
      correctQuestions: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}correct_questions'],
      )!,
    );
  }

  @override
  $FsrsReviewsTable createAlias(String alias) {
    return $FsrsReviewsTable(attachedDatabase, alias);
  }
}

class FsrsReview extends DataClass implements Insertable<FsrsReview> {
  final int id;
  final int userId;
  final int memberId;
  final int state;
  final DateTime due;
  final double stability;
  final double difficulty;
  final int elapsedDays;
  final int scheduledDays;
  final int reps;
  final int lapses;
  final DateTime? lastReview;
  final int totalQuestions;
  final int correctQuestions;
  const FsrsReview({
    required this.id,
    required this.userId,
    required this.memberId,
    required this.state,
    required this.due,
    required this.stability,
    required this.difficulty,
    required this.elapsedDays,
    required this.scheduledDays,
    required this.reps,
    required this.lapses,
    this.lastReview,
    required this.totalQuestions,
    required this.correctQuestions,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['member_id'] = Variable<int>(memberId);
    map['state'] = Variable<int>(state);
    map['due'] = Variable<DateTime>(due);
    map['stability'] = Variable<double>(stability);
    map['difficulty'] = Variable<double>(difficulty);
    map['elapsed_days'] = Variable<int>(elapsedDays);
    map['scheduled_days'] = Variable<int>(scheduledDays);
    map['reps'] = Variable<int>(reps);
    map['lapses'] = Variable<int>(lapses);
    if (!nullToAbsent || lastReview != null) {
      map['last_review'] = Variable<DateTime>(lastReview);
    }
    map['total_questions'] = Variable<int>(totalQuestions);
    map['correct_questions'] = Variable<int>(correctQuestions);
    return map;
  }

  FsrsReviewsCompanion toCompanion(bool nullToAbsent) {
    return FsrsReviewsCompanion(
      id: Value(id),
      userId: Value(userId),
      memberId: Value(memberId),
      state: Value(state),
      due: Value(due),
      stability: Value(stability),
      difficulty: Value(difficulty),
      elapsedDays: Value(elapsedDays),
      scheduledDays: Value(scheduledDays),
      reps: Value(reps),
      lapses: Value(lapses),
      lastReview: lastReview == null && nullToAbsent
          ? const Value.absent()
          : Value(lastReview),
      totalQuestions: Value(totalQuestions),
      correctQuestions: Value(correctQuestions),
    );
  }

  factory FsrsReview.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FsrsReview(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      memberId: serializer.fromJson<int>(json['memberId']),
      state: serializer.fromJson<int>(json['state']),
      due: serializer.fromJson<DateTime>(json['due']),
      stability: serializer.fromJson<double>(json['stability']),
      difficulty: serializer.fromJson<double>(json['difficulty']),
      elapsedDays: serializer.fromJson<int>(json['elapsedDays']),
      scheduledDays: serializer.fromJson<int>(json['scheduledDays']),
      reps: serializer.fromJson<int>(json['reps']),
      lapses: serializer.fromJson<int>(json['lapses']),
      lastReview: serializer.fromJson<DateTime?>(json['lastReview']),
      totalQuestions: serializer.fromJson<int>(json['totalQuestions']),
      correctQuestions: serializer.fromJson<int>(json['correctQuestions']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'memberId': serializer.toJson<int>(memberId),
      'state': serializer.toJson<int>(state),
      'due': serializer.toJson<DateTime>(due),
      'stability': serializer.toJson<double>(stability),
      'difficulty': serializer.toJson<double>(difficulty),
      'elapsedDays': serializer.toJson<int>(elapsedDays),
      'scheduledDays': serializer.toJson<int>(scheduledDays),
      'reps': serializer.toJson<int>(reps),
      'lapses': serializer.toJson<int>(lapses),
      'lastReview': serializer.toJson<DateTime?>(lastReview),
      'totalQuestions': serializer.toJson<int>(totalQuestions),
      'correctQuestions': serializer.toJson<int>(correctQuestions),
    };
  }

  FsrsReview copyWith({
    int? id,
    int? userId,
    int? memberId,
    int? state,
    DateTime? due,
    double? stability,
    double? difficulty,
    int? elapsedDays,
    int? scheduledDays,
    int? reps,
    int? lapses,
    Value<DateTime?> lastReview = const Value.absent(),
    int? totalQuestions,
    int? correctQuestions,
  }) => FsrsReview(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    memberId: memberId ?? this.memberId,
    state: state ?? this.state,
    due: due ?? this.due,
    stability: stability ?? this.stability,
    difficulty: difficulty ?? this.difficulty,
    elapsedDays: elapsedDays ?? this.elapsedDays,
    scheduledDays: scheduledDays ?? this.scheduledDays,
    reps: reps ?? this.reps,
    lapses: lapses ?? this.lapses,
    lastReview: lastReview.present ? lastReview.value : this.lastReview,
    totalQuestions: totalQuestions ?? this.totalQuestions,
    correctQuestions: correctQuestions ?? this.correctQuestions,
  );
  FsrsReview copyWithCompanion(FsrsReviewsCompanion data) {
    return FsrsReview(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      memberId: data.memberId.present ? data.memberId.value : this.memberId,
      state: data.state.present ? data.state.value : this.state,
      due: data.due.present ? data.due.value : this.due,
      stability: data.stability.present ? data.stability.value : this.stability,
      difficulty: data.difficulty.present
          ? data.difficulty.value
          : this.difficulty,
      elapsedDays: data.elapsedDays.present
          ? data.elapsedDays.value
          : this.elapsedDays,
      scheduledDays: data.scheduledDays.present
          ? data.scheduledDays.value
          : this.scheduledDays,
      reps: data.reps.present ? data.reps.value : this.reps,
      lapses: data.lapses.present ? data.lapses.value : this.lapses,
      lastReview: data.lastReview.present
          ? data.lastReview.value
          : this.lastReview,
      totalQuestions: data.totalQuestions.present
          ? data.totalQuestions.value
          : this.totalQuestions,
      correctQuestions: data.correctQuestions.present
          ? data.correctQuestions.value
          : this.correctQuestions,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FsrsReview(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('memberId: $memberId, ')
          ..write('state: $state, ')
          ..write('due: $due, ')
          ..write('stability: $stability, ')
          ..write('difficulty: $difficulty, ')
          ..write('elapsedDays: $elapsedDays, ')
          ..write('scheduledDays: $scheduledDays, ')
          ..write('reps: $reps, ')
          ..write('lapses: $lapses, ')
          ..write('lastReview: $lastReview, ')
          ..write('totalQuestions: $totalQuestions, ')
          ..write('correctQuestions: $correctQuestions')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    memberId,
    state,
    due,
    stability,
    difficulty,
    elapsedDays,
    scheduledDays,
    reps,
    lapses,
    lastReview,
    totalQuestions,
    correctQuestions,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FsrsReview &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.memberId == this.memberId &&
          other.state == this.state &&
          other.due == this.due &&
          other.stability == this.stability &&
          other.difficulty == this.difficulty &&
          other.elapsedDays == this.elapsedDays &&
          other.scheduledDays == this.scheduledDays &&
          other.reps == this.reps &&
          other.lapses == this.lapses &&
          other.lastReview == this.lastReview &&
          other.totalQuestions == this.totalQuestions &&
          other.correctQuestions == this.correctQuestions);
}

class FsrsReviewsCompanion extends UpdateCompanion<FsrsReview> {
  final Value<int> id;
  final Value<int> userId;
  final Value<int> memberId;
  final Value<int> state;
  final Value<DateTime> due;
  final Value<double> stability;
  final Value<double> difficulty;
  final Value<int> elapsedDays;
  final Value<int> scheduledDays;
  final Value<int> reps;
  final Value<int> lapses;
  final Value<DateTime?> lastReview;
  final Value<int> totalQuestions;
  final Value<int> correctQuestions;
  const FsrsReviewsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.memberId = const Value.absent(),
    this.state = const Value.absent(),
    this.due = const Value.absent(),
    this.stability = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.elapsedDays = const Value.absent(),
    this.scheduledDays = const Value.absent(),
    this.reps = const Value.absent(),
    this.lapses = const Value.absent(),
    this.lastReview = const Value.absent(),
    this.totalQuestions = const Value.absent(),
    this.correctQuestions = const Value.absent(),
  });
  FsrsReviewsCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    required int memberId,
    required int state,
    required DateTime due,
    required double stability,
    required double difficulty,
    required int elapsedDays,
    required int scheduledDays,
    required int reps,
    required int lapses,
    this.lastReview = const Value.absent(),
    this.totalQuestions = const Value.absent(),
    this.correctQuestions = const Value.absent(),
  }) : userId = Value(userId),
       memberId = Value(memberId),
       state = Value(state),
       due = Value(due),
       stability = Value(stability),
       difficulty = Value(difficulty),
       elapsedDays = Value(elapsedDays),
       scheduledDays = Value(scheduledDays),
       reps = Value(reps),
       lapses = Value(lapses);
  static Insertable<FsrsReview> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<int>? memberId,
    Expression<int>? state,
    Expression<DateTime>? due,
    Expression<double>? stability,
    Expression<double>? difficulty,
    Expression<int>? elapsedDays,
    Expression<int>? scheduledDays,
    Expression<int>? reps,
    Expression<int>? lapses,
    Expression<DateTime>? lastReview,
    Expression<int>? totalQuestions,
    Expression<int>? correctQuestions,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (memberId != null) 'member_id': memberId,
      if (state != null) 'state': state,
      if (due != null) 'due': due,
      if (stability != null) 'stability': stability,
      if (difficulty != null) 'difficulty': difficulty,
      if (elapsedDays != null) 'elapsed_days': elapsedDays,
      if (scheduledDays != null) 'scheduled_days': scheduledDays,
      if (reps != null) 'reps': reps,
      if (lapses != null) 'lapses': lapses,
      if (lastReview != null) 'last_review': lastReview,
      if (totalQuestions != null) 'total_questions': totalQuestions,
      if (correctQuestions != null) 'correct_questions': correctQuestions,
    });
  }

  FsrsReviewsCompanion copyWith({
    Value<int>? id,
    Value<int>? userId,
    Value<int>? memberId,
    Value<int>? state,
    Value<DateTime>? due,
    Value<double>? stability,
    Value<double>? difficulty,
    Value<int>? elapsedDays,
    Value<int>? scheduledDays,
    Value<int>? reps,
    Value<int>? lapses,
    Value<DateTime?>? lastReview,
    Value<int>? totalQuestions,
    Value<int>? correctQuestions,
  }) {
    return FsrsReviewsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      memberId: memberId ?? this.memberId,
      state: state ?? this.state,
      due: due ?? this.due,
      stability: stability ?? this.stability,
      difficulty: difficulty ?? this.difficulty,
      elapsedDays: elapsedDays ?? this.elapsedDays,
      scheduledDays: scheduledDays ?? this.scheduledDays,
      reps: reps ?? this.reps,
      lapses: lapses ?? this.lapses,
      lastReview: lastReview ?? this.lastReview,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      correctQuestions: correctQuestions ?? this.correctQuestions,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (memberId.present) {
      map['member_id'] = Variable<int>(memberId.value);
    }
    if (state.present) {
      map['state'] = Variable<int>(state.value);
    }
    if (due.present) {
      map['due'] = Variable<DateTime>(due.value);
    }
    if (stability.present) {
      map['stability'] = Variable<double>(stability.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<double>(difficulty.value);
    }
    if (elapsedDays.present) {
      map['elapsed_days'] = Variable<int>(elapsedDays.value);
    }
    if (scheduledDays.present) {
      map['scheduled_days'] = Variable<int>(scheduledDays.value);
    }
    if (reps.present) {
      map['reps'] = Variable<int>(reps.value);
    }
    if (lapses.present) {
      map['lapses'] = Variable<int>(lapses.value);
    }
    if (lastReview.present) {
      map['last_review'] = Variable<DateTime>(lastReview.value);
    }
    if (totalQuestions.present) {
      map['total_questions'] = Variable<int>(totalQuestions.value);
    }
    if (correctQuestions.present) {
      map['correct_questions'] = Variable<int>(correctQuestions.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FsrsReviewsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('memberId: $memberId, ')
          ..write('state: $state, ')
          ..write('due: $due, ')
          ..write('stability: $stability, ')
          ..write('difficulty: $difficulty, ')
          ..write('elapsedDays: $elapsedDays, ')
          ..write('scheduledDays: $scheduledDays, ')
          ..write('reps: $reps, ')
          ..write('lapses: $lapses, ')
          ..write('lastReview: $lastReview, ')
          ..write('totalQuestions: $totalQuestions, ')
          ..write('correctQuestions: $correctQuestions')
          ..write(')'))
        .toString();
  }
}

class $QuizResultsTable extends QuizResults
    with TableInfo<$QuizResultsTable, QuizResult> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuizResultsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES profiles (id)',
    ),
  );
  static const VerificationMeta _userNameMeta = const VerificationMeta(
    'userName',
  );
  @override
  late final GeneratedColumn<String> userName = GeneratedColumn<String>(
    'user_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _legislatureIdMeta = const VerificationMeta(
    'legislatureId',
  );
  @override
  late final GeneratedColumn<int> legislatureId = GeneratedColumn<int>(
    'legislature_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES legislatures (id)',
    ),
  );
  static const VerificationMeta _quizModeIdMeta = const VerificationMeta(
    'quizModeId',
  );
  @override
  late final GeneratedColumn<String> quizModeId = GeneratedColumn<String>(
    'quiz_mode_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _filterPercentageMeta = const VerificationMeta(
    'filterPercentage',
  );
  @override
  late final GeneratedColumn<double> filterPercentage = GeneratedColumn<double>(
    'filter_percentage',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scorePercentageMeta = const VerificationMeta(
    'scorePercentage',
  );
  @override
  late final GeneratedColumn<double> scorePercentage = GeneratedColumn<double>(
    'score_percentage',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    timestamp,
    userId,
    userName,
    legislatureId,
    quizModeId,
    filterPercentage,
    scorePercentage,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quiz_results';
  @override
  VerificationContext validateIntegrity(
    Insertable<QuizResult> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('user_name')) {
      context.handle(
        _userNameMeta,
        userName.isAcceptableOrUnknown(data['user_name']!, _userNameMeta),
      );
    } else if (isInserting) {
      context.missing(_userNameMeta);
    }
    if (data.containsKey('legislature_id')) {
      context.handle(
        _legislatureIdMeta,
        legislatureId.isAcceptableOrUnknown(
          data['legislature_id']!,
          _legislatureIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_legislatureIdMeta);
    }
    if (data.containsKey('quiz_mode_id')) {
      context.handle(
        _quizModeIdMeta,
        quizModeId.isAcceptableOrUnknown(
          data['quiz_mode_id']!,
          _quizModeIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_quizModeIdMeta);
    }
    if (data.containsKey('filter_percentage')) {
      context.handle(
        _filterPercentageMeta,
        filterPercentage.isAcceptableOrUnknown(
          data['filter_percentage']!,
          _filterPercentageMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_filterPercentageMeta);
    }
    if (data.containsKey('score_percentage')) {
      context.handle(
        _scorePercentageMeta,
        scorePercentage.isAcceptableOrUnknown(
          data['score_percentage']!,
          _scorePercentageMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scorePercentageMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QuizResult map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuizResult(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      )!,
      userName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_name'],
      )!,
      legislatureId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}legislature_id'],
      )!,
      quizModeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quiz_mode_id'],
      )!,
      filterPercentage: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}filter_percentage'],
      )!,
      scorePercentage: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}score_percentage'],
      )!,
    );
  }

  @override
  $QuizResultsTable createAlias(String alias) {
    return $QuizResultsTable(attachedDatabase, alias);
  }
}

class QuizResult extends DataClass implements Insertable<QuizResult> {
  final int id;
  final DateTime timestamp;
  final int userId;
  final String userName;
  final int legislatureId;
  final String quizModeId;
  final double filterPercentage;
  final double scorePercentage;
  const QuizResult({
    required this.id,
    required this.timestamp,
    required this.userId,
    required this.userName,
    required this.legislatureId,
    required this.quizModeId,
    required this.filterPercentage,
    required this.scorePercentage,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['user_id'] = Variable<int>(userId);
    map['user_name'] = Variable<String>(userName);
    map['legislature_id'] = Variable<int>(legislatureId);
    map['quiz_mode_id'] = Variable<String>(quizModeId);
    map['filter_percentage'] = Variable<double>(filterPercentage);
    map['score_percentage'] = Variable<double>(scorePercentage);
    return map;
  }

  QuizResultsCompanion toCompanion(bool nullToAbsent) {
    return QuizResultsCompanion(
      id: Value(id),
      timestamp: Value(timestamp),
      userId: Value(userId),
      userName: Value(userName),
      legislatureId: Value(legislatureId),
      quizModeId: Value(quizModeId),
      filterPercentage: Value(filterPercentage),
      scorePercentage: Value(scorePercentage),
    );
  }

  factory QuizResult.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuizResult(
      id: serializer.fromJson<int>(json['id']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      userId: serializer.fromJson<int>(json['userId']),
      userName: serializer.fromJson<String>(json['userName']),
      legislatureId: serializer.fromJson<int>(json['legislatureId']),
      quizModeId: serializer.fromJson<String>(json['quizModeId']),
      filterPercentage: serializer.fromJson<double>(json['filterPercentage']),
      scorePercentage: serializer.fromJson<double>(json['scorePercentage']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'userId': serializer.toJson<int>(userId),
      'userName': serializer.toJson<String>(userName),
      'legislatureId': serializer.toJson<int>(legislatureId),
      'quizModeId': serializer.toJson<String>(quizModeId),
      'filterPercentage': serializer.toJson<double>(filterPercentage),
      'scorePercentage': serializer.toJson<double>(scorePercentage),
    };
  }

  QuizResult copyWith({
    int? id,
    DateTime? timestamp,
    int? userId,
    String? userName,
    int? legislatureId,
    String? quizModeId,
    double? filterPercentage,
    double? scorePercentage,
  }) => QuizResult(
    id: id ?? this.id,
    timestamp: timestamp ?? this.timestamp,
    userId: userId ?? this.userId,
    userName: userName ?? this.userName,
    legislatureId: legislatureId ?? this.legislatureId,
    quizModeId: quizModeId ?? this.quizModeId,
    filterPercentage: filterPercentage ?? this.filterPercentage,
    scorePercentage: scorePercentage ?? this.scorePercentage,
  );
  QuizResult copyWithCompanion(QuizResultsCompanion data) {
    return QuizResult(
      id: data.id.present ? data.id.value : this.id,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      userId: data.userId.present ? data.userId.value : this.userId,
      userName: data.userName.present ? data.userName.value : this.userName,
      legislatureId: data.legislatureId.present
          ? data.legislatureId.value
          : this.legislatureId,
      quizModeId: data.quizModeId.present
          ? data.quizModeId.value
          : this.quizModeId,
      filterPercentage: data.filterPercentage.present
          ? data.filterPercentage.value
          : this.filterPercentage,
      scorePercentage: data.scorePercentage.present
          ? data.scorePercentage.value
          : this.scorePercentage,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuizResult(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('userId: $userId, ')
          ..write('userName: $userName, ')
          ..write('legislatureId: $legislatureId, ')
          ..write('quizModeId: $quizModeId, ')
          ..write('filterPercentage: $filterPercentage, ')
          ..write('scorePercentage: $scorePercentage')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    timestamp,
    userId,
    userName,
    legislatureId,
    quizModeId,
    filterPercentage,
    scorePercentage,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuizResult &&
          other.id == this.id &&
          other.timestamp == this.timestamp &&
          other.userId == this.userId &&
          other.userName == this.userName &&
          other.legislatureId == this.legislatureId &&
          other.quizModeId == this.quizModeId &&
          other.filterPercentage == this.filterPercentage &&
          other.scorePercentage == this.scorePercentage);
}

class QuizResultsCompanion extends UpdateCompanion<QuizResult> {
  final Value<int> id;
  final Value<DateTime> timestamp;
  final Value<int> userId;
  final Value<String> userName;
  final Value<int> legislatureId;
  final Value<String> quizModeId;
  final Value<double> filterPercentage;
  final Value<double> scorePercentage;
  const QuizResultsCompanion({
    this.id = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.userId = const Value.absent(),
    this.userName = const Value.absent(),
    this.legislatureId = const Value.absent(),
    this.quizModeId = const Value.absent(),
    this.filterPercentage = const Value.absent(),
    this.scorePercentage = const Value.absent(),
  });
  QuizResultsCompanion.insert({
    this.id = const Value.absent(),
    this.timestamp = const Value.absent(),
    required int userId,
    required String userName,
    required int legislatureId,
    required String quizModeId,
    required double filterPercentage,
    required double scorePercentage,
  }) : userId = Value(userId),
       userName = Value(userName),
       legislatureId = Value(legislatureId),
       quizModeId = Value(quizModeId),
       filterPercentage = Value(filterPercentage),
       scorePercentage = Value(scorePercentage);
  static Insertable<QuizResult> custom({
    Expression<int>? id,
    Expression<DateTime>? timestamp,
    Expression<int>? userId,
    Expression<String>? userName,
    Expression<int>? legislatureId,
    Expression<String>? quizModeId,
    Expression<double>? filterPercentage,
    Expression<double>? scorePercentage,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (timestamp != null) 'timestamp': timestamp,
      if (userId != null) 'user_id': userId,
      if (userName != null) 'user_name': userName,
      if (legislatureId != null) 'legislature_id': legislatureId,
      if (quizModeId != null) 'quiz_mode_id': quizModeId,
      if (filterPercentage != null) 'filter_percentage': filterPercentage,
      if (scorePercentage != null) 'score_percentage': scorePercentage,
    });
  }

  QuizResultsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? timestamp,
    Value<int>? userId,
    Value<String>? userName,
    Value<int>? legislatureId,
    Value<String>? quizModeId,
    Value<double>? filterPercentage,
    Value<double>? scorePercentage,
  }) {
    return QuizResultsCompanion(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      legislatureId: legislatureId ?? this.legislatureId,
      quizModeId: quizModeId ?? this.quizModeId,
      filterPercentage: filterPercentage ?? this.filterPercentage,
      scorePercentage: scorePercentage ?? this.scorePercentage,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (userName.present) {
      map['user_name'] = Variable<String>(userName.value);
    }
    if (legislatureId.present) {
      map['legislature_id'] = Variable<int>(legislatureId.value);
    }
    if (quizModeId.present) {
      map['quiz_mode_id'] = Variable<String>(quizModeId.value);
    }
    if (filterPercentage.present) {
      map['filter_percentage'] = Variable<double>(filterPercentage.value);
    }
    if (scorePercentage.present) {
      map['score_percentage'] = Variable<double>(scorePercentage.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuizResultsCompanion(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('userId: $userId, ')
          ..write('userName: $userName, ')
          ..write('legislatureId: $legislatureId, ')
          ..write('quizModeId: $quizModeId, ')
          ..write('filterPercentage: $filterPercentage, ')
          ..write('scorePercentage: $scorePercentage')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $LegislaturesTable legislatures = $LegislaturesTable(this);
  late final $ProfilesTable profiles = $ProfilesTable(this);
  late final $MembersTable members = $MembersTable(this);
  late final $FsrsReviewsTable fsrsReviews = $FsrsReviewsTable(this);
  late final $QuizResultsTable quizResults = $QuizResultsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    legislatures,
    profiles,
    members,
    fsrsReviews,
    quizResults,
  ];
}

typedef $$LegislaturesTableCreateCompanionBuilder =
    LegislaturesCompanion Function({
      Value<int> id,
      required String name,
      required String openNorthId,
      Value<DateTime?> lastUpdated,
    });
typedef $$LegislaturesTableUpdateCompanionBuilder =
    LegislaturesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> openNorthId,
      Value<DateTime?> lastUpdated,
    });

final class $$LegislaturesTableReferences
    extends BaseReferences<_$AppDatabase, $LegislaturesTable, Legislature> {
  $$LegislaturesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ProfilesTable, List<Profile>> _profilesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.profiles,
    aliasName: $_aliasNameGenerator(
      db.legislatures.id,
      db.profiles.lastLegislatureId,
    ),
  );

  $$ProfilesTableProcessedTableManager get profilesRefs {
    final manager = $$ProfilesTableTableManager(
      $_db,
      $_db.profiles,
    ).filter((f) => f.lastLegislatureId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_profilesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MembersTable, List<Member>> _membersRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.members,
    aliasName: $_aliasNameGenerator(
      db.legislatures.id,
      db.members.legislatureId,
    ),
  );

  $$MembersTableProcessedTableManager get membersRefs {
    final manager = $$MembersTableTableManager(
      $_db,
      $_db.members,
    ).filter((f) => f.legislatureId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_membersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$QuizResultsTable, List<QuizResult>>
  _quizResultsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.quizResults,
    aliasName: $_aliasNameGenerator(
      db.legislatures.id,
      db.quizResults.legislatureId,
    ),
  );

  $$QuizResultsTableProcessedTableManager get quizResultsRefs {
    final manager = $$QuizResultsTableTableManager(
      $_db,
      $_db.quizResults,
    ).filter((f) => f.legislatureId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_quizResultsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LegislaturesTableFilterComposer
    extends Composer<_$AppDatabase, $LegislaturesTable> {
  $$LegislaturesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get openNorthId => $composableBuilder(
    column: $table.openNorthId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> profilesRefs(
    Expression<bool> Function($$ProfilesTableFilterComposer f) f,
  ) {
    final $$ProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.lastLegislatureId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableFilterComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> membersRefs(
    Expression<bool> Function($$MembersTableFilterComposer f) f,
  ) {
    final $$MembersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.legislatureId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableFilterComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> quizResultsRefs(
    Expression<bool> Function($$QuizResultsTableFilterComposer f) f,
  ) {
    final $$QuizResultsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.quizResults,
      getReferencedColumn: (t) => t.legislatureId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizResultsTableFilterComposer(
            $db: $db,
            $table: $db.quizResults,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LegislaturesTableOrderingComposer
    extends Composer<_$AppDatabase, $LegislaturesTable> {
  $$LegislaturesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get openNorthId => $composableBuilder(
    column: $table.openNorthId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LegislaturesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LegislaturesTable> {
  $$LegislaturesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get openNorthId => $composableBuilder(
    column: $table.openNorthId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => column,
  );

  Expression<T> profilesRefs<T extends Object>(
    Expression<T> Function($$ProfilesTableAnnotationComposer a) f,
  ) {
    final $$ProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.lastLegislatureId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> membersRefs<T extends Object>(
    Expression<T> Function($$MembersTableAnnotationComposer a) f,
  ) {
    final $$MembersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.legislatureId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableAnnotationComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> quizResultsRefs<T extends Object>(
    Expression<T> Function($$QuizResultsTableAnnotationComposer a) f,
  ) {
    final $$QuizResultsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.quizResults,
      getReferencedColumn: (t) => t.legislatureId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizResultsTableAnnotationComposer(
            $db: $db,
            $table: $db.quizResults,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LegislaturesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LegislaturesTable,
          Legislature,
          $$LegislaturesTableFilterComposer,
          $$LegislaturesTableOrderingComposer,
          $$LegislaturesTableAnnotationComposer,
          $$LegislaturesTableCreateCompanionBuilder,
          $$LegislaturesTableUpdateCompanionBuilder,
          (Legislature, $$LegislaturesTableReferences),
          Legislature,
          PrefetchHooks Function({
            bool profilesRefs,
            bool membersRefs,
            bool quizResultsRefs,
          })
        > {
  $$LegislaturesTableTableManager(_$AppDatabase db, $LegislaturesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LegislaturesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LegislaturesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LegislaturesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> openNorthId = const Value.absent(),
                Value<DateTime?> lastUpdated = const Value.absent(),
              }) => LegislaturesCompanion(
                id: id,
                name: name,
                openNorthId: openNorthId,
                lastUpdated: lastUpdated,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String openNorthId,
                Value<DateTime?> lastUpdated = const Value.absent(),
              }) => LegislaturesCompanion.insert(
                id: id,
                name: name,
                openNorthId: openNorthId,
                lastUpdated: lastUpdated,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LegislaturesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                profilesRefs = false,
                membersRefs = false,
                quizResultsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (profilesRefs) db.profiles,
                    if (membersRefs) db.members,
                    if (quizResultsRefs) db.quizResults,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (profilesRefs)
                        await $_getPrefetchedData<
                          Legislature,
                          $LegislaturesTable,
                          Profile
                        >(
                          currentTable: table,
                          referencedTable: $$LegislaturesTableReferences
                              ._profilesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LegislaturesTableReferences(
                                db,
                                table,
                                p0,
                              ).profilesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.lastLegislatureId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (membersRefs)
                        await $_getPrefetchedData<
                          Legislature,
                          $LegislaturesTable,
                          Member
                        >(
                          currentTable: table,
                          referencedTable: $$LegislaturesTableReferences
                              ._membersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LegislaturesTableReferences(
                                db,
                                table,
                                p0,
                              ).membersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.legislatureId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (quizResultsRefs)
                        await $_getPrefetchedData<
                          Legislature,
                          $LegislaturesTable,
                          QuizResult
                        >(
                          currentTable: table,
                          referencedTable: $$LegislaturesTableReferences
                              ._quizResultsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LegislaturesTableReferences(
                                db,
                                table,
                                p0,
                              ).quizResultsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.legislatureId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$LegislaturesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LegislaturesTable,
      Legislature,
      $$LegislaturesTableFilterComposer,
      $$LegislaturesTableOrderingComposer,
      $$LegislaturesTableAnnotationComposer,
      $$LegislaturesTableCreateCompanionBuilder,
      $$LegislaturesTableUpdateCompanionBuilder,
      (Legislature, $$LegislaturesTableReferences),
      Legislature,
      PrefetchHooks Function({
        bool profilesRefs,
        bool membersRefs,
        bool quizResultsRefs,
      })
    >;
typedef $$ProfilesTableCreateCompanionBuilder =
    ProfilesCompanion Function({
      Value<int> id,
      required String firstName,
      Value<int?> lastLegislatureId,
      Value<String> language,
      Value<DateTime?> lastUsedAt,
      Value<DateTime> createdAt,
    });
typedef $$ProfilesTableUpdateCompanionBuilder =
    ProfilesCompanion Function({
      Value<int> id,
      Value<String> firstName,
      Value<int?> lastLegislatureId,
      Value<String> language,
      Value<DateTime?> lastUsedAt,
      Value<DateTime> createdAt,
    });

final class $$ProfilesTableReferences
    extends BaseReferences<_$AppDatabase, $ProfilesTable, Profile> {
  $$ProfilesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $LegislaturesTable _lastLegislatureIdTable(_$AppDatabase db) =>
      db.legislatures.createAlias(
        $_aliasNameGenerator(db.profiles.lastLegislatureId, db.legislatures.id),
      );

  $$LegislaturesTableProcessedTableManager? get lastLegislatureId {
    final $_column = $_itemColumn<int>('last_legislature_id');
    if ($_column == null) return null;
    final manager = $$LegislaturesTableTableManager(
      $_db,
      $_db.legislatures,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_lastLegislatureIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$FsrsReviewsTable, List<FsrsReview>>
  _fsrsReviewsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.fsrsReviews,
    aliasName: $_aliasNameGenerator(db.profiles.id, db.fsrsReviews.userId),
  );

  $$FsrsReviewsTableProcessedTableManager get fsrsReviewsRefs {
    final manager = $$FsrsReviewsTableTableManager(
      $_db,
      $_db.fsrsReviews,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_fsrsReviewsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$QuizResultsTable, List<QuizResult>>
  _quizResultsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.quizResults,
    aliasName: $_aliasNameGenerator(db.profiles.id, db.quizResults.userId),
  );

  $$QuizResultsTableProcessedTableManager get quizResultsRefs {
    final manager = $$QuizResultsTableTableManager(
      $_db,
      $_db.quizResults,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_quizResultsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastUsedAt => $composableBuilder(
    column: $table.lastUsedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$LegislaturesTableFilterComposer get lastLegislatureId {
    final $$LegislaturesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lastLegislatureId,
      referencedTable: $db.legislatures,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LegislaturesTableFilterComposer(
            $db: $db,
            $table: $db.legislatures,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> fsrsReviewsRefs(
    Expression<bool> Function($$FsrsReviewsTableFilterComposer f) f,
  ) {
    final $$FsrsReviewsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.fsrsReviews,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FsrsReviewsTableFilterComposer(
            $db: $db,
            $table: $db.fsrsReviews,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> quizResultsRefs(
    Expression<bool> Function($$QuizResultsTableFilterComposer f) f,
  ) {
    final $$QuizResultsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.quizResults,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizResultsTableFilterComposer(
            $db: $db,
            $table: $db.quizResults,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastUsedAt => $composableBuilder(
    column: $table.lastUsedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$LegislaturesTableOrderingComposer get lastLegislatureId {
    final $$LegislaturesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lastLegislatureId,
      referencedTable: $db.legislatures,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LegislaturesTableOrderingComposer(
            $db: $db,
            $table: $db.legislatures,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get firstName =>
      $composableBuilder(column: $table.firstName, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<DateTime> get lastUsedAt => $composableBuilder(
    column: $table.lastUsedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$LegislaturesTableAnnotationComposer get lastLegislatureId {
    final $$LegislaturesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lastLegislatureId,
      referencedTable: $db.legislatures,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LegislaturesTableAnnotationComposer(
            $db: $db,
            $table: $db.legislatures,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> fsrsReviewsRefs<T extends Object>(
    Expression<T> Function($$FsrsReviewsTableAnnotationComposer a) f,
  ) {
    final $$FsrsReviewsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.fsrsReviews,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FsrsReviewsTableAnnotationComposer(
            $db: $db,
            $table: $db.fsrsReviews,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> quizResultsRefs<T extends Object>(
    Expression<T> Function($$QuizResultsTableAnnotationComposer a) f,
  ) {
    final $$QuizResultsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.quizResults,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizResultsTableAnnotationComposer(
            $db: $db,
            $table: $db.quizResults,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProfilesTable,
          Profile,
          $$ProfilesTableFilterComposer,
          $$ProfilesTableOrderingComposer,
          $$ProfilesTableAnnotationComposer,
          $$ProfilesTableCreateCompanionBuilder,
          $$ProfilesTableUpdateCompanionBuilder,
          (Profile, $$ProfilesTableReferences),
          Profile,
          PrefetchHooks Function({
            bool lastLegislatureId,
            bool fsrsReviewsRefs,
            bool quizResultsRefs,
          })
        > {
  $$ProfilesTableTableManager(_$AppDatabase db, $ProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> firstName = const Value.absent(),
                Value<int?> lastLegislatureId = const Value.absent(),
                Value<String> language = const Value.absent(),
                Value<DateTime?> lastUsedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ProfilesCompanion(
                id: id,
                firstName: firstName,
                lastLegislatureId: lastLegislatureId,
                language: language,
                lastUsedAt: lastUsedAt,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String firstName,
                Value<int?> lastLegislatureId = const Value.absent(),
                Value<String> language = const Value.absent(),
                Value<DateTime?> lastUsedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ProfilesCompanion.insert(
                id: id,
                firstName: firstName,
                lastLegislatureId: lastLegislatureId,
                language: language,
                lastUsedAt: lastUsedAt,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProfilesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                lastLegislatureId = false,
                fsrsReviewsRefs = false,
                quizResultsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (fsrsReviewsRefs) db.fsrsReviews,
                    if (quizResultsRefs) db.quizResults,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (lastLegislatureId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.lastLegislatureId,
                                    referencedTable: $$ProfilesTableReferences
                                        ._lastLegislatureIdTable(db),
                                    referencedColumn: $$ProfilesTableReferences
                                        ._lastLegislatureIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (fsrsReviewsRefs)
                        await $_getPrefetchedData<
                          Profile,
                          $ProfilesTable,
                          FsrsReview
                        >(
                          currentTable: table,
                          referencedTable: $$ProfilesTableReferences
                              ._fsrsReviewsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).fsrsReviewsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.userId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (quizResultsRefs)
                        await $_getPrefetchedData<
                          Profile,
                          $ProfilesTable,
                          QuizResult
                        >(
                          currentTable: table,
                          referencedTable: $$ProfilesTableReferences
                              ._quizResultsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).quizResultsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.userId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProfilesTable,
      Profile,
      $$ProfilesTableFilterComposer,
      $$ProfilesTableOrderingComposer,
      $$ProfilesTableAnnotationComposer,
      $$ProfilesTableCreateCompanionBuilder,
      $$ProfilesTableUpdateCompanionBuilder,
      (Profile, $$ProfilesTableReferences),
      Profile,
      PrefetchHooks Function({
        bool lastLegislatureId,
        bool fsrsReviewsRefs,
        bool quizResultsRefs,
      })
    >;
typedef $$MembersTableCreateCompanionBuilder =
    MembersCompanion Function({
      Value<int> id,
      required int legislatureId,
      required String firstName,
      required String lastName,
      Value<String?> riding,
      Value<String?> party,
      Value<String?> title,
      required String imageUrl,
      Value<String?> region,
      Value<bool> requiresRidingDistinction,
    });
typedef $$MembersTableUpdateCompanionBuilder =
    MembersCompanion Function({
      Value<int> id,
      Value<int> legislatureId,
      Value<String> firstName,
      Value<String> lastName,
      Value<String?> riding,
      Value<String?> party,
      Value<String?> title,
      Value<String> imageUrl,
      Value<String?> region,
      Value<bool> requiresRidingDistinction,
    });

final class $$MembersTableReferences
    extends BaseReferences<_$AppDatabase, $MembersTable, Member> {
  $$MembersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $LegislaturesTable _legislatureIdTable(_$AppDatabase db) =>
      db.legislatures.createAlias(
        $_aliasNameGenerator(db.members.legislatureId, db.legislatures.id),
      );

  $$LegislaturesTableProcessedTableManager get legislatureId {
    final $_column = $_itemColumn<int>('legislature_id')!;

    final manager = $$LegislaturesTableTableManager(
      $_db,
      $_db.legislatures,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_legislatureIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$FsrsReviewsTable, List<FsrsReview>>
  _fsrsReviewsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.fsrsReviews,
    aliasName: $_aliasNameGenerator(db.members.id, db.fsrsReviews.memberId),
  );

  $$FsrsReviewsTableProcessedTableManager get fsrsReviewsRefs {
    final manager = $$FsrsReviewsTableTableManager(
      $_db,
      $_db.fsrsReviews,
    ).filter((f) => f.memberId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_fsrsReviewsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MembersTableFilterComposer
    extends Composer<_$AppDatabase, $MembersTable> {
  $$MembersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get riding => $composableBuilder(
    column: $table.riding,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get party => $composableBuilder(
    column: $table.party,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get region => $composableBuilder(
    column: $table.region,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get requiresRidingDistinction => $composableBuilder(
    column: $table.requiresRidingDistinction,
    builder: (column) => ColumnFilters(column),
  );

  $$LegislaturesTableFilterComposer get legislatureId {
    final $$LegislaturesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.legislatureId,
      referencedTable: $db.legislatures,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LegislaturesTableFilterComposer(
            $db: $db,
            $table: $db.legislatures,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> fsrsReviewsRefs(
    Expression<bool> Function($$FsrsReviewsTableFilterComposer f) f,
  ) {
    final $$FsrsReviewsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.fsrsReviews,
      getReferencedColumn: (t) => t.memberId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FsrsReviewsTableFilterComposer(
            $db: $db,
            $table: $db.fsrsReviews,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MembersTableOrderingComposer
    extends Composer<_$AppDatabase, $MembersTable> {
  $$MembersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get riding => $composableBuilder(
    column: $table.riding,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get party => $composableBuilder(
    column: $table.party,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get region => $composableBuilder(
    column: $table.region,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get requiresRidingDistinction => $composableBuilder(
    column: $table.requiresRidingDistinction,
    builder: (column) => ColumnOrderings(column),
  );

  $$LegislaturesTableOrderingComposer get legislatureId {
    final $$LegislaturesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.legislatureId,
      referencedTable: $db.legislatures,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LegislaturesTableOrderingComposer(
            $db: $db,
            $table: $db.legislatures,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MembersTableAnnotationComposer
    extends Composer<_$AppDatabase, $MembersTable> {
  $$MembersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get firstName =>
      $composableBuilder(column: $table.firstName, builder: (column) => column);

  GeneratedColumn<String> get lastName =>
      $composableBuilder(column: $table.lastName, builder: (column) => column);

  GeneratedColumn<String> get riding =>
      $composableBuilder(column: $table.riding, builder: (column) => column);

  GeneratedColumn<String> get party =>
      $composableBuilder(column: $table.party, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<String> get region =>
      $composableBuilder(column: $table.region, builder: (column) => column);

  GeneratedColumn<bool> get requiresRidingDistinction => $composableBuilder(
    column: $table.requiresRidingDistinction,
    builder: (column) => column,
  );

  $$LegislaturesTableAnnotationComposer get legislatureId {
    final $$LegislaturesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.legislatureId,
      referencedTable: $db.legislatures,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LegislaturesTableAnnotationComposer(
            $db: $db,
            $table: $db.legislatures,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> fsrsReviewsRefs<T extends Object>(
    Expression<T> Function($$FsrsReviewsTableAnnotationComposer a) f,
  ) {
    final $$FsrsReviewsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.fsrsReviews,
      getReferencedColumn: (t) => t.memberId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FsrsReviewsTableAnnotationComposer(
            $db: $db,
            $table: $db.fsrsReviews,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MembersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MembersTable,
          Member,
          $$MembersTableFilterComposer,
          $$MembersTableOrderingComposer,
          $$MembersTableAnnotationComposer,
          $$MembersTableCreateCompanionBuilder,
          $$MembersTableUpdateCompanionBuilder,
          (Member, $$MembersTableReferences),
          Member,
          PrefetchHooks Function({bool legislatureId, bool fsrsReviewsRefs})
        > {
  $$MembersTableTableManager(_$AppDatabase db, $MembersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MembersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MembersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MembersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> legislatureId = const Value.absent(),
                Value<String> firstName = const Value.absent(),
                Value<String> lastName = const Value.absent(),
                Value<String?> riding = const Value.absent(),
                Value<String?> party = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<String> imageUrl = const Value.absent(),
                Value<String?> region = const Value.absent(),
                Value<bool> requiresRidingDistinction = const Value.absent(),
              }) => MembersCompanion(
                id: id,
                legislatureId: legislatureId,
                firstName: firstName,
                lastName: lastName,
                riding: riding,
                party: party,
                title: title,
                imageUrl: imageUrl,
                region: region,
                requiresRidingDistinction: requiresRidingDistinction,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int legislatureId,
                required String firstName,
                required String lastName,
                Value<String?> riding = const Value.absent(),
                Value<String?> party = const Value.absent(),
                Value<String?> title = const Value.absent(),
                required String imageUrl,
                Value<String?> region = const Value.absent(),
                Value<bool> requiresRidingDistinction = const Value.absent(),
              }) => MembersCompanion.insert(
                id: id,
                legislatureId: legislatureId,
                firstName: firstName,
                lastName: lastName,
                riding: riding,
                party: party,
                title: title,
                imageUrl: imageUrl,
                region: region,
                requiresRidingDistinction: requiresRidingDistinction,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MembersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({legislatureId = false, fsrsReviewsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (fsrsReviewsRefs) db.fsrsReviews,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (legislatureId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.legislatureId,
                                    referencedTable: $$MembersTableReferences
                                        ._legislatureIdTable(db),
                                    referencedColumn: $$MembersTableReferences
                                        ._legislatureIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (fsrsReviewsRefs)
                        await $_getPrefetchedData<
                          Member,
                          $MembersTable,
                          FsrsReview
                        >(
                          currentTable: table,
                          referencedTable: $$MembersTableReferences
                              ._fsrsReviewsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MembersTableReferences(
                                db,
                                table,
                                p0,
                              ).fsrsReviewsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.memberId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$MembersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MembersTable,
      Member,
      $$MembersTableFilterComposer,
      $$MembersTableOrderingComposer,
      $$MembersTableAnnotationComposer,
      $$MembersTableCreateCompanionBuilder,
      $$MembersTableUpdateCompanionBuilder,
      (Member, $$MembersTableReferences),
      Member,
      PrefetchHooks Function({bool legislatureId, bool fsrsReviewsRefs})
    >;
typedef $$FsrsReviewsTableCreateCompanionBuilder =
    FsrsReviewsCompanion Function({
      Value<int> id,
      required int userId,
      required int memberId,
      required int state,
      required DateTime due,
      required double stability,
      required double difficulty,
      required int elapsedDays,
      required int scheduledDays,
      required int reps,
      required int lapses,
      Value<DateTime?> lastReview,
      Value<int> totalQuestions,
      Value<int> correctQuestions,
    });
typedef $$FsrsReviewsTableUpdateCompanionBuilder =
    FsrsReviewsCompanion Function({
      Value<int> id,
      Value<int> userId,
      Value<int> memberId,
      Value<int> state,
      Value<DateTime> due,
      Value<double> stability,
      Value<double> difficulty,
      Value<int> elapsedDays,
      Value<int> scheduledDays,
      Value<int> reps,
      Value<int> lapses,
      Value<DateTime?> lastReview,
      Value<int> totalQuestions,
      Value<int> correctQuestions,
    });

final class $$FsrsReviewsTableReferences
    extends BaseReferences<_$AppDatabase, $FsrsReviewsTable, FsrsReview> {
  $$FsrsReviewsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProfilesTable _userIdTable(_$AppDatabase db) => db.profiles
      .createAlias($_aliasNameGenerator(db.fsrsReviews.userId, db.profiles.id));

  $$ProfilesTableProcessedTableManager get userId {
    final $_column = $_itemColumn<int>('user_id')!;

    final manager = $$ProfilesTableTableManager(
      $_db,
      $_db.profiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $MembersTable _memberIdTable(_$AppDatabase db) =>
      db.members.createAlias(
        $_aliasNameGenerator(db.fsrsReviews.memberId, db.members.id),
      );

  $$MembersTableProcessedTableManager get memberId {
    final $_column = $_itemColumn<int>('member_id')!;

    final manager = $$MembersTableTableManager(
      $_db,
      $_db.members,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_memberIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FsrsReviewsTableFilterComposer
    extends Composer<_$AppDatabase, $FsrsReviewsTable> {
  $$FsrsReviewsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get due => $composableBuilder(
    column: $table.due,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get stability => $composableBuilder(
    column: $table.stability,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get elapsedDays => $composableBuilder(
    column: $table.elapsedDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get scheduledDays => $composableBuilder(
    column: $table.scheduledDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lapses => $composableBuilder(
    column: $table.lapses,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastReview => $composableBuilder(
    column: $table.lastReview,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalQuestions => $composableBuilder(
    column: $table.totalQuestions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get correctQuestions => $composableBuilder(
    column: $table.correctQuestions,
    builder: (column) => ColumnFilters(column),
  );

  $$ProfilesTableFilterComposer get userId {
    final $$ProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableFilterComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MembersTableFilterComposer get memberId {
    final $$MembersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableFilterComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FsrsReviewsTableOrderingComposer
    extends Composer<_$AppDatabase, $FsrsReviewsTable> {
  $$FsrsReviewsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get due => $composableBuilder(
    column: $table.due,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get stability => $composableBuilder(
    column: $table.stability,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get elapsedDays => $composableBuilder(
    column: $table.elapsedDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get scheduledDays => $composableBuilder(
    column: $table.scheduledDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lapses => $composableBuilder(
    column: $table.lapses,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastReview => $composableBuilder(
    column: $table.lastReview,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalQuestions => $composableBuilder(
    column: $table.totalQuestions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get correctQuestions => $composableBuilder(
    column: $table.correctQuestions,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProfilesTableOrderingComposer get userId {
    final $$ProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MembersTableOrderingComposer get memberId {
    final $$MembersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableOrderingComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FsrsReviewsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FsrsReviewsTable> {
  $$FsrsReviewsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<DateTime> get due =>
      $composableBuilder(column: $table.due, builder: (column) => column);

  GeneratedColumn<double> get stability =>
      $composableBuilder(column: $table.stability, builder: (column) => column);

  GeneratedColumn<double> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => column,
  );

  GeneratedColumn<int> get elapsedDays => $composableBuilder(
    column: $table.elapsedDays,
    builder: (column) => column,
  );

  GeneratedColumn<int> get scheduledDays => $composableBuilder(
    column: $table.scheduledDays,
    builder: (column) => column,
  );

  GeneratedColumn<int> get reps =>
      $composableBuilder(column: $table.reps, builder: (column) => column);

  GeneratedColumn<int> get lapses =>
      $composableBuilder(column: $table.lapses, builder: (column) => column);

  GeneratedColumn<DateTime> get lastReview => $composableBuilder(
    column: $table.lastReview,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalQuestions => $composableBuilder(
    column: $table.totalQuestions,
    builder: (column) => column,
  );

  GeneratedColumn<int> get correctQuestions => $composableBuilder(
    column: $table.correctQuestions,
    builder: (column) => column,
  );

  $$ProfilesTableAnnotationComposer get userId {
    final $$ProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MembersTableAnnotationComposer get memberId {
    final $$MembersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableAnnotationComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FsrsReviewsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FsrsReviewsTable,
          FsrsReview,
          $$FsrsReviewsTableFilterComposer,
          $$FsrsReviewsTableOrderingComposer,
          $$FsrsReviewsTableAnnotationComposer,
          $$FsrsReviewsTableCreateCompanionBuilder,
          $$FsrsReviewsTableUpdateCompanionBuilder,
          (FsrsReview, $$FsrsReviewsTableReferences),
          FsrsReview,
          PrefetchHooks Function({bool userId, bool memberId})
        > {
  $$FsrsReviewsTableTableManager(_$AppDatabase db, $FsrsReviewsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FsrsReviewsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FsrsReviewsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FsrsReviewsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> userId = const Value.absent(),
                Value<int> memberId = const Value.absent(),
                Value<int> state = const Value.absent(),
                Value<DateTime> due = const Value.absent(),
                Value<double> stability = const Value.absent(),
                Value<double> difficulty = const Value.absent(),
                Value<int> elapsedDays = const Value.absent(),
                Value<int> scheduledDays = const Value.absent(),
                Value<int> reps = const Value.absent(),
                Value<int> lapses = const Value.absent(),
                Value<DateTime?> lastReview = const Value.absent(),
                Value<int> totalQuestions = const Value.absent(),
                Value<int> correctQuestions = const Value.absent(),
              }) => FsrsReviewsCompanion(
                id: id,
                userId: userId,
                memberId: memberId,
                state: state,
                due: due,
                stability: stability,
                difficulty: difficulty,
                elapsedDays: elapsedDays,
                scheduledDays: scheduledDays,
                reps: reps,
                lapses: lapses,
                lastReview: lastReview,
                totalQuestions: totalQuestions,
                correctQuestions: correctQuestions,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int userId,
                required int memberId,
                required int state,
                required DateTime due,
                required double stability,
                required double difficulty,
                required int elapsedDays,
                required int scheduledDays,
                required int reps,
                required int lapses,
                Value<DateTime?> lastReview = const Value.absent(),
                Value<int> totalQuestions = const Value.absent(),
                Value<int> correctQuestions = const Value.absent(),
              }) => FsrsReviewsCompanion.insert(
                id: id,
                userId: userId,
                memberId: memberId,
                state: state,
                due: due,
                stability: stability,
                difficulty: difficulty,
                elapsedDays: elapsedDays,
                scheduledDays: scheduledDays,
                reps: reps,
                lapses: lapses,
                lastReview: lastReview,
                totalQuestions: totalQuestions,
                correctQuestions: correctQuestions,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FsrsReviewsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({userId = false, memberId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (userId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.userId,
                                referencedTable: $$FsrsReviewsTableReferences
                                    ._userIdTable(db),
                                referencedColumn: $$FsrsReviewsTableReferences
                                    ._userIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (memberId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.memberId,
                                referencedTable: $$FsrsReviewsTableReferences
                                    ._memberIdTable(db),
                                referencedColumn: $$FsrsReviewsTableReferences
                                    ._memberIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$FsrsReviewsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FsrsReviewsTable,
      FsrsReview,
      $$FsrsReviewsTableFilterComposer,
      $$FsrsReviewsTableOrderingComposer,
      $$FsrsReviewsTableAnnotationComposer,
      $$FsrsReviewsTableCreateCompanionBuilder,
      $$FsrsReviewsTableUpdateCompanionBuilder,
      (FsrsReview, $$FsrsReviewsTableReferences),
      FsrsReview,
      PrefetchHooks Function({bool userId, bool memberId})
    >;
typedef $$QuizResultsTableCreateCompanionBuilder =
    QuizResultsCompanion Function({
      Value<int> id,
      Value<DateTime> timestamp,
      required int userId,
      required String userName,
      required int legislatureId,
      required String quizModeId,
      required double filterPercentage,
      required double scorePercentage,
    });
typedef $$QuizResultsTableUpdateCompanionBuilder =
    QuizResultsCompanion Function({
      Value<int> id,
      Value<DateTime> timestamp,
      Value<int> userId,
      Value<String> userName,
      Value<int> legislatureId,
      Value<String> quizModeId,
      Value<double> filterPercentage,
      Value<double> scorePercentage,
    });

final class $$QuizResultsTableReferences
    extends BaseReferences<_$AppDatabase, $QuizResultsTable, QuizResult> {
  $$QuizResultsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProfilesTable _userIdTable(_$AppDatabase db) => db.profiles
      .createAlias($_aliasNameGenerator(db.quizResults.userId, db.profiles.id));

  $$ProfilesTableProcessedTableManager get userId {
    final $_column = $_itemColumn<int>('user_id')!;

    final manager = $$ProfilesTableTableManager(
      $_db,
      $_db.profiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $LegislaturesTable _legislatureIdTable(_$AppDatabase db) =>
      db.legislatures.createAlias(
        $_aliasNameGenerator(db.quizResults.legislatureId, db.legislatures.id),
      );

  $$LegislaturesTableProcessedTableManager get legislatureId {
    final $_column = $_itemColumn<int>('legislature_id')!;

    final manager = $$LegislaturesTableTableManager(
      $_db,
      $_db.legislatures,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_legislatureIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$QuizResultsTableFilterComposer
    extends Composer<_$AppDatabase, $QuizResultsTable> {
  $$QuizResultsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userName => $composableBuilder(
    column: $table.userName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get quizModeId => $composableBuilder(
    column: $table.quizModeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get filterPercentage => $composableBuilder(
    column: $table.filterPercentage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get scorePercentage => $composableBuilder(
    column: $table.scorePercentage,
    builder: (column) => ColumnFilters(column),
  );

  $$ProfilesTableFilterComposer get userId {
    final $$ProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableFilterComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LegislaturesTableFilterComposer get legislatureId {
    final $$LegislaturesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.legislatureId,
      referencedTable: $db.legislatures,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LegislaturesTableFilterComposer(
            $db: $db,
            $table: $db.legislatures,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuizResultsTableOrderingComposer
    extends Composer<_$AppDatabase, $QuizResultsTable> {
  $$QuizResultsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userName => $composableBuilder(
    column: $table.userName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get quizModeId => $composableBuilder(
    column: $table.quizModeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get filterPercentage => $composableBuilder(
    column: $table.filterPercentage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get scorePercentage => $composableBuilder(
    column: $table.scorePercentage,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProfilesTableOrderingComposer get userId {
    final $$ProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LegislaturesTableOrderingComposer get legislatureId {
    final $$LegislaturesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.legislatureId,
      referencedTable: $db.legislatures,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LegislaturesTableOrderingComposer(
            $db: $db,
            $table: $db.legislatures,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuizResultsTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuizResultsTable> {
  $$QuizResultsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<String> get userName =>
      $composableBuilder(column: $table.userName, builder: (column) => column);

  GeneratedColumn<String> get quizModeId => $composableBuilder(
    column: $table.quizModeId,
    builder: (column) => column,
  );

  GeneratedColumn<double> get filterPercentage => $composableBuilder(
    column: $table.filterPercentage,
    builder: (column) => column,
  );

  GeneratedColumn<double> get scorePercentage => $composableBuilder(
    column: $table.scorePercentage,
    builder: (column) => column,
  );

  $$ProfilesTableAnnotationComposer get userId {
    final $$ProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LegislaturesTableAnnotationComposer get legislatureId {
    final $$LegislaturesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.legislatureId,
      referencedTable: $db.legislatures,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LegislaturesTableAnnotationComposer(
            $db: $db,
            $table: $db.legislatures,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuizResultsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuizResultsTable,
          QuizResult,
          $$QuizResultsTableFilterComposer,
          $$QuizResultsTableOrderingComposer,
          $$QuizResultsTableAnnotationComposer,
          $$QuizResultsTableCreateCompanionBuilder,
          $$QuizResultsTableUpdateCompanionBuilder,
          (QuizResult, $$QuizResultsTableReferences),
          QuizResult,
          PrefetchHooks Function({bool userId, bool legislatureId})
        > {
  $$QuizResultsTableTableManager(_$AppDatabase db, $QuizResultsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuizResultsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuizResultsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuizResultsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<int> userId = const Value.absent(),
                Value<String> userName = const Value.absent(),
                Value<int> legislatureId = const Value.absent(),
                Value<String> quizModeId = const Value.absent(),
                Value<double> filterPercentage = const Value.absent(),
                Value<double> scorePercentage = const Value.absent(),
              }) => QuizResultsCompanion(
                id: id,
                timestamp: timestamp,
                userId: userId,
                userName: userName,
                legislatureId: legislatureId,
                quizModeId: quizModeId,
                filterPercentage: filterPercentage,
                scorePercentage: scorePercentage,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                required int userId,
                required String userName,
                required int legislatureId,
                required String quizModeId,
                required double filterPercentage,
                required double scorePercentage,
              }) => QuizResultsCompanion.insert(
                id: id,
                timestamp: timestamp,
                userId: userId,
                userName: userName,
                legislatureId: legislatureId,
                quizModeId: quizModeId,
                filterPercentage: filterPercentage,
                scorePercentage: scorePercentage,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$QuizResultsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({userId = false, legislatureId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (userId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.userId,
                                referencedTable: $$QuizResultsTableReferences
                                    ._userIdTable(db),
                                referencedColumn: $$QuizResultsTableReferences
                                    ._userIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (legislatureId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.legislatureId,
                                referencedTable: $$QuizResultsTableReferences
                                    ._legislatureIdTable(db),
                                referencedColumn: $$QuizResultsTableReferences
                                    ._legislatureIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$QuizResultsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuizResultsTable,
      QuizResult,
      $$QuizResultsTableFilterComposer,
      $$QuizResultsTableOrderingComposer,
      $$QuizResultsTableAnnotationComposer,
      $$QuizResultsTableCreateCompanionBuilder,
      $$QuizResultsTableUpdateCompanionBuilder,
      (QuizResult, $$QuizResultsTableReferences),
      QuizResult,
      PrefetchHooks Function({bool userId, bool legislatureId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$LegislaturesTableTableManager get legislatures =>
      $$LegislaturesTableTableManager(_db, _db.legislatures);
  $$ProfilesTableTableManager get profiles =>
      $$ProfilesTableTableManager(_db, _db.profiles);
  $$MembersTableTableManager get members =>
      $$MembersTableTableManager(_db, _db.members);
  $$FsrsReviewsTableTableManager get fsrsReviews =>
      $$FsrsReviewsTableTableManager(_db, _db.fsrsReviews);
  $$QuizResultsTableTableManager get quizResults =>
      $$QuizResultsTableTableManager(_db, _db.quizResults);
}
