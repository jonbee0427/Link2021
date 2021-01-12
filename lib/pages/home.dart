import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: TabBar(
            indicatorColor: Color.fromARGB(250, 247, 162, 144),
            labelColor: Color.fromARGB(250, 247, 162, 144),
            tabs: [
              Tab(icon: Icon(Icons.local_grocery_store_outlined)),
              Tab(icon: Icon(Icons.school_outlined)),
              Tab(icon: Icon(Icons.directions_bike_outlined)),
            ],
          ),
          body: TabBarView(
            children: [
              Container(
                alignment: Alignment.center,
                child: Text(
                  "공동구매",
                  style: TextStyle(fontSize: 30, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: Text(
                  "스터디",
                  style: TextStyle(fontSize: 30, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: Text(
                  "운동",
                  style: TextStyle(fontSize: 30, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
