import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fimber/flutter_fimber.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:travelspots/common/base_state.dart';
import 'package:travelspots/repos/models/data_models/app_database_entity.dart';
import 'package:travelspots/screens/map/main_bloc.dart';
import 'package:travelspots/screens/map/map_bloc.dart';
import 'package:travelspots/screens/map/spot_detail_page.dart';
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
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  MapBloc _mapBloc;
  MainBloc _mainBloc;
  SpotEntity _selectedSpotEntity;
  StreamSubscription<LocationData> _locationSubscription;
  Location _locationService = new Location();
  bool _permission = false;
  String _error;
  bool _isMoveToCurrentGps = false;
  bool _isMarkerTapped = false;
  MarkerId _selectedMarkerId;
  int _startTime;
  int _endTime;
  double _appbarHeight;
  PanelController _panelController = PanelController();
  final GlobalKey<SpotDetailPageState> _spotDetailKey =
      GlobalKey<SpotDetailPageState>();

  Completer<GoogleMapController> _controller = Completer();
  static final double defaultZoomLevel = 16;
  CameraPosition _initialCamera = CameraPosition(
    target: LatLng(10.7720894, 106.698282),
    zoom: defaultZoomLevel,
  );

  CameraPosition _currentCameraPosition;

  @override
  void initState() {
    super.initState();
    _mapBloc = providerOfBloc();
    _mainBloc = providerOfBloc();
    _panelController = PanelController();
    _startTime = DateTime.now().millisecond;
    Fimber.d('MapView initState with @startTime=$_startTime');
    initPlatformState();
  }

  void _onMarkerTapped(SpotEntity spotEntity, MarkerId markerId) {
    _selectedSpotEntity = spotEntity;
    final Marker tappedMarker = _markers[markerId];
    if (tappedMarker != null) {
      if (_markers.containsKey(_selectedMarkerId)) {
        final Marker resetOld = _markers[_selectedMarkerId]
            .copyWith(iconParam: BitmapDescriptor.defaultMarker);
        _markers[_selectedMarkerId] = resetOld;
      }
      _selectedMarkerId = markerId;
      final Marker newMarker = tappedMarker.copyWith(
        iconParam: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueGreen,
        ),
//        iconParam: _markerIcon,
      );
      _markers[markerId] = newMarker;
    }
    _isMarkerTapped = true;
    _mapBloc.notifyMarkerTapped();
  }

  void _onMarkerDragEnd(MarkerId markerId, LatLng newPosition) async {
    final Marker tappedMarker = _markers[markerId];
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
                ),
              ),
            );
          });
    }
  }

  void _addMarker(int index, SpotEntity spotEntity) {
    /*Fimber.d(
        'MapPage _addMarker @index=$index, @title=${spotEntity.name}');*/
    final String markerIdVal = 'marker_id_${spotEntity.id}';
    final MarkerId markerId = MarkerId(markerIdVal);
    BitmapDescriptor bitmapDescriptor = BitmapDescriptor.defaultMarker;
    if (markerId == _selectedMarkerId) {
      bitmapDescriptor = BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueGreen,
      );
    }
    final Marker marker = Marker(
        markerId: markerId,
        position: LatLng(spotEntity.lat, spotEntity.long),
//      infoWindow: InfoWindow(title: title, snippet: description),
        onTap: () {
          _onMarkerTapped(spotEntity, markerId);
        },
//      onDragEnd: (LatLng position) {
//        _onMarkerDragEnd(markerId, position);
//      },
        icon: bitmapDescriptor);
    _markers[markerId] = marker;
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
          _endTime = DateTime.now().millisecond;
          Fimber.d(
              'MapView get location with @endTime=$_endTime and @totalTime=${_endTime - _startTime}');
          _currentCameraPosition = CameraPosition(
            target: LatLng(location.latitude, location.longitude),
            zoom: defaultZoomLevel,
          );
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
        _error = e.message;
      } else if (e.code == 'SERVICE_STATUS_ERROR') {
        _error = e.message;
      }
      location = null;
    }
  }

  void _onGetNearbyPoi() async {
    if (!_isMarkerTapped) {
      var zoomLevel = _currentCameraPosition?.zoom;
      int popularity = AppUtils.convertMapZoomLevelToPopularity(zoomLevel);
      Fimber.d('MapView: get nearby POI: zoomLevel=$zoomLevel '
          '=> popularity: $popularity');
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
        popularity: popularity,
      );
      if (_listSpotEntity != null && _listSpotEntity.length > 0) {
        _markers.clear();
        for (var i = 0; i < _listSpotEntity.length; i++) {
          SpotEntity spotEntity = _listSpotEntity[i];
          _addMarker(i + 1, spotEntity);
        }
        _mapBloc.notifyMarkerAdded();
//        _isMoveToCurrentGps = false;
      }
    } else {
      _isMarkerTapped = false;
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

  void _onPanelDoubleTap() {
    /* if (!_isPanelOpened)
      _panelController.open();
    else
      _panelController.close();*/
  }

  ///Build bottom sheet
  Widget _buildBottomSheet() {
    return SlidingUpPanel(
      controller: _panelController,
      panel: InkWell(
        child: Container(
          child: SpotDetailPage(
            key: _spotDetailKey,
            spotDataModel: _selectedSpotEntity,
          ),
          padding: EdgeInsets.only(left: 8.0, right: 8.0),
        ),
        onTap: () {
          if (_panelController.isPanelClosed()) {
            print('Open panel');
            _panelController.open();
            _spotDetailKey.currentState.onPanelOpened();
          }
        },
      ),
      maxHeight: MediaQuery.of(context).size.height,
      minHeight: 140,
      onPanelOpened: () {
        print('onPanelOpened');
        _spotDetailKey.currentState.onPanelOpened();
      },
      onPanelClosed: () {
        print('onPanelClosed');
        _spotDetailKey.currentState.onPanelClosed();
      },
    );
  }

  void _onMapTap(LatLng latLng) {
    Fimber.d('MapView:onTap');
    _mapBloc.notifyMarkerUnTapped();
  }

  Widget _buildGoogleMap() {
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
      onTap: (latlng) {
        _onMapTap(latlng);
      },
      onCameraIdle: () {
        _onGetNearbyPoi();
      },
      onCameraMove: (CameraPosition position) {
        _currentCameraPosition = position;
      },
      markers: Set<Marker>.of(_markers.values),
    );
  }

  @override
  Widget buildChild(BuildContext context) {
    Fimber.d('MapView:buildChild');
    AppBar appbar = AppBar(
      title: Text('Map'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: _onGetNearbyPoi,
        )
      ],
    );
    _appbarHeight = appbar.preferredSize.height + 16;
    return Scaffold(
      appBar: appbar,
      body: Stack(
        children: <Widget>[
          PropertyChangeConsumer<MapBloc>(
            properties: [MapProperties.markerTapped, MapProperties.markerAdded],
            builder: (context, bloc, property) {
              Fimber.d('MapView display googlemap @property=$property');

              return _buildGoogleMap();
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
