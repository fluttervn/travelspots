import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fimber/flutter_fimber.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:travelspots/common/base_state.dart';
import 'package:travelspots/main_bloc.dart';
import 'package:travelspots/repos/models/ui_models/relic_ui_model.dart';
import 'package:travelspots/screens/launcher/map_bloc.dart';
import 'package:travelspots/utils/app_utils.dart';

/// A class displays map UI
class MapPage extends StatefulWidget {
  List<SpotUIModel> spots;
  MapPage({@required this.spots}) {
    Fimber.d("MapPage @spots=${this.spots}");
  }
  @override
  MapPageState createState() {
    return MapPageState();
  }
}

/// A class displays map state
class MapPageState extends BaseState<MapPage> {
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  MapBloc _mapBloc;
  MainBloc _mainBloc;
  SpotUIModel selectedSpot;
  StreamSubscription<LocationData> _locationSubscription;
  Location _locationService = new Location();
  bool _permission = false;
  String error;
  bool _isMoveToCurrentGps = false;

  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _initialCamera = CameraPosition(
    target:
        LatLng(10.762622, 106.660172), // Ho Chi Minh City(10.762622,106.660172)
    zoom: 4,
  );

  CameraPosition _currentCameraPosition;

  @override
  void initState() {
    super.initState();
    _mapBloc = providerOfBloc();
    _mainBloc = providerOfBloc();

    initPlatformState();
    if (widget.spots != null && widget.spots.length > 0) {
      for (var i = 0; i < widget.spots.length; i++) {
        SpotUIModel spotUIModel = widget.spots[i];
        _addMarker(i + 1, spotUIModel);
      }
    }
  }

  void _showModal(String title, String description) {
    Future<void> future = showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Wrap(
            children: <Widget>[
              Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(description),
            ],
          ),
          padding: EdgeInsets.all(16),
          height: 80,
        );
      },
    );
//    future.then((void value) => _closeModal(value));
  }

  void _onMarkerTapped(SpotUIModel spotUIModel) {
    selectedSpot = spotUIModel;
    _mapBloc.notifyMarkerTapped();
  }

  void _onMarkerDragEnd(MarkerId markerId, LatLng newPosition) async {
    final Marker tappedMarker = markers[markerId];
    if (tappedMarker != null) {
      await showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                actions: <Widget>[
                  FlatButton(
                    child: const Text('OK'),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
                content: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 66),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text('Old position: ${tappedMarker.position}'),
                        Text('New position: $newPosition'),
                      ],
                    )));
          });
    }
  }

  void _addMarker(int index, SpotUIModel spotUIModel) {
    Fimber.d(
        'MapPage _addMarker @title=${spotUIModel.name}, @description=${spotUIModel.description}');
    final String markerIdVal = 'marker_id_$index';
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(spotUIModel.lat, spotUIModel.long),
//      infoWindow: InfoWindow(title: title, snippet: description),
      onTap: () {
        _onMarkerTapped(spotUIModel);
      },
//      onDragEnd: (LatLng position) {
//        _onMarkerDragEnd(markerId, position);
//      },
    );

    markers[markerId] = marker;
  }

  /// Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    await _locationService.changeSettings(
        accuracy: LocationAccuracy.HIGH, interval: 1000);

    LocationData location;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      bool serviceStatus = await _locationService.serviceEnabled();
      print("Service status: $serviceStatus");
      if (serviceStatus) {
        _permission = await _locationService.requestPermission();
        print("Permission: $_permission");
        if (_permission) {
          location = await _locationService.getLocation();

          _locationSubscription = _locationService
              .onLocationChanged()
              .listen((LocationData result) async {
            if (!_isMoveToCurrentGps) {
              Fimber.d('MapView:onLocationChanged & not Moving to current');
              _currentCameraPosition = CameraPosition(
                  target: LatLng(result.latitude, result.longitude), zoom: 16);

              final GoogleMapController controller = await _controller.future;
              controller.animateCamera(
                  CameraUpdate.newCameraPosition(_currentCameraPosition));
              /*if(mounted){
              setState(() {
                _currentLocation = result;
              });
            }*/
              _isMoveToCurrentGps = true;
            }
          });
        }
      } else {
        bool serviceStatusResult = await _locationService.requestService();
        print("Service status activated after request: $serviceStatusResult");
        if (serviceStatusResult) {
          initPlatformState();
        }
      }
    } on PlatformException catch (e) {
      print(e);
      if (e.code == 'PERMISSION_DENIED') {
        error = e.message;
      } else if (e.code == 'SERVICE_STATUS_ERROR') {
        error = e.message;
      }
      location = null;
    }
/*
    setState(() {
      _startLocation = location;
    });*/
  }

  void _onGetNearbyPoi() async {
    Fimber.d('MapView: get nearby POI');
    final GoogleMapController controller = await _controller.future;
    LatLngBounds visibleRegion = await controller.getVisibleRegion();
    Fimber.d('new regionBound=$visibleRegion');
    List newRegion = AppUtils.calculateMapRegion(visibleRegion);
    Fimber.d('new extra region =$newRegion');

    _mainBloc.testQueryByGeolocation(
      latStart: newRegion[0],
      latEnd: newRegion[1],
      longStart: newRegion[2],
      longEnd: newRegion[3],
    );
  }

  @override
  void dispose() {
    super.dispose();
    Fimber.d('MapView:dispose');
    _mapBloc.notifyMarkerUnTapped();
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
  }

  ///Build bottom sheet
  Widget _buildBottomSheet() {
    return SlidingSheet(
      elevation: 8,
//      cornerRadius: 16,
      /*snapSpec: const SnapSpec(
        // Enable snapping. This is true by default.
        snap: true,
        // Set custom snapping points.
        snappings: [0.4, 0.7, 1.0],
        // Define to what the snappings relate to. In this case,
        // the total available space that the sheet can expand to.
        positioning: SnapPositioning.relativeToAvailableSpace,
      ),*/
      builder: (context, state) {
        // This is the content of the sheet that will get
        // scrolled, if the content is bigger than the available
        // height of the sheet.
        return Container(
          height: 100,
          child: Text(selectedSpot.name),
          padding: EdgeInsets.all(16),
        );
      },
    );
  }

  @override
  Widget buildChild(BuildContext context) {
    Fimber.d('MapView:buildChild');
    return Scaffold(
      appBar: AppBar(
        title: Text('Map'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _onGetNearbyPoi,
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: MapType.normal,
            myLocationEnabled: true,
            initialCameraPosition: _initialCamera,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            markers: Set<Marker>.of(markers.values),
          ),
          PropertyChangeConsumer<MapBloc>(
            properties: [
              MapProperties.markerTapped,
              MapProperties.markerUnTapped
            ],
            builder: (context, bloc, property) {
              Fimber.d('MapView @property=$property');
              if (property == MapProperties.markerTapped) {
                return Container(
                  child: _buildBottomSheet(),
                );
              } else {
                return Container();
              }
            },
          )
        ],
      ),
    );
  }
}
