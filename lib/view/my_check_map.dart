import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:my_app/controller/my_permission_gps.dart';
import 'package:my_app/view/my_map.dart';

class MyCheckMap extends StatefulWidget {
  const MyCheckMap({super.key});

  @override
  State<MyCheckMap> createState() => _MyCheckMapState();
}

class _MyCheckMapState extends State<MyCheckMap> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Position>(
        future: MyPermissionGps().init(),
        builder: (context, future) {
          if (future.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else {
            if (!future.hasData) {
              return const Center(child: Text("Pas de chance"));
            } else {
              Position myPosition = future.data!;
              return MyMap(position: myPosition);
            }
          }
        });
  }
}
