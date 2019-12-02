import 'package:flutter/material.dart';
import 'package:travelspots/screens/launcher/map_page.dart';
import 'package:travelspots/utils/navigation.dart';

class IntroPage extends StatelessWidget {
  void _onNextPressed(BuildContext context) {
    Navigation.openScreen(context: context, page: MapPage());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
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
                    onPressed: () {
                      _onNextPressed(context);
                    },
                  ),
                  alignment: Alignment.bottomRight,
                ),
              ),
            ],
          ),
          padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
        ),
      ),
    );
  }
}
