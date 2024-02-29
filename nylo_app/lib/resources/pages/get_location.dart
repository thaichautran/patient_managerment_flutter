import 'package:flutter/material.dart';
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
  Position? _position;
  LatLng? _selectedCoordinate;
  late List<Placemark> placemarks = [];
  MapController? mapController;
  String text = "";

  @override
  init() async {
    mapController = MapController();
    Geolocator.getCurrentPosition().then((value) async {
      _position = value;

      print(_position);
      if (_position != null) {
        placemarks = await placemarkFromCoordinates(
            _position!.latitude, _position!.longitude);

        text = "${placemarks[0].street}";
        mapController?.move(
          LatLng(_position!.latitude, _position!.longitude),
          15,
        );
      }
    });

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
          text = "${placemarks[0].street}";
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
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
                onTap: (point, latlng) async {
                  setState(() {
                    _selectedCoordinate = latlng;
                  });
                  placemarks = await placemarkFromCoordinates(
                      _selectedCoordinate!.latitude,
                      _selectedCoordinate!.longitude);
                  setState(() {
                    text = "${placemarks[0].street}";
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
                _selectedCoordinate != null ? text : "",
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
                  builder: (context) =>
                      AddPatientForm(address: '${placemarks[0].street}'),
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
