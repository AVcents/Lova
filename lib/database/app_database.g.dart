// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $WeeklyCheckinsTable extends WeeklyCheckins
    with TableInfo<$WeeklyCheckinsTable, WeeklyCheckin> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;

  $WeeklyCheckinsTable(this.attachedDatabase, [this._alias]);

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
  static const VerificationMeta _moodMeta = const VerificationMeta('mood');
  @override
  late final GeneratedColumn<int> mood = GeneratedColumn<int>(
    'mood',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
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
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );

  @override
  List<GeneratedColumn> get $columns => [id, mood, timestamp, userId];

  @override
  String get aliasedName => _alias ?? actualTableName;

  @override
  String get actualTableName => $name;
  static const String $name = 'weekly_checkins';

  @override
  VerificationContext validateIntegrity(
    Insertable<WeeklyCheckin> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('mood')) {
      context.handle(
        _moodMeta,
        mood.isAcceptableOrUnknown(data['mood']!, _moodMeta),
      );
    } else if (isInserting) {
      context.missing(_moodMeta);
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
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};

  @override
  WeeklyCheckin map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeeklyCheckin(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      mood: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mood'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      ),
    );
  }

  @override
  $WeeklyCheckinsTable createAlias(String alias) {
    return $WeeklyCheckinsTable(attachedDatabase, alias);
  }
}

class WeeklyCheckin extends DataClass implements Insertable<WeeklyCheckin> {
  final int id;
  final int mood;
  final DateTime timestamp;
  final String? userId;

