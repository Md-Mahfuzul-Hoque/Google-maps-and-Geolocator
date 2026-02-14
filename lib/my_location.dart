import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'classes/location_services.dart';

class MyLocation extends StatefulWidget {
  const MyLocation({super.key});

  @override
  State<MyLocation> createState() => _MyLocationState();
}

class _MyLocationState extends State<MyLocation> {
  Position? _currentLocation;
  StreamSubscription? _liveLocation;
  final LocationServices _locationServices = LocationServices();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Locaton'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('My Current Locationn $_currentLocation',textAlign: TextAlign.center,),
            FilledButton(onPressed: _getCurrentLocation, child: Text('Get My Location')),
            FilledButton(onPressed: _listenLivePosition, child: Text('Get My Live Location')),
          ],
        ),
      ),
    );
  }
  Future<void> _getCurrentLocation()async{
    _locationServices.handleLocationPermission(onSuccess: ()async{

      Position position = await Geolocator.getCurrentPosition(
          locationSettings: LocationSettings()
      );
      _currentLocation=position;
      setState(() {

      });
      print(position);
    });
  }

  Future<void> _listenLivePosition()async{
    _locationServices.handleLocationPermission(onSuccess: (){
      _liveLocation =  Geolocator.getPositionStream(
          locationSettings: LocationSettings(
            accuracy: LocationAccuracy.best,
            distanceFilter: 2,
            timeLimit: Duration(seconds: 10),
          )

      ).listen((position){
        print(position);
        _currentLocation = position;
        setState(() {

        });
      });
    });
  }

  @override
  void dispose(){
    _liveLocation?.cancel();
    super.dispose();
  }
}