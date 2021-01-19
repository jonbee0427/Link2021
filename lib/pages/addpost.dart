import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'post_buytogether.dart';
import 'post_hobbytogether.dart';
import 'post_studytogether.dart';
import '../shared/constants.dart';

class Post extends StatefulWidget {
  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("LINK"),
        centerTitle: true,
        //backgroundColor: const Color.fromARGB(250, 247, 162, 144),
        elevation: 10.0,
        // actions: <Widget>[
        //   IconButton(
        //     icon: Icon(
        //       Icons.search,
        //       color: Colors.white,
        //     ),
        //     onPressed: () {
        //       showSearch(context: context, delegate: Search());
        //     },
        //   )
        // ],
      ),
      body: Container(
        color: Color.fromARGB(150, 247, 162, 144),
        child: ListView(
          children: <Widget>[
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text("H-links",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 45.0,
                          fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 100.0,
                    child: RaisedButton(
                        elevation: 0.0,
                        color: Colors.blue[200],
                        // Color.fromARGB(300, 247, 162, 144),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        child: Text('공동 구매',
                            style:
                                TextStyle(color: Colors.white, fontSize: 30.0)),
                        onPressed: () {
                          print('buy');
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => PostBuyTogether()));
                        }),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 100.0,
                    child: RaisedButton(
                        elevation: 0.0,
                        color: Colors.blue[200],
                        // Color.fromARGB(300, 247, 162, 144),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        child: Text('스터디',
                            style:
                                TextStyle(color: Colors.white, fontSize: 30.0)),
                        onPressed: () {
                          print('study');
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => PostStudyTogether()));
                        }),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 100.0,
                    child: RaisedButton(
                        elevation: 0.0,
                        color: Colors.blue[200],
                        // Color.fromARGB(300, 247, 162, 144),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        child: Text('취미 생활',
                            style:
                                TextStyle(color: Colors.white, fontSize: 30.0)),
                        onPressed: () {
                          print('Hobby');
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => PostHobbyTogether()));
                        }),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 100.0,
                    child: RaisedButton(
                        elevation: 0.0,
                        color: Colors.blue[200],
                        // Color.fromARGB(300, 247, 162, 144),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        child: Text('준비중',
                            style:
                                TextStyle(color: Colors.white, fontSize: 30.0)),
                        onPressed: () {
                          print('준비중');
                          Toast.show('준비중입니다.', context,
                              duration: Toast.LENGTH_LONG,
                              gravity: Toast.BOTTOM);
                        }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
