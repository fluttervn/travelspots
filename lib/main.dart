import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

import 'common/base_bloc.dart';
import 'common/base_state.dart';
import 'main_bloc.dart';
import 'repos/models/ui_models/relic_ui_model.dart';
import 'singleton/config.dart';
import 'utils/csv_utils.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final MainBloc _mainBloc = MainBloc(appRepo: Config.shared.getAppRepo());
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Fimber.d('build one time');

    Widget tree = MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );

    tree = PropertyChangeProvider(value: _mainBloc, child: tree);
    return tree;
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends BaseState<MyHomePage> {
  MainBloc _mainBloc;
  int _counter = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _mainBloc = providerOfBloc();
  }

  void _getRelics() {
    _mainBloc.getRelicList();
  }

  void _createRelic() async {
    _counter++;
    await _mainBloc.createRelic(
      RelicUIModel(
          name: 'Địa đạo Củ Chi $_counter',
          address:
              'Xã Phú Mỹ Hưng, xã Phạm Văn Cội, xã Nhuận Đức, huyện Củ Chi',
          description: 'Di tích lịch sử Địa đạo Củ Chi '),
    );
  }

  @override
  Widget buildChild(BuildContext context) {
    // TODO: implement buildChild
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _createRelic,
          ),
          IconButton(
            icon: Icon(Icons.file_download),
            onPressed: _loadCSV,
          )
        ],
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Relics:',
            ),
            PropertyChangeConsumer<MainBloc>(
              properties: [
                BaseBlocProperties.loading,
                BaseBlocProperties.serverError,
                BaseBlocProperties.serverSuccess,
              ],
              builder: (context, bloc, property) {
                Fimber.d('pros: $property, bloc: $bloc');
                if (property == null) {
                  return Center(
                    child: Text('Press button to get data'),
                  );
                } else if (property == BaseBlocProperties.loading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (property == BaseBlocProperties.serverError) {
                  return Center(
                    child: Text('error'),
                  );
                } else {
                  Fimber.d('pros: ${bloc.relics}');
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: bloc.relics.length,
                    itemBuilder: (context, index) {
                      return Text(
                        bloc.relics[index].name,
                        style: TextStyle(color: Colors.blue),
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getRelics,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _loadCSV() async {
    CSVUtils.importJsonDataToFirestore();
  }
}