  const WeeklyCheckin({
    required this.id,
    required this.mood,
    required this.timestamp,
    this.userId,
  });

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['mood'] = Variable<int>(mood);
    map['timestamp'] = Variable<DateTime>(timestamp);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    return map;
  }

  WeeklyCheckinsCompanion toCompanion(bool nullToAbsent) {
    return WeeklyCheckinsCompanion(
      id: Value(id),
      mood: Value(mood),
      timestamp: Value(timestamp),
      userId: userId == null && nullToAbsent
          ? const Value.absent()
          : Value(userId),
    );
  }

  factory WeeklyCheckin.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeeklyCheckin(
      id: serializer.fromJson<int>(json['id']),
      mood: serializer.fromJson<int>(json['mood']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      userId: serializer.fromJson<String?>(json['userId']),
    );
  }

  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'mood': serializer.toJson<int>(mood),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'userId': serializer.toJson<String?>(userId),
    };
  }

  WeeklyCheckin copyWith({
    int? id,
    int? mood,
    DateTime? timestamp,
    Value<String?> userId = const Value.absent(),
  }) => WeeklyCheckin(
    id: id ?? this.id,
    mood: mood ?? this.mood,
    timestamp: timestamp ?? this.timestamp,
    userId: userId.present ? userId.value : this.userId,
  );

  WeeklyCheckin copyWithCompanion(WeeklyCheckinsCompanion data) {
    return WeeklyCheckin(
      id: data.id.present ? data.id.value : this.id,
      mood: data.mood.present ? data.mood.value : this.mood,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      userId: data.userId.present ? data.userId.value : this.userId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeeklyCheckin(')
          ..write('id: $id, ')
          ..write('mood: $mood, ')
          ..write('timestamp: $timestamp, ')
          ..write('userId: $userId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, mood, timestamp, userId);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeeklyCheckin &&
          other.id == this.id &&
          other.mood == this.mood &&
          other.timestamp == this.timestamp &&
          other.userId == this.userId);
}

class WeeklyCheckinsCompanion extends UpdateCompanion<WeeklyCheckin> {
  final Value<int> id;
  final Value<int> mood;
  final Value<DateTime> timestamp;
  final Value<String?> userId;

  const WeeklyCheckinsCompanion({
    this.id = const Value.absent(),
    this.mood = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.userId = const Value.absent(),
  });

  WeeklyCheckinsCompanion.insert({
    this.id = const Value.absent(),
    required int mood,
    this.timestamp = const Value.absent(),
    this.userId = const Value.absent(),
  }) : mood = Value(mood);

  static Insertable<WeeklyCheckin> custom({
    Expression<int>? id,
    Expression<int>? mood,
    Expression<DateTime>? timestamp,
    Expression<String>? userId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (mood != null) 'mood': mood,
      if (timestamp != null) 'timestamp': timestamp,
      if (userId != null) 'user_id': userId,
    });
  }

  WeeklyCheckinsCompanion copyWith({
    Value<int>? id,
    Value<int>? mood,
    Value<DateTime>? timestamp,
    Value<String?>? userId,
  }) {
    return WeeklyCheckinsCompanion(
      id: id ?? this.id,
      mood: mood ?? this.mood,
      timestamp: timestamp ?? this.timestamp,
      userId: userId ?? this.userId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (mood.present) {
      map['mood'] = Variable<int>(mood.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeeklyCheckinsCompanion(')
          ..write('id: $id, ')
          ..write('mood: $mood, ')
          ..write('timestamp: $timestamp, ')
          ..write('userId: $userId')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);

  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $WeeklyCheckinsTable weeklyCheckins = $WeeklyCheckinsTable(this);

  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();

  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [weeklyCheckins];
}

typedef $$WeeklyCheckinsTableCreateCompanionBuilder =
    WeeklyCheckinsCompanion Function({
      Value<int> id,
      required int mood,
      Value<DateTime> timestamp,
      Value<String?> userId,
    });
typedef $$WeeklyCheckinsTableUpdateCompanionBuilder =
    WeeklyCheckinsCompanion Function({
      Value<int> id,
      Value<int> mood,
      Value<DateTime> timestamp,
      Value<String?> userId,
    });

class $$WeeklyCheckinsTableFilterComposer
    extends Composer<_$AppDatabase, $WeeklyCheckinsTable> {
  $$WeeklyCheckinsTableFilterComposer({
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

  ColumnFilters<int> get mood => $composableBuilder(
    column: $table.mood,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WeeklyCheckinsTableOrderingComposer
    extends Composer<_$AppDatabase, $WeeklyCheckinsTable> {
  $$WeeklyCheckinsTableOrderingComposer({
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

  ColumnOrderings<int> get mood => $composableBuilder(
    column: $table.mood,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WeeklyCheckinsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeeklyCheckinsTable> {
  $$WeeklyCheckinsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });

  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get mood =>
      $composableBuilder(column: $table.mood, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);
}

class $$WeeklyCheckinsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WeeklyCheckinsTable,
          WeeklyCheckin,
          $$WeeklyCheckinsTableFilterComposer,
          $$WeeklyCheckinsTableOrderingComposer,
          $$WeeklyCheckinsTableAnnotationComposer,
          $$WeeklyCheckinsTableCreateCompanionBuilder,
          $$WeeklyCheckinsTableUpdateCompanionBuilder,
          (
            WeeklyCheckin,
            BaseReferences<_$AppDatabase, $WeeklyCheckinsTable, WeeklyCheckin>,
          ),
          WeeklyCheckin,
          PrefetchHooks Function()
        > {
  $$WeeklyCheckinsTableTableManager(
    _$AppDatabase db,
    $WeeklyCheckinsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeeklyCheckinsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeeklyCheckinsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeeklyCheckinsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> mood = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<String?> userId = const Value.absent(),
              }) => WeeklyCheckinsCompanion(
                id: id,
                mood: mood,
                timestamp: timestamp,
                userId: userId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int mood,
                Value<DateTime> timestamp = const Value.absent(),
                Value<String?> userId = const Value.absent(),
              }) => WeeklyCheckinsCompanion.insert(
                id: id,
                mood: mood,
                timestamp: timestamp,
                userId: userId,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WeeklyCheckinsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WeeklyCheckinsTable,
      WeeklyCheckin,
      $$WeeklyCheckinsTableFilterComposer,
      $$WeeklyCheckinsTableOrderingComposer,
      $$WeeklyCheckinsTableAnnotationComposer,
      $$WeeklyCheckinsTableCreateCompanionBuilder,
      $$WeeklyCheckinsTableUpdateCompanionBuilder,
      (
        WeeklyCheckin,
        BaseReferences<_$AppDatabase, $WeeklyCheckinsTable, WeeklyCheckin>,
      ),
      WeeklyCheckin,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;

  $AppDatabaseManager(this._db);

  $$WeeklyCheckinsTableTableManager get weeklyCheckins =>
      $$WeeklyCheckinsTableTableManager(_db, _db.weeklyCheckins);
}
