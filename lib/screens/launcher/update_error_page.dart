import 'package:flutter/material.dart';

class CheckForUpdateErrorPage extends StatelessWidget {
  final VoidCallback onRetry;
  final VoidCallback onSkip;

  CheckForUpdateErrorPage({this.onRetry, this.onSkip});

  @override
  Widget build(BuildContext context) {
    Container skipButton = Container();
    if (onSkip != null) {
      skipButton = Container(
        child: RaisedButton(
          child: Text('Skip'),
          onPressed: this.onRetry,
        ),
        width: 150,
        height: 40,
      );
    }
    return Container(
      child: Column(
        children: <Widget>[
          Text(
            'There was a problem! Please try again.',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            child: RaisedButton(
              child: Text('Retry'),
              onPressed: onRetry,
            ),
            width: 150,
            height: 40,
          ),
          SizedBox(
            height: 20,
          ),
          skipButton,
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
      width: double.infinity,
    );
  }
}
