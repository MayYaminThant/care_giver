import 'dart:math';

import 'package:location/location.dart';

class LocationUtils {
  static final fakeLocation = MyLocation(longitude: 0, latitude: 0);

  static Future<MyLocation> currentLocation() async {
    try {
      final location = Location();

      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          return fakeLocation;
        }
      }

      PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          return fakeLocation;
        }
      }

      LocationData locationData = await location.getLocation();

      return MyLocation(
        longitude: locationData.longitude ?? 0,
        latitude: locationData.latitude ?? 0,
      );
    } catch (e) {
      return fakeLocation;
    }
  }
}

class MyLocation {
  double longitude;
  double latitude;

  MyLocation({required this.longitude, required this.latitude});
}
