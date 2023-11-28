import 'package:flutter/material.dart';

class MyCustomPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.66);
    path.quadraticBezierTo(size.width * 0.33, size.height * 0.5,
        size.width * 0.66, size.height * 0.55);
    path.lineTo(size.width, size.height * 0.5);
    path.lineTo(size.width, size.height * 0);
    path.close();
    return path;
  }


  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // Add logic to determine if reclip is necessary based on your app's requirement
    // For example, return true if you always want to reclip, or add custom logic
    return true;
  }

}
