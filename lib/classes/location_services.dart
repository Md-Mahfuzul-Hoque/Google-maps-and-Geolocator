import 'dart:ui';
import 'package:geolocator/geolocator.dart';
class LocationServices{

  Future<void> handleLocationPermission({required VoidCallback onSuccess})async{
    final locationPermission = await Geolocator.checkPermission();
    if(isPermissionEnabled(locationPermission)){
      final bool isGpsEnabled = await Geolocator.isLocationServiceEnabled();
      if(isGpsEnabled){
        onSuccess();
      }else{
        await Geolocator.openLocationSettings();
      }
    }else{
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