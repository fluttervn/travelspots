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

  @Query('SELECT name FROM SpotEntity WHERE popularity = :popularity')
  Future<List<SpotEntity>> findSpotByPopularity(int popularity);

  @Query('SELECT name FROM SpotEntity WHERE popularity NOT IN (1,2,3)')
  Future<List<SpotEntity>> findSpotByNoPopularity();

  @Query('SELECT * FROM SpotEntity WHERE lat > :latStart AND lat < :latEnd '
      'AND long > :longStart AND long < :longEnd AND popularity <= :popularityLessThanOrEqual')
  Future<List<SpotEntity>> findSpotsInRegion(
    double latStart,
    double latEnd,
    double longStart,
    double longEnd,
    int popularityLessThanOrEqual,
  );

  @Query('SELECT * FROM SpotEntity WHERE lat > :latStart AND lat < :latEnd '
      'AND long > :longStart AND long < :longEnd '
      'AND name LIKE N:keyword COLLATE Vietnamese_CI_AI')
  Future<List<SpotEntity>> findSpotsInRegionByName(
    double latStart,
    double latEnd,
    double longStart,
    double longEnd,
    String keyword,
  );

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

@Database(version: 2, entities: [SpotEntity])
abstract class AppDatabase extends FloorDatabase {
  SpotDao get spotDao;
}
