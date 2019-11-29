// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String name;

  final List<Migration> _migrations = [];

  Callback _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final database = _$AppDatabase();
    database.database = await database.open(
      name ?? ':memory:',
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String> listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  SpotDao _spotDaoInstance;

  Future<sqflite.Database> open(String name, List<Migration> migrations,
      [Callback callback]) async {
    final path = join(await sqflite.getDatabasesPath(), name);

    return sqflite.openDatabase(
      path,
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `SpotEntity` (`id` INTEGER, `name` TEXT, `popularity` INTEGER, `address` TEXT, `province` TEXT, `provinceKey` TEXT, `district` TEXT, `districtKey` TEXT, `lat` REAL, `long` REAL, `website` TEXT, `imageLink` TEXT, `description` TEXT, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
  }

  @override
  SpotDao get spotDao {
    return _spotDaoInstance ??= _$SpotDao(database, changeListener);
  }
}

class _$SpotDao extends SpotDao {
  _$SpotDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _spotEntityInsertionAdapter = InsertionAdapter(
            database,
            'SpotEntity',
            (SpotEntity item) => <String, dynamic>{
                  'id': item.id,
                  'name': item.name,
                  'popularity': item.popularity,
                  'address': item.address,
                  'province': item.province,
                  'provinceKey': item.provinceKey,
                  'district': item.district,
                  'districtKey': item.districtKey,
                  'lat': item.lat,
                  'long': item.long,
                  'website': item.website,
                  'imageLink': item.imageLink,
                  'description': item.description
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  static final _spotEntityMapper = (Map<String, dynamic> row) => SpotEntity(
      row['id'] as int,
      row['name'] as String,
      row['popularity'] as int,
      row['address'] as String,
      row['province'] as String,
      row['provinceKey'] as String,
      row['district'] as String,
      row['districtKey'] as String,
      row['lat'] as double,
      row['long'] as double,
      row['website'] as String,
      row['imageLink'] as String,
      row['description'] as String);

  final InsertionAdapter<SpotEntity> _spotEntityInsertionAdapter;

  @override
  Future<List<SpotEntity>> getAll() async {
    return _queryAdapter.queryList('SELECT * FROM SpotEntity',
        mapper: _spotEntityMapper);
  }

  @override
  Future<SpotEntity> findPersonById(int id) async {
    return _queryAdapter.query('SELECT * FROM SpotEntity WHERE id = ?',
        arguments: <dynamic>[id], mapper: _spotEntityMapper);
  }

  @override
  Future<void> deleteAll() async {
    await _queryAdapter.queryNoReturn('DELETE FROM SpotEntity');
  }

  @override
  Future<void> insertSpot(SpotEntity item) async {
    await _spotEntityInsertionAdapter.insert(
        item, sqflite.ConflictAlgorithm.replace);
  }

  @override
  Future<void> insertSpots(List<SpotEntity> items) async {
    await _spotEntityInsertionAdapter.insertList(
        items, sqflite.ConflictAlgorithm.abort);
  }

  @override
  Future<void> insertDataFirstTime(List<SpotEntity> items) async {
    if (database is sqflite.Transaction) {
      await super.insertDataFirstTime(items);
    } else {
      await (database as sqflite.Database)
          .transaction<void>((transaction) async {
        final transactionDatabase = _$AppDatabase(changeListener)
          ..database = transaction;
        await transactionDatabase.spotDao.insertDataFirstTime(items);
      });
    }
  }
}
