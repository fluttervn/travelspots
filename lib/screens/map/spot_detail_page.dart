import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:travelspots/repos/models/data_models/app_database_entity.dart';
import 'package:url_launcher/url_launcher.dart';

class SpotDetailPage extends StatefulWidget {
  final SpotEntity spotDataModel;
  final VoidCallback togglePanel;

  SpotDetailPage({
    Key key,
    this.togglePanel,
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
    print('rebuild..${widget.spotDataModel.imageLink}');
    return Column(
      children: <Widget>[
        InkWell(
          child: Container(
              padding: EdgeInsets.only(bottom: 16),
//            color: Colors.red,
              width: double.infinity,
              height: 40,
              child: isFullScreen
                  ? Icon(
                      Icons.arrow_drop_down,
                      size: 32,
                      color: Colors.grey[400],
                    )
                  : Icon(
                      Icons.arrow_drop_up,
                      size: 32,
                      color: Colors.grey[400],
                    )

//            Icon(
//                    Icons.arrow_upward,
//                    size: 32,
//                    color: Colors.grey[400],
//                  ),
              ),
          onTap: () {
            widget.togglePanel();
          },
        ),
        SingleChildScrollView(
//      physics: isFullScreen
//          ? AlwaysScrollableScrollPhysics()
//          : NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
//              SizedBox(
//                height: 8,
//              ),
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
                overflow:
                    isFullScreen ? TextOverflow.visible : TextOverflow.ellipsis,
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
              ),
              SizedBox(
                height: 8.0,
              ),
              Image.network(
                  'https://vi.wikipedia.org/wiki/Tr%C6%B0%E1%BB%9Dng_Trung_h%E1%BB%8Dc_ph%E1%BB%95_th%C3%B4ng_chuy%C3%AAn_L%C3%AA_H%E1%BB%93ng_Phong,_Th%C3%A0nh_ph%E1%BB%91_H%E1%BB%93_Ch%C3%AD_Minh#/media/T%E1%BA%ADp_tin:Tr%C6%B0%E1%BB%9Dng_Trung_h%E1%BB%8Dc_Petrus_K%C3%BD.jpg'),
              SizedBox(
                height: 8.0,
              ),
              Text(widget.spotDataModel.description),
            ],
          ),
        ),
      ],
    );
  }
}
