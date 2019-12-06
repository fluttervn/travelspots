import 'package:flutter/material.dart';
import 'package:flutter_fimber/flutter_fimber.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:travelspots/common/base_state.dart';
import 'package:travelspots/screens/launcher/update_error_page.dart';
import 'package:travelspots/screens/launcher/update_page.dart';
import 'package:travelspots/screens/map/map_page.dart';
import 'package:travelspots/utils/navigation.dart';

import 'intro_page.dart';
import 'launcher_bloc.dart';

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

  void _onRetryClicked() {
    Fimber.d('Launch:_onRetryClicked');
    _launcherBloc.checkUpdateData();
    _openMapPage();
  }

  void _onSkipClicked() {
    Fimber.d('Launch:_onSkipClicked');
  }

  @override
  Widget buildChild(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: PropertyChangeConsumer<LauncherBloc>(
          properties: [
            LauncherStepProps.intro,
            LauncherStepProps.checkForUpdate,
            LauncherStepProps.checkForUpdate1stError,
            LauncherStepProps.checkForUpdate2ndError,
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
            } else if (property == LauncherStepProps.checkForUpdate1stError) {
              return CheckForUpdateErrorPage(
                onRetry: _onRetryClicked,
              );
            } else if (property == LauncherStepProps.checkForUpdate2ndError) {
              return CheckForUpdateErrorPage(
                onRetry: _onRetryClicked,
                onSkip: _onSkipClicked,
              );
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
