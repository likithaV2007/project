import 'package:flutter/material.dart';



class OffstageExample extends StatefulWidget {
  const OffstageExample({super.key});

  @override
  State<OffstageExample> createState() => _OffstageExampleState();
}

class _OffstageExampleState extends State<OffstageExample> {
  final GlobalKey _key = GlobalKey();
  bool _offstage = true;

  Size _getFlutterLogoSize() {
    final RenderBox renderLogo = _key.currentContext!.findRenderObject()! as RenderBox;
    return renderLogo.size;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Offstage(
          offstage: _offstage,
          child: FlutterLogo(key: _key, size: 150.0),
           ),
        Text('Flutter logo is offstage: $_offstage',style: TextStyle(color: Colors.black),),
         SizedBox(height: 20,),
        ElevatedButton(
          child: const Text('Toggle Offstage Value'),
          onPressed: () {
            setState(() {
              _offstage = !_offstage;
            });
          },
        ),
        SizedBox(height: 20,),
        if (_offstage)
          ElevatedButton(
            child: const Text('Get Flutter Logo size'),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Flutter Logo size is ${_getFlutterLogoSize()}')),
              );
            },
          ),
      ],
    );
  }
}