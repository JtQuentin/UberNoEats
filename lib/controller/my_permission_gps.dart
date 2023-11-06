import 'package:geolocator/geolocator.dart';

class MyPermissionGps {
  Future<Position> init() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (serviceEnabled) {
      LocationPermission permission = await Geolocator.checkPermission();
      return checkPermission(permission);
    } else {
      return Future.error("L'utilisateur n'a pas activé son gps");
    }
  }

  Future<Position> checkPermission(LocationPermission permission) {
    switch (permission) {
      case LocationPermission.deniedForever:
        return Future.error(
            "L'utilisateur ne souhaite pas qu'on accède à sa position");
      case LocationPermission.denied:
        return Geolocator.requestPermission()
            .then((value) => checkPermission(value));
      case LocationPermission.unableToDetermine:
        return Future.error("Imposible de vous positionner");
      case LocationPermission.whileInUse:
        return Geolocator.getCurrentPosition();
      case LocationPermission.always:
        return Geolocator.getCurrentPosition();
    }
  }
}
