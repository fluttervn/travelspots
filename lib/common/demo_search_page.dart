import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:travelspots/utils/navigation.dart';

import 'demo_search_input_page.dart';

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
          child: Text('Let touch on SearchBar in the AppBar'),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Icon(Icons.search, color: Colors.red.shade400),
        primary: true,
        title: GestureDetector(
          onTap: () {
            Fimber.d('tap on search content -> open SearchInput page');
            Navigation.openScreen(
              context: context,
              page: DemoSearchInputPage(),
            );
          },
          child: Text(
            'Search for travel spots...',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 18,
              fontWeight: FontWeight.w400,
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
