import 'package:flutter/material.dart';

class IntroPage extends StatelessWidget {
  final VoidCallback onNext;

  const IntroPage({Key key, this.onNext}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 32,
          ),
          Text(
            'Welcom to Travel Spots',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 36,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            'The app is developed by FlutterVN team. It help travelers:',
            style: TextStyle(fontSize: 18),
          ),
          Text(
            '- Easy to find near by famous location as markets, relics, temples,...',
            style: TextStyle(fontSize: 18),
          ),
          Text(
            '- Get details info you specific location.',
            style: TextStyle(fontSize: 18),
          ),
          Text(
            '- Show direction to your desired location.',
            style: TextStyle(fontSize: 18),
          ),
          Expanded(
            child: Container(
              child: RaisedButton(
                child: Text(
                  'Enjoy your trip',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                onPressed: onNext,
                color: Colors.blue,
              ),
              alignment: Alignment.center,
            ),
          ),
        ],
      ),
      padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
    );
  }
}
