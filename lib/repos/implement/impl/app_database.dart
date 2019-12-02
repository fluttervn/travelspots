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
  Future<SpotEntity> findSpotById(int id);

  @Query('SELECT * FROM SpotEntity WHERE lat > :latStart AND lat < :latEnd '
      'AND long > :longStart AND long < :longEnd')
  Future<List<SpotEntity>> findSpotsInRegion(
      double latStart, double latEnd, double longStart, double longEnd);

  @Insert(onConflict: OnConflictStrategy.REPLACE)
  Future<void> insertSpot(SpotEntity item);

  @Insert(onConflict: OnConflictStrategy.REPLACE)
  Future<void> insertSpots(List<SpotEntity> items);

  @Query('DELETE FROM SpotEntity')
  Future<void> deleteAll();

  @Query('DELETE FROM SpotEntity where uniqueKey = :uniqueKey')
  Future<void> deleteAllOfProvince(String uniqueKey);

  @Query('DELETE FROM SpotEntity where uniqueKey IN (:uniqueKeys)')
  Future<void> deleteAllOfProvinces(List<String> uniqueKeys);

  @transaction
  Future<void> insertDataFirstTime(List<SpotEntity> items) async {
    await deleteAll();
    await insertSpots(items);
  }

  /// Update new Spot data to database, also clear all existing Spot data of
  /// these provinces in database
  @transaction
  Future<void> updateTravelSpotList(
    List<SpotEntity> spotList,
    List<String> uniqueKeys,
  ) async {
    await deleteAllOfProvinces(uniqueKeys);
    await insertSpots(spotList);
  }
}

@Database(version: 1, entities: [SpotEntity])
abstract class AppDatabase extends FloorDatabase {
  SpotDao get spotDao;
}
