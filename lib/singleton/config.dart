import 'package:travelspots/repos/app_repo.dart';
import 'package:travelspots/repos/implement/impl/app_database.dart';
import 'package:travelspots/repos/implement/impl/app_repo_impl.dart';

/// Flavor is the app flavor (schema)
enum Flavor {
  /// Mock is with fake data, for developer side only, no Crashlytics
  mock,

  /// Dev is for developer side only too, with Dev endpoint, no Crashlytics
  dev,

  /// Staging is for developer side too, but with Staging endpoint, no Crashlytics
  staging,

  /// Staging is for QA side, with Staging endpoint, with Crashlytics
  staqing,

  /// Staging is for QA side and AppStore, with Production endpoint and Crashlytics
  production,
}

/// A class help getting actual repository
class Config {
  static Config _singleton;

  /// Get a non-null instance of Config
  static Config get shared {
    if (_singleton == null) {
      _singleton = Config();
    }
    return _singleton;
  }

  AppRepo _appRepo;
  AppDatabase appDatabase;

  /// Method to get app repository
  AppRepo getAppRepo() {
    if (_appRepo == null) {
      _appRepo = AppRepoImpl();
    }
    return _appRepo;
  }
}
