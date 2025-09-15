import 'package:flutter/material.dart';

class MyCarouselPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 200, maxWidth: 250),

              child: CarouselView(
                itemExtent: 300,

                scrollDirection: Axis.vertical,
                children: <Widget>[
                  Container(
                    color: Color.fromARGB(255, 243, 211, 236),
                    child: Center(child: Text('Item 1')),
                  ),
                  Container(
                    color: Color.fromARGB(255, 247, 166, 222),
                    child: Center(child: Text('Item 2')),
                  ),
                  Container(
                    color: Color.fromARGB(255, 228, 107, 181),
                    child: Center(child: Text('Item 3')),
                  ),
                  Container(
                    color: Color.fromARGB(255, 211, 111, 224),
                    child: Center(child: Text('Item 4')),
                  ),
                  Container(
                    color: Color.fromARGB(255, 165, 40, 159),
                    child: Center(child: Text('Item 5')),
                  ),
                  Container(
                    color: Color.fromARGB(255, 168, 38, 140),
                    child: Center(child: Text('Item 6')),
                  ),
                  Container(
                    color: Color.fromARGB(255, 177, 15, 150),
                    child: Center(child: Text('Item 7')),
                  ),
                  Container(
                    color: Color.fromARGB(255, 233, 28, 165),
                    child: Center(child: Text('Item 8')),
                  ),
                  Container(
                    color: Color.fromARGB(255, 238, 3, 187),
                    child: Center(child: Text('Item 9')),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 200, maxWidth: 600),

              child: CarouselView(
                itemExtent: 300,
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  Container(
                    color: Color.fromARGB(255, 243, 211, 236),
                    child: Center(child: Text('Item 1')),
                  ),
                  Container(
                    color: Color.fromARGB(255, 247, 166, 222),
                    child: Center(child: Text('Item 2')),
                  ),
                  Container(
                    color: Color.fromARGB(255, 228, 107, 181),
                    child: Center(child: Text('Item 3')),
                  ),
                  Container(
                    color: Color.fromARGB(255, 211, 111, 224),
                    child: Center(child: Text('Item 4')),
                  ),
                  Container(
                    color: Color.fromARGB(255, 165, 40, 159),
                    child: Center(child: Text('Item 5')),
                  ),
                  Container(
                    color: Color.fromARGB(255, 168, 38, 140),
                    child: Center(child: Text('Item 6')),
                  ),
                  Container(
                    color: Color.fromARGB(255, 177, 15, 150),
                    child: Center(child: Text('Item 7')),
                  ),
                  Container(
                    color: Color.fromARGB(255, 233, 28, 165),
                    child: Center(child: Text('Item 8')),
                  ),
                  Container(
                    color: Color.fromARGB(255, 238, 3, 187),
                    child: Center(child: Text('Item 9')),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
