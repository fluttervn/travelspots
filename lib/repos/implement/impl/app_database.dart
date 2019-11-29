// dao/person_dao.dart

import 'dart:async';

import 'package:floor/floor.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:travelspots/repos/models/data_models/app_database_entity.dart';

part 'app_database.g.dart';

@dao
abstract class SpotDao {
  @Query('SELECT * FROM SpotEntity')
  Future<List<SpotEntity>> getAll();

  @Query('SELECT * FROM SpotEntity WHERE id = :id')
  Future<SpotEntity> findPersonById(int id);

  @Insert(onConflict: OnConflictStrategy.REPLACE)
  Future<void> insertSpot(SpotEntity item);

  @insert
  Future<void> insertSpots(List<SpotEntity> items);

  @Query('DELETE FROM SpotEntity')
  Future<void> deleteAll();

  @transaction
  Future<void> insertDataFirstTime(List<SpotEntity> items) async {
    await deleteAll();
    await insertSpots(items);
  }
}

@Database(version: 1, entities: [SpotEntity])
abstract class AppDatabase extends FloorDatabase {
  SpotDao get spotDao;
}
