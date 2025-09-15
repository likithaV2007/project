
import 'package:flutter/material.dart';

class Overflow extends StatelessWidget {
  const Overflow({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
               Text(
                'Overflow',
                style: TextStyle(
                  fontSize: 20,
                  overflow: TextOverflow.ellipsis,
                ),
               ),
               Container(
                height: 100,
                width: 100,
                color: Theme.of(context).colorScheme.secondaryContainer,
                child: OverflowBox(
                  maxHeight: 200,
                  maxWidth: 200,
                  child: FlutterLogo(size: 200,)),
               )
          ],
        ),
      ),
    );
  }
}