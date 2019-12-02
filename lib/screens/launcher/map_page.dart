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
import 'package:travelspots/repos/models/data_models/app_database_entity.dart';
import 'package:travelspots/screens/launcher/map_bloc.dart';
import 'package:travelspots/utils/app_utils.dart';

/// A class displays map UI
class MapPage extends StatefulWidget {
  /*List<SpotUIModel> spots;
  MapPage({@required this.spots}) {
    Fimber.d("MapPage @spots=${this.spots}");
  }*/
  @override
  MapPageState createState() {
    return MapPageState();
  }
}

/// A class displays map state
class MapPageState extends BaseState<MapPage> {
  List<SpotEntity> _listSpotEntity;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  MapBloc _mapBloc;
  MainBloc _mainBloc;
  SpotEntity _selectedSpotEntity;
  StreamSubscription<LocationData> _locationSubscription;
  Location _locationService = new Location();
  bool _permission = false;
  String error;
  bool _isMoveToCurrentGps = false;

  Completer<GoogleMapController> _controller = Completer();
  /*CameraPosition _initialCamera = CameraPosition(
    target:
        LatLng(10.762622, 106.660172), // Ho Chi Minh City(10.762622,106.660172)
    zoom: 4,
  );*/
  static final double ZOOM = 16;
  CameraPosition _initialCamera = CameraPosition(
    target:
        LatLng(10.762622, 106.660172), // Ho Chi Minh City(10.762622,106.660172)
    zoom: ZOOM,
  );

  CameraPosition _currentCameraPosition;

  @override
  void initState() {
    super.initState();
    _mapBloc = providerOfBloc();
    _mainBloc = providerOfBloc();

    initPlatformState();
  }

  void _onMarkerTapped(SpotEntity spotEntity) {
    _selectedSpotEntity = spotEntity;
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

  void _addMarker(int index, SpotEntity spotEntity) {
//    Fimber.d(
//        'MapPage _addMarker @title=${spotEntity.name}, @description=${spotEntity.description}');
    final String markerIdVal = 'marker_id_$index';
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(spotEntity.lat, spotEntity.long),
//      infoWindow: InfoWindow(title: title, snippet: description),
      onTap: () {
        _onMarkerTapped(spotEntity);
      },
//      onDragEnd: (LatLng position) {
//        _onMarkerDragEnd(markerId, position);
//      },
    );
    markers[markerId] = marker;
//    _mapBloc.notifyMarkerAdded();
    /*setState(() {
      markers[markerId] = marker;
    });*/
  }

  /// Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    await _locationService.changeSettings(
        accuracy: LocationAccuracy.LOW, interval: 60000);

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
          _currentCameraPosition = CameraPosition(
              target: LatLng(location.latitude, location.longitude),
              zoom: ZOOM);
          _initialCamera = _currentCameraPosition;
          _mapBloc.notifyLocationFound();
          final GoogleMapController controller = await _controller.future;
          controller.animateCamera(
              CameraUpdate.newCameraPosition(_currentCameraPosition));

          /*_locationSubscription = _locationService
              .onLocationChanged()
              .listen((LocationData result) async {
            if (!_isMoveToCurrentGps) {
              Fimber.d('MapView:onLocationChanged & not Moving to current');
              _currentCameraPosition = CameraPosition(
                  target: LatLng(result.latitude, result.longitude), zoom: 16);

              final GoogleMapController controller = await _controller.future;
              await controller.animateCamera(
                  CameraUpdate.newCameraPosition(_currentCameraPosition));
//              _onGetNearbyPoi();
              */ /*if(mounted){
              setState(() {
                _currentLocation = result;
              });
            }*/ /*
              _isMoveToCurrentGps = true;
            }
          });*/
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

    _listSpotEntity = await _mainBloc.findSpotsInRegion(
      latStart: newRegion[0],
      latEnd: newRegion[1],
      longStart: newRegion[2],
      longEnd: newRegion[3],
    );
    if (_listSpotEntity != null && _listSpotEntity.length < 100) {
      for (var i = 0; i < _listSpotEntity.length; i++) {
        SpotEntity spotEntity = _listSpotEntity[i];
        _addMarker(i + 1, spotEntity);
      }
      _mapBloc.notifyMarkerAdded();
      _isMoveToCurrentGps = false;
    }
  }

  @override
  void dispose() {
    Fimber.d('MapView:dispose');
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _mapBloc.resetMapPropeties());
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
    super.dispose();
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
          child: Text(
              '${_selectedSpotEntity.name} - ID ${_selectedSpotEntity.id}'),
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
          PropertyChangeConsumer<MapBloc>(
            properties: [
              MapProperties.locationFound,
              MapProperties.markerAdded
            ],
            builder: (context, bloc, property) {
              Fimber.d('MapView display googlemap @property=$property');
              if (property == null) {
                return Container(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.black,
                  ),
                  alignment: Alignment.center,
                );
              } else if (property == MapProperties.locationFound ||
                  property == MapProperties.markerAdded) {
                return GoogleMap(
                  mapType: MapType.normal,
                  myLocationEnabled: true,
                  initialCameraPosition: _initialCamera,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                    Fimber.d('init: MapView: onMapCreated');
                  },
                  onCameraMoveStarted: () {
                    Fimber.d('MapView:onCameraMoveStarted');
                  },
                  onCameraIdle: () {
                    Fimber.d('init: MapView: onCameraIdle');
                    _onGetNearbyPoi();
                  },
                  markers: Set<Marker>.of(markers.values),
                );
              } else {
                return Container();
              }
            },
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
          ),
        ],
      ),
    );
  }
}
