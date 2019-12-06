import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CheckForUpdatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SpinKitRing(
            color: Colors.blue,
            size: 100,
            duration: Duration(milliseconds: 700),
          ),
          SizedBox(height: 60),
          Text(
            'Updating app data. Please wait...',
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
          ),
        ],
      ),
    );
  }
}
