import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fimber/flutter_fimber.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:travelspots/common/demo_search_page.dart';
import 'package:travelspots/repos/implement/impl/app_database.dart';
import 'package:travelspots/screens/launcher/map_bloc.dart';
import 'package:travelspots/screens/launcher/map_page.dart';
import 'package:travelspots/utils/navigation.dart';

import 'common/base_bloc.dart';
import 'common/base_state.dart';
import 'main_bloc.dart';
import 'repos/models/ui_models/relic_ui_model.dart';
import 'singleton/config.dart';
import 'utils/csv_utils.dart';

void main() async {
  Fimber.plantTree(FimberTree());
  Config.shared.appDatabase =
      await $FloorAppDatabase.databaseBuilder('flutter_database.db').build();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final MainBloc _mainBloc = MainBloc(
    appRepo: Config.shared.getAppRepo(),
    spotDao: Config.shared.appDatabase.spotDao,
  );
  final MapBloc _mapBloc = MapBloc();
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
    tree = PropertyChangeProvider(value: _mapBloc, child: tree);
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
  List<SpotUIModel> spots;

  @override
  void initState() {
    super.initState();
    _mainBloc = providerOfBloc();
  }

  void _getTravelSpots() async {
    spots = await _mainBloc.getTravelSpots();
  }

  void _createTravelSpot() async {
    _counter++;
    await _mainBloc.createTravelSpot(
      SpotUIModel(
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
            onPressed: _createTravelSpot,
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
                  Fimber.d('pros: ${bloc.spots}');
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: bloc.spots.length,
                    itemBuilder: (context, index) {
                      return Text(
                        bloc.spots[index].district,
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
                        Navigation.openScreen(
                          context: context,
                          page: DemoSearchPage(),
                        );
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
                            context: context,
                            page: MapPage(
                              spots: this.spots,
                            ));
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
              onPressed: _getTravelSpots,
              tooltip: 'Download all Travel Spots data',
              child: Icon(Icons.file_download),
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
