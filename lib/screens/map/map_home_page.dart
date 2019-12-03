import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fimber/flutter_fimber.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:travelspots/common/base_bloc.dart';
import 'package:travelspots/common/base_state.dart';
import 'package:travelspots/common/demo_search_page.dart';
import 'package:travelspots/repos/models/ui_models/spot_ui_model.dart';
import 'package:travelspots/singleton/config.dart';
import 'package:travelspots/utils/csv_utils.dart';
import 'package:travelspots/utils/navigation.dart';

import 'main_bloc.dart';
import 'map_page.dart';

class MapHomePage extends StatefulWidget {
  @override
  _MapHomePageState createState() => _MapHomePageState();
}

class _MapHomePageState extends BaseState<MapHomePage> {
  MainBloc _mainBloc;
  int _counter = 0;
  List<SpotUIModel> spots;

  @override
  void initState() {
    super.initState();
    _mainBloc = providerOfBloc();
  }

  void _clearFirstTimeLauncherSetting() async {
    print('Reset FirstTimeLauncher to default');
    Config.localProvider.setFirstTimeLauncher(true);
  }

  void _getTravelSpots() async {
    spots = await _mainBloc.getTravelSpots();
  }

  void _checkUpdate() async {
    print('check update');
    await _mainBloc.checkUpdateData();
  }

  @override
  Widget buildChild(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Travel Spots'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.update),
            onPressed: _checkUpdate,
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
                          page: MapPage(),
                        );
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
              onPressed: _clearFirstTimeLauncherSetting,
              tooltip: 'Clear FirstLaunchTime',
              child: Icon(Icons.remove_shopping_cart),
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
