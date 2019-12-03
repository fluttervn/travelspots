import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:travelspots/common/base_state.dart';
import 'package:travelspots/main.dart';
import 'package:travelspots/utils/navigation.dart';

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

  @override
  void initState() {
    super.initState();
    _launcherBloc = providerOfBloc();
    startCheckForUpdateWhenLaunchApp();

    _launcherBloc.nextActionController.stream.listen((launcherStepProps) {
      print('LauncherPage: has new launcherStepProps=$launcherStepProps');
      if (launcherStepProps == LauncherStepProps.home) {
        Navigation.openScreen(
          context: context,
          page: MyHomePage(),
          replaceScreen: true,
        );
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
              return _IntroPage(
                onNext: () {
                  _launcherBloc.onButtonNextOfIntroPress();
                },
              );
            } else if (property == LauncherStepProps.checkForUpdate) {
              return _CheckForUpdatePage();
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}

class _CheckForUpdatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('Check for update'),
      ),
      color: Colors.white,
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

class _IntroPage extends StatelessWidget {
  final VoidCallback onNext;

  const _IntroPage({Key key, this.onNext}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Text('Author by FlutterVN'),
              alignment: Alignment.bottomLeft,
            ),
          ),
          Expanded(
            child: Container(
              child: RaisedButton(
                child: Text(
                  'Next',
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: onNext,
              ),
              alignment: Alignment.bottomRight,
            ),
          ),
        ],
      ),
      padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
    );
  }
}
