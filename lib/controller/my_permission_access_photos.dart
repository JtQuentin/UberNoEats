import 'package:permission_handler/permission_handler.dart';

class MyPermissionAccessPhotos {
  //methode
  init() async {
    PermissionStatus status = await Permission.photos.status;
    checkPermission(status);
  }

  Future<PermissionStatus> checkPermission(PermissionStatus permission) {
    switch (permission) {
      case PermissionStatus.permanentlyDenied:
        return Future.error(
            "L'utilisateur ne souhaite pas fournir ses informations");
      case PermissionStatus.denied:
        return Permission.photos.request();
      case PermissionStatus.provisional:
        return Permission.photos.request();
      case PermissionStatus.limited:
        return Permission.photos.request();
      case PermissionStatus.restricted:
        return Permission.photos.request();
      case PermissionStatus.granted:
        return Permission.photos.request();
    }
  }
}
