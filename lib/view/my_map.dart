import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_app/controller/my_firestore_helper.dart';
import 'package:my_app/globale.dart';
import 'package:my_app/model/my_user.dart';

class MyMap extends StatefulWidget {
  Position position;
  MyMap({required this.position, super.key});

  @override
  State<MyMap> createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  late CameraPosition myPositionMaps;
  Completer<GoogleMapController> control = Completer();
  Set<Marker> allMarkers = Set();
  @override
  void initState() {
    myPositionMaps = CameraPosition(
        target: LatLng(widget.position.latitude, widget.position.longitude),
        zoom: 14);
    Map<String, dynamic> data = {
      "GPS": GeoPoint(widget.position.latitude, widget.position.longitude)
    };
    MyFirestoreHelper().updateUser(moi.uid, data);
    MyFirestoreHelper().cloudUsers.snapshots().listen((event) {
      setState(() {});
      List documents = event.docs;
      for (int i in documents) {
        MyUser lesautres = MyUser.dataBase(documents[i]);
        if (moi.uid != lesautres.uid) {
          if (GeoPoint(0, 0) != lesautres.gps) {
            Marker marker = Marker(
                markerId: MarkerId(lesautres.uid),
                position:
                    LatLng(lesautres.gps!.latitude, lesautres.gps!.longitude),
                infoWindow: InfoWindow(title: lesautres.fullName));
            allMarkers.add(marker);
          }
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      markers: allMarkers,
      initialCameraPosition: myPositionMaps,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      onMapCreated: (controller) async {
        String newStyle = await DefaultAssetBundle.of(context)
            .loadString("lib/styleMaps.json");
        controller.setMapStyle(newStyle);
        control.complete(controller);
      },
    );
  }
}
