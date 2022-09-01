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

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }
}

class MyLocation {
  double longitude;
  double latitude;

  MyLocation({required this.longitude, required this.latitude});
}
