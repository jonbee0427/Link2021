import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:link_ver1/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:link_ver1/pages/home_page.dart';
import 'package:link_ver1/pages/search.dart';
import 'package:link_ver1/widgets/boardTile.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String title, body, time_limit, create_time;
  int max_person;
  Stream _boards;
  Color priority = Color.fromARGB(250, 247, 162, 144);

  // initState
  @override
  void initState() {
    super.initState();
    _boards = FirebaseFirestore.instance.collection('writing').snapshots();
  }

  Widget getBoard() {
    return StreamBuilder(
        stream: _boards,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
              itemCount: snapshot.data.size,
              itemBuilder: (context, index) {
                //itemBuilder : 게시글 하나하나,  index : 순서
                int reqIndex = snapshot.data.docs.length - index - 1;
                //print(snapshot.data.docs.length);

                return BoardTile(
                  title: snapshot.data.docs[reqIndex]['title'],
                  body: snapshot.data.docs[reqIndex]['body'],
                  time_limit: snapshot.data.docs[reqIndex]['time_limit'],
                  category: snapshot.data.docs[reqIndex]['category'],
                );
              },
              separatorBuilder: (context, index) {
                return Divider(
                  color: priority,
                  thickness: 1.0,
                );
              },
            );
          } else {
            return Text('error');
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text("LINK"),
            centerTitle: true,
            backgroundColor: const Color.fromARGB(250, 247, 162, 144),
            elevation: 10.0,
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                onPressed: () {
                  showSearch(context: context, delegate: Search());
                },
              ),
            ],
            bottom: TabBar(
              indicatorColor: Colors.white,
              // fromARGB(250, 247, 162, 144),
              labelColor: Colors.white,
              // Color.fromARGB(250, 247, 162, 144),
              tabs: [
                Tab(icon: Icon(Icons.local_grocery_store_outlined)),
                Tab(icon: Icon(Icons.school_outlined)),
                Tab(icon: Icon(Icons.directions_bike_outlined)),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              //카테고리,제목,마감시간 text 컨테이너와 getBoard()가 Column으로 묶여있다
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 25),
                          child: Text(
                            '카테고리',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 100,
                        ),
                        Container(
                          child: Text(
                            '제목',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 100,
                        ),
                        Container(
                          child: Text(
                            '마감시간',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: SizedBox(
                      height: 550,
                      child: getBoard(),
                    ),
                  ),
                ],
              ),
              Container(
                alignment: Alignment.center,
                //   Text(
                //     "스터디",
                //     style: TextStyle(fontSize: 30, color: Colors.black),
                //     textAlign: TextAlign.center,
                //   ),
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
