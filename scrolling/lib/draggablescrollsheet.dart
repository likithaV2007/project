import 'package:flutter/material.dart';

class Draggablescrollsheet extends StatelessWidget {
  Draggablescrollsheet({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purpleAccent,
      body: Stack(
        fit: StackFit.expand,
        children: [

          Positioned(
            top:70,
            left:40,
            child: Text("DraggableScrollSheet",style: TextStyle(color: Colors.white,fontSize: 35,fontWeight: FontWeight.bold),)),
          DraggableScrollableSheet(
            initialChildSize: 0.6,
            minChildSize: 0.6,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: 30,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(height: 10,
                        width: 10,
                        color: Colors.pinkAccent,
                        child: Text(""),),
                      ),
                      title: Text("Item ${index+1}"),
                      
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}