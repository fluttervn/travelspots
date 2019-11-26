import 'package:flutter/material.dart';

/// A class displays UI for Splash screen
class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 6 / 13,
              child: Image.asset(
                'assets/images/tabula_learning_logo.png',
                fit: BoxFit.cover,
              ),
              alignment: Alignment.bottomCenter,
            ),
            Container(
              height: MediaQuery.of(context).size.height / 2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: 50),
                  CircularProgressIndicator(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
