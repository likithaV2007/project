import 'package:flutter/material.dart';

class Gridview extends StatelessWidget {
  const Gridview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.count(
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 2,
        children: [
          Container(
            color: Colors.red,
            child: Center(child: Text("1",style: TextStyle(fontSize: 15),)),
          ),
          Container(
            color: Colors.blue,
            child: Center(child: Text("2",style: TextStyle(fontSize: 15),)),
          ),
          Container(
            color: Colors.green,
            child: Center(child: Text("3",style: TextStyle(fontSize: 15),)),
          ),
          Container(
            color: Colors.yellow,
            child: Center(child: Text("4",style: TextStyle(fontSize: 15),)),
          ),
          Container(
            color: Colors.orange,
            child: Center(child: Text("5",style: TextStyle(fontSize: 15),)),
          ),
          Container(
            color: Colors.purple,
            child: Center(child: Text("6",style: TextStyle(fontSize: 15),)),
          ),
          Container(
            color: Colors.pink,
            child: Center(child: Text("7",style: TextStyle(fontSize: 15),)),
          ),
          Container(
            color: Colors.teal,
            child: Center(child: Text("8",style: TextStyle(fontSize: 15),)),
          ),
          Container(
            color: Colors.brown,
            child: Center(child: Text("9",style: TextStyle(fontSize: 15),)),
          ),
          Container(
            color: Colors.cyan,
            child: Center(child: Text("10",style: TextStyle(fontSize: 15),)),
          ),
          Container(
            color: Colors.indigo,
            child: Center(child: Text("11",style: TextStyle(fontSize: 15),)),
          ),
          Container(
            color: Colors.lime,
            child: Center(child: Text("12",style: TextStyle(fontSize: 15),)),
          ),
        ] 
      ),
    );
  }
}