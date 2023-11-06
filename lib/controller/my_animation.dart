import 'dart:async';

import 'package:flutter/material.dart';

class MyAnimation extends StatefulWidget {
  Widget child;
  int duree;
  MyAnimation({required this.child, required this.duree, super.key});

  @override
  State<MyAnimation> createState() => _MyAnimationState();
}

class _MyAnimationState extends State<MyAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> animationPosition;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    CurvedAnimation curves =
        CurvedAnimation(parent: _controller, curve: Curves.linear);
    animationPosition = Tween<Offset>(
      begin: Offset(0, 5),
      end: Offset.zero,
    ).animate(curves);
    Timer(Duration(seconds: widget.duree), () {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: SlideTransition(position: animationPosition, child: widget.child),
    );
  }
}
