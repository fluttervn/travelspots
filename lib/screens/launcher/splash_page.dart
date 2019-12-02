import 'dart:async';

import 'package:flutter/material.dart';
import 'package:travelspots/common/base_state.dart';
import 'package:travelspots/screens/launcher/intro_page.dart';
import 'package:travelspots/utils/navigation.dart';

/// A class displays UI for Splash screen
class SplashPage extends StatefulWidget {
  @override
  SplashPageState createState() {
    // TODO: implement createState
    return SplashPageState();
  }
}

class SplashPageState extends BaseState<SplashPage> {
  final int DURATION = 2;

  _startTime() async {
    var _duration = new Duration(seconds: DURATION);
    return Timer(_duration, _navigationPage);
  }

  void _navigationPage() {
    Navigation.openScreen(context: context, page: IntroPage());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _startTime();
  }

  @override
  Widget buildChild(BuildContext context) {
    // TODO: implement buildChild
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          child: Image.asset(
            'assets/images/flutter_vn_logo.jpg',
            fit: BoxFit.cover,
          ),
          alignment: Alignment.center,
        ),
      ),
    );
  }
}
