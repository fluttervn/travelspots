import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:travelspots/common/base_bloc.dart';
import 'package:travelspots/repos/app_repo.dart';
import 'package:travelspots/repos/implement/impl/app_database.dart';
import 'package:travelspots/repos/local/local_provider.dart';
import 'package:travelspots/repos/models/data_models/app_database_entity.dart';

enum LauncherStepProps { splash, intro, checkForUpdate, home }
enum CheckForUpdateProps { inProgress, success, failed }

/// Business Logic related to Login feature
class LauncherBloc extends BaseBloc<LauncherStepProps> {
  final int splashTimeInMillis = 1000; // 1000 ms
  /// Provide account data from network or local
  final AppRepo appRepo;
  final SpotDao spotDao;
  final LocalProvider localProvider;

  LauncherStepProps currentLauncherStep = LauncherStepProps.splash;
  StreamController nextActionController = StreamController<LauncherStepProps>();

  bool isFirstTimeLauncher;

  CheckForUpdateProps checkForUpdateStatus = CheckForUpdateProps.inProgress;

  /// Error message
  String errorMessage = '';

  /// Create instance of AccountBloc, it require repository to get data.
  LauncherBloc({
    @required this.appRepo,
    @required this.spotDao,
    @required this.localProvider,
  }) : assert(appRepo != null && spotDao != null);

  @override
  String toString() {
    return 'LauncherBloc';
  }

  @override
  void dispose() {
    print('LauncherBloc: dispose()');
    super.dispose();
    nextActionController?.close();
  }

  startCheckForUpdateWhenLaunchApp() async {
    /*List pop1 = await spotDao.findSpotByPopularity(1);
    print('findSpotByPopularity(1) = ${pop1?.length} items');
    List pop2 = await spotDao.findSpotByPopularity(2);
    print('findSpotByPopularity(2) = ${pop2?.length} items');
    List pop3 = await spotDao.findSpotByPopularity(3);
    print('findSpotByPopularity(3) = ${pop3?.length} items');
    List pop4 = await spotDao.findSpotByPopularity(4);
    print('findSpotByPopularity(4) = ${pop4?.length} items');
    List popNone = await spotDao.findSpotByNoPopularity();
    print('findSpotByNoPopularity = ${popNone?.length} items');*/

    // Check whether is the first time?
    isFirstTimeLauncher = await localProvider.isFirstTimeLauncher();

    startSplashTimer();
    // If yes, must show Intro page after Splash

    // Start check for update too
    checkUpdateData();
  }

  startSplashTimer() async {
    print('Launcher: startSplashTimer');
    var _duration = new Duration(milliseconds: splashTimeInMillis);
    Timer(_duration, () {
      print('Launcher: splashTimer is done: firstTime=$isFirstTimeLauncher');
      if (isFirstTimeLauncher) {
        print('... Launcher: notify LauncherStepProps.intro');

        // Mark isFirstTimeLauncher to false
        localProvider.setFirstTimeLauncher(false);

        currentLauncherStep = LauncherStepProps.intro;
        notifyListeners(currentLauncherStep);
      } else {
        print('... Launcher: waitForCheckForUpdatePageOrToHomePage');
        waitForCheckForUpdatePageOrToHomePage();
      }
    });
  }

  /// Handle press action when touch on NEXT button in IntroPage
  onButtonNextOfIntroPress() async {
    print('Launcher: onNext: waitForCheckForUpdatePageOrToHomePage');
    waitForCheckForUpdatePageOrToHomePage();
  }

  waitForCheckForUpdatePageOrToHomePage() async {
    print('Launcher: handle waitForCheckForUpdatePageOrToHomePage');
    if (checkForUpdateStatus == CheckForUpdateProps.success) {
      print('... Launcher: CFU success: to LauncherStepProps.home');
      /*currentLauncherStep = LauncherStepProps.home;
      notifyListeners(currentLauncherStep);*/
      nextActionController.sink.add(LauncherStepProps.home);
    } else if (checkForUpdateStatus == CheckForUpdateProps.failed) {
      print('... Launcher: CFU failed: to LauncherStepProps.home');
      currentLauncherStep = LauncherStepProps.home;
      notifyListeners(currentLauncherStep);
    } else if (checkForUpdateStatus == CheckForUpdateProps.inProgress) {
      print('... Launcher: CFU inProgr: to LauncherStepProps.checkForUpdate');
      currentLauncherStep = LauncherStepProps.checkForUpdate;
      notifyListeners(currentLauncherStep);
    }
  }

  Future checkUpdateData() async {
    print('MainBloc: checkUpdateData');
//    notifyListeners(BaseBlocProperties.loading);
//    var list = await appRepo.getProvinceMetaList();
//    print('list: $list');

    checkForUpdateStatus = CheckForUpdateProps.inProgress;

    try {
      ProvinceMetaData provinceMetaData = await appRepo.getOutOfDateProvinces();
      var outOfDateList = provinceMetaData.outOfDateList;
      print('Out of date provinces are: $outOfDateList');

      if (outOfDateList != null && outOfDateList.isNotEmpty) {
        print('Fetching new data of ${outOfDateList.length} provinces');
        List<Future<List<SpotEntity>>> tasks = [];
        outOfDateList.forEach((province) {
          tasks.add(appRepo.importGSheetData(
            province.spreadsheetId,
            province.worksheetId,
            province.provinceName,
          ));
        });
        List<List<SpotEntity>> data = await Future.wait(tasks);
        print('Update multiple ${data?.length} provinces DONE: ');

        List<SpotEntity> fullData = [];
        data.forEach((item) => fullData.addAll(item));
        print('Total SpotEntity is: ${fullData.length} items');

        Map<String, int> localIdTimeAll = provinceMetaData.localIdTimeAll;
        List<String> uniqueKeys = [];
        outOfDateList.forEach((item) {
          uniqueKeys.add(item.uniqueKey);
        });

        print('List of out-of-date uniqueKeys: $uniqueKeys');

        await appRepo.updateTravelSpotList(
          spotList: fullData,
          uniqueKeys: uniqueKeys,
        );
        await appRepo.setProvinceMetaList(localIdTimeAll);
      }

      checkForUpdateStatus = CheckForUpdateProps.success;

      if (currentLauncherStep == LauncherStepProps.checkForUpdate) {
        // If user is in page CheckForUpdate, it means he is waiting for
        // CFU successfully
        print('Is in CheckForUpdate page, and update result is SUCCESS');
        nextActionController.sink.add(LauncherStepProps.home);
      }
    } on Exception catch (e) {
      checkForUpdateStatus = CheckForUpdateProps.failed;
      print('checkUpdateData err: $e');
    }
  }
}
