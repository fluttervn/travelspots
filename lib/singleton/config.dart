import 'package:travelspots/custom_packages/worker/worker.dart';
import 'package:travelspots/repos/app_repo.dart';
import 'package:travelspots/repos/implement/impl/app_database.dart';
import 'package:travelspots/repos/implement/impl/app_repo_impl.dart';
import 'package:travelspots/repos/local/local_provider.dart';
import 'package:travelspots/repos/remote/remote_provider.dart';

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
  static RemoteProvider _remoteProvider = RemoteProvider();
  static LocalProvider _localProvider = LocalProvider();
  static Worker _worker = Worker(poolSize: 3);

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
      _appRepo = AppRepoImpl(
        remoteProvider: _remoteProvider,
        localProvider: _localProvider,
        appDatabase: appDatabase,
        worker: _worker,
      );
    }
    return _appRepo;
  }
}
