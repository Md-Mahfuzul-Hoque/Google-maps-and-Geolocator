import 'dart:ui';
import 'package:geolocator/geolocator.dart';
class LocationServices{

  Future<void> handleLocationPermission({required VoidCallback onSuccess})async{
    final locationPermission = await Geolocator.checkPermission();
    //check if user permission is given
    if(isPermissionEnabled(locationPermission)){
      //Check if user gps service enabled
      final bool isGpsEnabled = await Geolocator.isLocationServiceEnabled();
      if(isGpsEnabled){
        onSuccess();
      }else{
        //If not, then open location settings
        await Geolocator.openLocationSettings();
      }
    }else{
      //if not then ask for it
      final LocationPermission permission = await Geolocator.requestPermission();
      if(isPermissionEnabled(permission)){
        handleLocationPermission(onSuccess: onSuccess);
      }
    }
  }

  bool isPermissionEnabled(LocationPermission locationPermission){
    return locationPermission == LocationPermission.whileInUse || locationPermission == LocationPermission.always;
  }
}