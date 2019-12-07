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
      version: 2,
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
            'CREATE TABLE IF NOT EXISTS `SpotEntity` (`id` INTEGER, `uniqueKey` TEXT, `searchText` TEXT, `name` TEXT, `popularity` INTEGER, `address` TEXT, `province` TEXT, `district` TEXT, `districtKey` TEXT, `lat` REAL, `long` REAL, `locationLink` TEXT, `website` TEXT, `imageLink` TEXT, `description` TEXT, `wikiLink` TEXT, PRIMARY KEY (`id`))');

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
                  'uniqueKey': item.uniqueKey,
                  'searchText': item.searchText,
                  'name': item.name,
                  'popularity': item.popularity,
                  'address': item.address,
                  'province': item.province,
                  'district': item.district,
                  'districtKey': item.districtKey,
                  'lat': item.lat,
                  'long': item.long,
                  'locationLink': item.locationLink,
                  'website': item.website,
                  'imageLink': item.imageLink,
                  'description': item.description,
                  'wikiLink': item.wikiLink
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  static final _spotEntityMapper = (Map<String, dynamic> row) => SpotEntity(
      row['id'] as int,
      row['uniqueKey'] as String,
      row['searchText'] as String,
      row['name'] as String,
      row['popularity'] as int,
      row['address'] as String,
      row['province'] as String,
      row['district'] as String,
      row['districtKey'] as String,
      row['lat'] as double,
      row['long'] as double,
      row['locationLink'] as String,
      row['website'] as String,
      row['imageLink'] as String,
      row['description'] as String,
      row['wikiLink'] as String);

  final InsertionAdapter<SpotEntity> _spotEntityInsertionAdapter;

  @override
  Future<List<SpotEntity>> getAll() async {
    return _queryAdapter.queryList('SELECT * FROM SpotEntity',
        mapper: _spotEntityMapper);
  }

  @override
  Future<SpotEntity> findSpotById(int id) async {
    return _queryAdapter.query('SELECT * FROM SpotEntity WHERE id = ?',
        arguments: <dynamic>[id], mapper: _spotEntityMapper);
  }

  @override
  Future<List<SpotEntity>> findSpotByPopularity(int popularity) async {
    return _queryAdapter.queryList(
        'SELECT name FROM SpotEntity WHERE popularity = ?',
        arguments: <dynamic>[popularity],
        mapper: _spotEntityMapper);
  }

  @override
  Future<List<SpotEntity>> findSpotByNoPopularity() async {
    return _queryAdapter.queryList(
        'SELECT name FROM SpotEntity WHERE popularity NOT IN (1,2,3)',
        mapper: _spotEntityMapper);
  }

  @override
  Future<List<SpotEntity>> findSpotsInRegion(double latStart, double latEnd,
      double longStart, double longEnd, int popularityLessThanOrEqual) async {
    return _queryAdapter.queryList(
        'SELECT * FROM SpotEntity WHERE lat > ? AND lat < ? AND long > ? AND long < ? AND popularity <= ?',
        arguments: <dynamic>[
          latStart,
          latEnd,
          longStart,
          longEnd,
          popularityLessThanOrEqual
        ],
        mapper: _spotEntityMapper);
  }

  @override
  Future<List<SpotEntity>> findSpotsInRegionByName(double latStart,
      double latEnd, double longStart, double longEnd, String keyword) async {
    return _queryAdapter.queryList(
        'SELECT * FROM SpotEntity WHERE lat > ? AND lat < ? AND long > ? AND long < ? AND searchText LIKE ? COLLATE Vietnamese_CI_AI',
        arguments: <dynamic>[latStart, latEnd, longStart, longEnd, keyword],
        mapper: _spotEntityMapper);
  }

  @override
  Future<void> deleteAll() async {
    await _queryAdapter.queryNoReturn('DELETE FROM SpotEntity');
  }

  @override
  Future<void> deleteAllOfProvince(String uniqueKey) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM SpotEntity where uniqueKey = ?',
        arguments: <dynamic>[uniqueKey]);
  }

  @override
  Future<void> deleteAllOfProvinces(List<String> uniqueKeys) async {
    final valueList1 = uniqueKeys.map((value) => "'$value'").join(', ');
    await _queryAdapter.queryNoReturn(
        'DELETE FROM SpotEntity where uniqueKey IN ($valueList1)');
  }

  @override
  Future<void> insertSpot(SpotEntity item) async {
    await _spotEntityInsertionAdapter.insert(
        item, sqflite.ConflictAlgorithm.replace);
  }

  @override
  Future<void> insertSpots(List<SpotEntity> items) async {
    await _spotEntityInsertionAdapter.insertList(
        items, sqflite.ConflictAlgorithm.replace);
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

  @override
  Future<void> updateTravelSpotList(
      List<SpotEntity> spotList, List<String> uniqueKeys) async {
    if (database is sqflite.Transaction) {
      await super.updateTravelSpotList(spotList, uniqueKeys);
    } else {
      await (database as sqflite.Database)
          .transaction<void>((transaction) async {
        final transactionDatabase = _$AppDatabase(changeListener)
          ..database = transaction;
        await transactionDatabase.spotDao
            .updateTravelSpotList(spotList, uniqueKeys);
      });
    }
  }
}
