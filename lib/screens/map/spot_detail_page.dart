import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:travelspots/repos/models/data_models/app_database_entity.dart';

class SpotDetailPage extends StatelessWidget {
  final SpotEntity spotDataModel;

  SpotDetailPage({this.spotDataModel});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(spotDataModel.name),
          subtitle: Text(spotDataModel.address),
        )
      ],
    );
  }
}
