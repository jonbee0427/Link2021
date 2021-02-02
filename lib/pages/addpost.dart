import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'post_buytogether.dart';
import 'post_hobbytogether.dart';
import 'post_studytogether.dart';
import '../shared/constants.dart';
import 'package:link_ver1/pages/home.dart';
import 'package:link_ver1/pages/home_page.dart';

class Post extends StatefulWidget {
  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  final _formKey = GlobalKey<FormState>();
  CollectionReference groups = FirebaseFirestore.instance.collection('groups');
  String title;
  String body, datetime;
  int tag; //for category (1. 공동구매 2. 스터디 3. 취미생활)
  int max_person;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("카테고리"),
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
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text("카테고리 선택",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 45.0,
                          fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Flexible(
                        child: SizedBox(
                          width: double.infinity,
                          height: 150.0,
                          child: RaisedButton(

                              elevation: 0.0,
                              color: Colors.blue[200],
                              // Color.fromARGB(300, 247, 162, 144),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: Text('공동 구매',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 30.0)),
                              onPressed: () {
                                print('buy');
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => PostBuyTogether()));
                              }),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Flexible(
                        child: SizedBox(
                          width: double.infinity,
                          height: 150.0,
                          child: RaisedButton(
                              elevation: 0.0,
                              color: Colors.blue[200],
                              // Color.fromARGB(300, 247, 162, 144),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0)),
                              child: Text('스터디',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 30.0)),
                              onPressed: () {
                                print('study');
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => PostStudyTogether()));
                              }),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Flexible(
                        child: SizedBox(
                          width: double.infinity,
                          height: 150.0,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Color.fromARGB(250,247 , 162, 144)),
                              borderRadius: BorderRadius.circular(30.0)
                            ),
                            child: RaisedButton(
                                elevation: 0.0,
                                color:  Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0)),
                                child: Text('취미 생활',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 30.0)),
                                onPressed: () {
                                  print('Hobby');
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => PostHobbyTogether()));
                                }),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      /*
                      Flexible(
                        child: SizedBox(
                          width: double.infinity,
                          height: 50.0,
                          child: RaisedButton(
                              elevation: 0.0,
                              color: Colors.pink[300],
                              // Color.fromARGB(300, 247, 162, 144),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0)),
                              child: Text('작성 완료',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16.0)),
                              onPressed: () {
                                DateTime create_time = new DateTime.now();
                                if (_formKey.currentState.validate()) {
                                  writing
                                      .add(
                                        {
                                          'title': title,
                                          'body': body,
                                          'time_limit': datetime,
                                          'max_person': max_person,
                                          'create_time': create_time
                                        },
                                      )
                                      .then((value) => print('writing added'))
                                      .catchError(
                                          (value) => print('failed to add'));
                                }
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomePage()));
                              }),
                        ),
                      ),
                      */
                      Flexible(
                        child: SizedBox(
                          width: double.infinity,
                          height: 150.0,
                          child: RaisedButton(
                              elevation: 0.0,
                              color: Colors.blue[200],
                              // Color.fromARGB(300, 247, 162, 144),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0)),
                              child: Text('준비중',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 30.0)),
                              onPressed: () {
                                print('준비중');
                                Toast.show('준비중입니다.', context,
                                    duration: Toast.LENGTH_LONG,
                                    gravity: Toast.BOTTOM);
                              }),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                    ],
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
