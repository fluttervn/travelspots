import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fimber/flutter_fimber.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:travelspots/repos/implement/impl/app_database.dart';
import 'package:travelspots/screens/launcher/launcher_bloc.dart';
import 'package:travelspots/screens/launcher/launcher_page.dart';
import 'package:travelspots/screens/launcher/map_bloc.dart';

import 'screens/map/main_bloc.dart';
import 'singleton/config.dart';

void main() async {
  Fimber.plantTree(FimberTree());
  Config.shared.appDatabase =
      await $FloorAppDatabase.databaseBuilder('flutter_database.db').build();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final LauncherBloc _launcherBloc = LauncherBloc(
    appRepo: Config.shared.getAppRepo(),
    spotDao: Config.shared.appDatabase.spotDao,
    localProvider: Config.localProvider,
  );
  final MainBloc _mainBloc = MainBloc(
    appRepo: Config.shared.getAppRepo(),
    spotDao: Config.shared.appDatabase.spotDao,
  );
  final MapBloc _mapBloc = MapBloc();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Fimber.d('build one time');

    Widget tree = MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LauncherPage(),
    );

    tree = PropertyChangeProvider(value: _launcherBloc, child: tree);
    tree = PropertyChangeProvider(value: _mainBloc, child: tree);
    tree = PropertyChangeProvider(value: _mapBloc, child: tree);
    return tree;
  }
}
