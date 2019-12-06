import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:travelspots/repos/models/data_models/app_database_entity.dart';
import 'package:url_launcher/url_launcher.dart';

class SpotDetailPage extends StatelessWidget {
  final SpotEntity spotDataModel;

  SpotDetailPage({this.spotDataModel});

  _launchWikiURL(String url) async {
    const url = 'https://goo.gl/maps/GtRgtRqrALiD2jJ49';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _launchGoogleURL(String url) async {
    const url = 'https://goo.gl/maps/GtRgtRqrALiD2jJ49';
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(spotDataModel.name),
          subtitle: Text('${spotDataModel.address}, ${spotDataModel.district}'),
        ),
        SizedBox(
          height: 8.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  side: BorderSide(color: Colors.blue, width: 1)),
              color: Colors.blue,
              child: Text(
                'View on Google',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                _launchGoogleURL(spotDataModel.locationLink);
              },
            ),
            RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  side: BorderSide(color: Colors.blue, width: 1)),
              color: Colors.white,
              child: Text(
                'View on Wiki',
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                _launchWikiURL(spotDataModel.locationLink);
              },
            )
          ],
        )
      ],
    );
  }
}
