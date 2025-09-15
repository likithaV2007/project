import 'dart:math' as math;
import 'package:flutter/material.dart';

class TransformExample extends StatelessWidget {
  const TransformExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transform Examples')),
      body:  SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Container(
            child: Column(
              children: [
                _RotateExample(),
                SizedBox(height: 32),
                _ScaleExample(),
                SizedBox(height: 32),
                _SkewExample(),
                SizedBox(height: 32),
                _TranslateExample(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RotateExample extends StatelessWidget {
  const _RotateExample();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Text('Rotation', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Transform.rotate(
            angle: math.pi / 4,
            child: Container(
              width: 100,
              height: 100,
              color: Colors.blue,
              child: const Center(child: Text('45°', style: TextStyle(color: Colors.white))),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScaleExample extends StatelessWidget {
  const _ScaleExample();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Text('Scale', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Transform.scale(
            scale: 1.5,
            child: Container(
              width: 80,
              height: 80,
              color: Colors.green,
              child: const Center(child: Text('1.5x', style: TextStyle(color: Colors.white))),
            ),
          ),
        ],
      ),
    );
  }
}

class _SkewExample extends StatelessWidget {
  const _SkewExample();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Text('Skew', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Transform(
            transform: Matrix4.skewX(0.3),
            child: Container(
              width: 100,
              height: 60,
              color: Colors.orange,
              child: const Center(child: Text('Skewed', style: TextStyle(color: Colors.white))),
            ),
          ),
        ],
      ),
    );
  }
}

class _TranslateExample extends StatelessWidget {
  const _TranslateExample();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Text('Translate', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                color: Colors.grey.shade300,
                child: const Center(child: Text('Original')),
              ),
              Transform.translate(
                offset: const Offset(30, 30),
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.red.withOpacity(0.8),
                  child: const Center(child: Text('Moved', style: TextStyle(color: Colors.white))),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
