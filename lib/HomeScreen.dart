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
      appBar: AppBar(title: Text('Google Map'),),
      body: GoogleMap(
        mapType: MapType.normal,
        trafficEnabled: true,
        zoomGesturesEnabled: true,
        zoomControlsEnabled: true,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        initialCameraPosition: CameraPosition(
            target: LatLng(22.55243006418666, 91.86319546613036),
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
              markerId: MarkerId('shop'),
              position: LatLng(22.55243006418666, 91.86319546613036),
              onTap: (){
                print('Tapped On my shop');
              },
              visible: true,
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen,
              ),
              infoWindow: InfoWindow(
                  title: 'Bhai Bhai Grocery Shop',
                  onTap: (){}
              )
          ),
          Marker(
              markerId: MarkerId('school'),
              position: LatLng(22.555195083449732, 91.8631874397397),
              onTap: (){
                print('FNW HIGH SCHOOL');
              },
              visible: true,
              infoWindow: InfoWindow(
                  title: 'FNW HIGH SCHOOL',
                  onTap: (){}
              )
          ),
          Marker(
              markerId: MarkerId('home'),
              position: LatLng(22.55334502577644, 91.86225604265928),
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
                LatLng(22.55334502577644, 91.86225604265928),
                LatLng(22.55243006418666, 91.86319546613036),
                LatLng(22.555195083449732, 91.8631874397397),

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
              center: LatLng(22.55243006418666, 91.86319546613036),
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
              LatLng(22.551783526830153, 91.8645104393363),
              LatLng(22.549616348800903, 91.8645453080535),
              LatLng(22.54958352658308, 91.86607249081135),
              LatLng(22.551770212366957, 91.86604533344507)
            ],
            fillColor: Colors.green.withAlpha(30),
            strokeColor: Colors.green,
            strokeWidth: 4,

          )
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        _googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(22.55243006418666, 91.86319546613036),
              zoom: 17,
            ),
          ),
        );
      },child: Icon(Icons.my_location),),
    );
  }

  Future<void> _getCurrentLocation()async{
    _locationServices.handleLocationPermission(onSuccess: ()async{
      //Then get the location
      Position position = await Geolocator.getCurrentPosition(
          locationSettings: LocationSettings()
      );
      // _currentLocation=position;
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