import 'package:flutter/material.dart';

class Aspectratio extends StatelessWidget {
  const Aspectratio({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.blueAccent,
          height: 100,
          alignment:Alignment.center,
          width: double.infinity,
          child: AspectRatio(
            aspectRatio: 16/9,
          child: Container(
            color: Colors.pinkAccent,
          ),),
        ),
      ),
    );
  }
}