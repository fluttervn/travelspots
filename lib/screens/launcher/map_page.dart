import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

/// A class displays map UI
class MapPage extends StatefulWidget {
  @override
  MapPageState createState() {
    return MapPageState();
  }
}

/// A class displays map state
class MapPageState extends State<MapPage> {
//  LocationData _startLocation;
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

    initPlatformState();
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

          _locationService
              .onLocationChanged()
              .listen((LocationData result) async {
            if (!_isMoveToCurrentGps) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map'),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        myLocationEnabled: true,
        initialCameraPosition: _initialCamera,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
