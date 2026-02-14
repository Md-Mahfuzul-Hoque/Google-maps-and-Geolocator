import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'location_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GoogleMapController? _controller;
  final LocationService _locationService = LocationService();

  LatLng _currentPosition = const LatLng(23.823623, 90.4395575);
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  final List<LatLng> _polylineCoordinates = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initTracking();
  }

  void _initTracking() async {
    bool hasPermission = await _locationService.checkPermissions();
    if (hasPermission) {
      _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
        _updateLocation();
      });
    }
  }

  void _updateLocation() async {
    LatLng? newLocation = await _locationService.getCurrentLocation();
    if (newLocation != null) {
      setState(() {
        _currentPosition = newLocation;
        _polylineCoordinates.add(newLocation);
        _markers.clear();
        _markers.add(
          Marker(
            markerId: const MarkerId("current_loc"),
            position: newLocation,
            infoWindow: InfoWindow(
              title: "My Current Location",
              snippet: "${newLocation.latitude}, ${newLocation.longitude}",
            ),
          ),
        );

        _polylines.add(
          Polyline(
            polylineId: const PolylineId("track_path"),
            points: _polylineCoordinates,
            color: Colors.blue,
            width: 5,
          ),
        );
      });

      _controller?.animateCamera(CameraUpdate.newLatLng(newLocation));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Real-Time Location Tracker",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: GoogleMap(
        trafficEnabled: true,
        zoomControlsEnabled: true,
        zoomGesturesEnabled: true,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        initialCameraPosition: CameraPosition(
          target: _currentPosition,
          zoom: 16,
        ),
        markers: _markers,
        polylines: _polylines,
        onMapCreated: (controller) => _controller = controller,
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}