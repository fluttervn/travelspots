import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:travelspots/screens/launcher/map_page.dart';
import 'package:travelspots/utils/navigation.dart';

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
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );

    tree = PropertyChangeProvider(value: _mainBloc, child: tree);
    return tree;
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends BaseState<MyHomePage> {
  MainBloc _mainBloc;
  int _counter = 0;

  @override
  void initState() {
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Travel Spots'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _createRelic,
          ),
          IconButton(
            icon: Icon(Icons.import_export),
            onPressed: _loadCSV,
          )
        ],
      ),
      body: Center(
        child: Column(
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
      floatingActionButton: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 31),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: FloatingActionButton(
                      heroTag: 'tag2',
                      onPressed: () {
                        // Open Search page
                      },
                      child: Icon(Icons.search),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.0),
                    child: FloatingActionButton(
                      heroTag: 'tag3',
                      onPressed: () {
                        // Open MapView page
                        Navigation.openScreen(
                            context: context, page: MapPage());
                      },
                      child: Icon(Icons.map),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              heroTag: 'tag1',
              onPressed: _getRelics,
              tooltip: 'Increment',
              child: Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }

  void _loadCSV() async {
    CSVUtils.importJsonDataToFirestore();
  }
}
