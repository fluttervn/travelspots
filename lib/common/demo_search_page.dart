import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:travelspots/utils/navigation.dart';

class DemoSearchPage extends StatefulWidget {
  @override
  _DemoSearchPageState createState() => _DemoSearchPageState();
}

class _DemoSearchPageState extends State<DemoSearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text('Content'),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Icon(Icons.search, color: Colors.red.shade400),
        primary: true,
        title: GestureDetector(
          onTap: () {
            Fimber.d('tap on search content -> open SearchInput page');
          },
          child: TextField(
            enabled: false,
            decoration: InputDecoration(
              hintText: "Search for travel spots",
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.info_outline, color: Colors.red.shade800),
            onPressed: () {
              Fimber.d('touch on INFO');
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_back),
        onPressed: () {
          Fimber.d('back to Homepage');
          Navigation.goBack(context);
        },
      ),
    );
  }
}
