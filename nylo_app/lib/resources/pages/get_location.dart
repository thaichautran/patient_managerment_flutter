import 'package:flutter/material.dart';
import 'package:flutter_app/app/networking/api_service.dart';
import 'package:flutter_app/resources/pages/add_patient.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:geocoding/geocoding.dart';

class GetLocationPage extends StatefulWidget {
  @override
  _GetLocationPageState createState() => _GetLocationPageState();
}

class _GetLocationPageState extends NyState<GetLocationPage> {
  LatLng? _selectedCoordinate;
  ApiService _apiService = ApiService();
  Position? _position;
  late List<Placemark> placemarks = [];
  MapController? mapController;
  String text = "Đang chọn vị trí...";
  @override
  init() async {
    Position position = await _determinePosition();
    setState(() {
      _position = position;
    });
    mapController = MapController();
    mapController?.mapEventStream.listen((event) async {
      var eventType = event.runtimeType;
      if (eventType == MapEventMoveStart) {
        setState(() {
          text = "Đang chọn vị trí...";
        });
      } else if (eventType == MapEventMoveEnd) {
        placemarks = await placemarkFromCoordinates(
            _selectedCoordinate!.latitude, _selectedCoordinate!.longitude);
        setState(() {
          text = "${placemarks[0].name}, ${placemarks[0].street}";
        });
      }
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Get Location'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: _position != null
                    ? LatLng(_position!.latitude, _position!.longitude)
                    : LatLng(21.028511, 105.804817),
                initialZoom: 15,
                onPositionChanged: (position, hasGesture) async {
                  setState(() {
                    _selectedCoordinate = position.center!;
                  });
                },
              ),
              children: [
                Stack(
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.app',
                      maxZoom: 19,
                    ),
                    CurrentLocationLayer(),
                    MarkerLayer(
                      markers: [
                        Marker(
                          width: 80.0,
                          height: 80.0,
                          point: _selectedCoordinate != null
                              ? LatLng(_selectedCoordinate!.latitude,
                                  _selectedCoordinate!.longitude)
                              : LatLng(21.028511, 105.804817),
                          child: Center(
                            child: Icon(
                              Icons.location_on,
                              color: Colors.blue,
                              size: 40.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _selectedCoordinate != null ? text : "Đang tìm vị trí...",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddPatientForm(
                      address:
                          '${placemarks[0].name}, ${placemarks[0].street}'),
                ),
              );
            },
            child: Text('Chọn địa điểm này'),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
