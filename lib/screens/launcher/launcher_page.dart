import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:travelspots/common/base_state.dart';
import 'package:travelspots/screens/map/map_page.dart';
import 'package:travelspots/utils/navigation.dart';

import 'intro_page.dart';
import 'launcher_bloc.dart';
import 'update_page.dart';

/// A class displays UI for Launcher screen
class LauncherPage extends StatefulWidget {
  @override
  LauncherPageState createState() {
    return LauncherPageState();
  }
}

class LauncherPageState extends BaseState<LauncherPage> {
  LauncherBloc _launcherBloc;

  startCheckForUpdateWhenLaunchApp() async {
    _launcherBloc.startCheckForUpdateWhenLaunchApp();
  }

  _openMapPage() async {
    print('Launcher: open MapPage');
    Navigation.openScreen(
      context: context,
      page: MapPage(),
      replaceScreen: true,
    );
  }

  @override
  void initState() {
    super.initState();
    _launcherBloc = providerOfBloc();
    startCheckForUpdateWhenLaunchApp();

    _launcherBloc.nextActionController.stream.listen((launcherStepProps) {
      print('LauncherPage: has new launcherStepProps=$launcherStepProps');
      if (launcherStepProps == LauncherStepProps.home) {
        _openMapPage();
      }
    });
  }

  @override
  void dispose() {
    _launcherBloc?.dispose();
    super.dispose();
  }

  @override
  Widget buildChild(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: PropertyChangeConsumer<LauncherBloc>(
          properties: [
            LauncherStepProps.intro,
            LauncherStepProps.checkForUpdate,
//            LauncherStepProps.home,
            LauncherStepProps.splash,
          ],
          builder: (context, bloc, property) {
            print('LauncherBloc: pros: $property, bloc: $bloc');
            if (property == null || property == LauncherStepProps.splash) {
              return _SplashPage();
            } else if (property == LauncherStepProps.intro) {
              return IntroPage(
                onNext: () {
                  _launcherBloc.onButtonNextOfIntroPress();
                },
              );
            } else if (property == LauncherStepProps.checkForUpdate) {
              return CheckForUpdatePage();
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}

class _SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.asset(
        'assets/images/flutter_vn_logo.jpg',
        fit: BoxFit.cover,
      ),
      alignment: Alignment.center,
      color: Colors.white,
    );
  }
}
