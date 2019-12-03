import 'package:flutter/material.dart';

class IntroPage extends StatelessWidget {
  final VoidCallback onNext;

  const IntroPage({Key key, this.onNext}) : super(key: key);

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
