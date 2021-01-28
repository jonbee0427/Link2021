import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:link_ver1/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:link_ver1/pages/home_page.dart';
import 'package:link_ver1/pages/search.dart';
import 'package:link_ver1/widgets/boardTile.dart';
import 'package:link_ver1/helper/helper_functions.dart';

import 'dart:async';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String title, body, time_limit, create_time;
  int max_person;
  Stream _boards;
  Stream _groups;
  User _user;
  String _userName = '';
  Color priority = Color.fromARGB(250, 247, 162, 144);

  // initState
  @override
  void initState() {
    super.initState();
    //_boards = FirebaseFirestore.instance.collection('writing').snapshots();
    _groups = FirebaseFirestore.instance.collection('groups').snapshots();
    _getUserAuthAndJoinedGroups();
  }

  _getUserAuthAndJoinedGroups() async {
    _user = await FirebaseAuth.instance.currentUser;
    await HelperFunctions.getUserNameSharedPreference().then((value) {
      setState(() {
        _userName = value;
      });
    });
  }

  String _destructureId(String res) {
    // print(res.substring(0, res.indexOf('_')));
    return res.substring(0, res.indexOf('_'));
  }

  String _destructureName(String res) {
    // print(res.substring(res.indexOf('_') + 1));
    return res.substring(res.indexOf('_') + 1);
  }

  Widget getBoard() {
    return StreamBuilder(
        stream: _groups,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
              itemCount: snapshot.data.size,
              itemBuilder: (context, index) {
                //itemBuilder : 게시글 하나하나,  index : 순서
                int reqIndex = snapshot.data.docs.length - index - 1;
                return BoardTile(
                  userName: _userName,
                  groupId: snapshot.data.docs[reqIndex]['groupId'],
                  //groupMembers: snapshot.data.docs[reqIndex]['members'],
                  groupName: snapshot.data.docs[reqIndex]['groupName'],
                  title: snapshot.data.docs[reqIndex]['title'],
                  body: snapshot.data.docs[reqIndex]['body'],
                  time_limit: snapshot.data.docs[reqIndex]['time_limit'],
                  category: snapshot.data.docs[reqIndex]['category'],
                  uid: _user.uid,
                  max_person: snapshot.data.docs[reqIndex]['max_person'],
                  current_person: snapshot.data.docs[reqIndex]
                      ['current_person'],
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
                            '제목',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 250,
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
                    child: Expanded(
                      child: getBoard(),
                    ),
                  ),
                ],
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
