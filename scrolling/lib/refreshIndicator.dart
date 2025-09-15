import 'package:flutter/material.dart';

class Refreshindicator extends StatelessWidget {
  const Refreshindicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 2));
        },
        child:Center(
          child: SingleChildScrollView(
             physics: const AlwaysScrollableScrollPhysics(),
            child: Container(
              height: 100,
              width: 300,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Colors.blue,
                    Colors.red,
                  ],
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text("REFRESH INDICATOR",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 25),),
            ),
          ),
        )
      ),
    );
  }
}