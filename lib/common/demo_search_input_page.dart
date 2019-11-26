import 'dart:io';

import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:travelspots/utils/navigation.dart';

class DemoSearchInputPage extends StatefulWidget {
  @override
  _DemoSearchInputPageState createState() => _DemoSearchInputPageState();
}

class _DemoSearchInputPageState extends State<DemoSearchInputPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text('Content'),
        ),
      ),
      appBar: AppBar(
        primary: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigation.goBack(context);
          },
        ),
        title: TextField(
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search for travel spots...',
            border: InputBorder.none,
            hintStyle: TextStyle(
              color: Colors.grey.shade300,
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.clear, color: Colors.red.shade800),
            onPressed: () {
              Fimber.d('touch on INFO');
            },
          )
        ],
      ),
    );
  }
}
