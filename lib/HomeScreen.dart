import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'classes/location_services.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  late final GoogleMapController _googleMapController;
  Position? _currentLocation;
  StreamSubscription? _liveLocation;
  final LocationServices _locationServices = LocationServices();
  @override
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: AppBar(
        title: Center(
          child: Text('Maps Tracking',
                style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold
                ),
                ),
        ),
        backgroundColor: Colors.teal,
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        trafficEnabled: true,
        zoomGesturesEnabled: true,
        zoomControlsEnabled: true,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        initialCameraPosition: CameraPosition(
            target: LatLng(23.81541436922018, 90.44143283987697),
            zoom: 17
        ),
        onMapCreated: (GoogleMapController controller){
          _googleMapController=controller;
        },
        onTap: (LatLng latLng){
          print(latLng);
        },
        onLongPress: (LatLng latLng){
          print('Long Press on $latLng');
        },
        markers: <Marker>{
          Marker(
              markerId: MarkerId('Sunnydale School'),
              position: LatLng(23.824670358139844, 90.4369459803539),
              onTap: (){
                print('Tapped On Sunnydale School');
              },
              visible: true,
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen,
              ),
              infoWindow: InfoWindow(
                  title: 'Sunnydale School',
                  onTap: (){}
              )
          ),
          Marker(
              markerId: MarkerId('Sunflower Restaurant'),
              position: LatLng(23.825735739862246, 90.43594858035395),
              onTap: (){
                print('Tapped On Sunflower Restaurant');
              },
              visible: true,
              infoWindow: InfoWindow(
                  title: 'Sunflower Restaurant',
                  onTap: (){}
              )
          ),
          Marker(
              markerId: MarkerId('home'),
              position: LatLng(23.82368929496159, 90.43956577777863),
              onTap: (){
                print('Home');
              },
              visible: true,
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
              infoWindow: InfoWindow(
                  title: 'Home',
                  onTap: (){}
              )
          ),
          Marker(
              markerId: MarkerId('Current Position'),
              position: LatLng(_currentLocation!.latitude, _currentLocation!.longitude),
              onTap: (){
                print('Current Location');
              },
              visible: true,
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
              infoWindow: InfoWindow(
                  title: 'Current Location',
                  onTap: (){}
              )
          ),
        },
        polylines: <Polyline>{
          Polyline(
              polylineId: PolylineId('home-to-shop-to-school'),
              points: [
                LatLng(23.82368929496159, 90.43956577777863),
                LatLng(23.81541436922018, 90.44143283987697),
                LatLng(23.825735739862246, 90.43594858035395),

              ],
              color: Colors.red,
              width: 4,
              startCap: Cap.roundCap,
              endCap: Cap.roundCap,
              jointType: JointType.round,
              onTap: (){}
          )
        },
        circles: <Circle>{
          Circle(
              circleId: CircleId('Red-zone'),
              center: LatLng(23.815424184506753, 90.44138992453325),
              radius: 50,
              strokeWidth: 4,
              strokeColor: Colors.red,
              fillColor: Colors.red.withAlpha(40),
              consumeTapEvents: true,
              onTap: (){
                print('on tapped shop-zone');
              }
          )
        },
        polygons: <Polygon>{
          Polygon(
            polygonId: PolygonId('rendom-polygon'),
            points: [
              LatLng(23.824670358139844, 90.4369459803539),
              LatLng(23.82577499788178, 90.43598076686173),
              LatLng(23.815502706772573, 90.44144356871291),
              LatLng(23.826918295978384, 90.43313885151801)
            ],
            fillColor: Colors.green.withAlpha(30),
            strokeColor: Colors.green,
            strokeWidth: 4,

          )
        },
      ),
    );
  }

  Future<void> _getCurrentLocation()async{
    _locationServices.handleLocationPermission(onSuccess: ()async{

      Position position = await Geolocator.getCurrentPosition(
          locationSettings: LocationSettings()
      );

      setState(() {
        _currentLocation = position;

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
        setState(() {
          print(position);
          _currentLocation = position;

        });
      });
    });
  }
  @override
  void initState() {
    _getCurrentLocation();
    _listenLivePosition();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose(){
    _googleMapController.dispose();
    super.dispose();
  }
}