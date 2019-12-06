import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:travelspots/repos/models/data_models/app_database_entity.dart';
import 'package:url_launcher/url_launcher.dart';

class SpotDetailPage extends StatefulWidget {
  final SpotEntity spotDataModel;

  SpotDetailPage({
    Key key,
    this.spotDataModel,
  }) : super(key: key);

  @override
  SpotDetailPageState createState() => SpotDetailPageState();
}

class SpotDetailPageState extends State<SpotDetailPage> {
  bool isFullScreen = false;

  _launchWikiURL(String url) async {
//    const url = 'https://goo.gl/maps/GtRgtRqrALiD2jJ49';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _launchGoogleURL(String url) async {
//    const url = 'https://goo.gl/maps/GtRgtRqrALiD2jJ49';
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

  void onPanelOpened() {
    setState(() {
      isFullScreen = true;
    });
  }

  void onPanelClosed() {
    setState(() {
      isFullScreen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('rebuild..');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Center(
          child: SizedBox(
            height: 32,
            child: Center(
              child: isFullScreen
                  ? IconButton(
                      icon: Icon(
                        Icons.arrow_drop_down_circle,
                        size: 32,
                        color: Colors.grey[400],
                      ),
                    )
                  : Container(
//                      margin: EdgeInsets.all(12),
                      width: 30,
                      height: 5,
                      decoration: BoxDecoration(
                          color: isFullScreen
                              ? Colors.transparent
                              : Colors.grey[300],
                          borderRadius:
                              BorderRadius.all(Radius.circular(12.0))),
                    ),
            ),
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          widget.spotDataModel.name,
          maxLines: isFullScreen ? null : 1,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        SizedBox(
          height: 4,
        ),
        Text(
          '${widget.spotDataModel.address}, ${widget.spotDataModel.district}',
          maxLines: isFullScreen ? null : 1,
          style: TextStyle(color: Colors.grey),
          overflow: isFullScreen ? TextOverflow.visible : TextOverflow.ellipsis,
        ),
        SizedBox(
          height: 4,
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
                _launchGoogleURL(widget.spotDataModel.locationLink);
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
                _launchWikiURL(widget.spotDataModel.wikiLink);
              },
            )
          ],
        )
      ],
    );
  }
}
