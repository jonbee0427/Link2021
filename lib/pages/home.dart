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
  Stream _groups;
  Stream _study;
  Stream _hobby;
  User _user;
  String _userName = '';
  Color priority = Color.fromARGB(250, 247, 162, 144);
  CollectionReference chats;
  Stream recent;

  // initState
  @override
  void initState() {
    super.initState();
    //_boards = FirebaseFirestore.instance.collection('writing').snapshots();
    _groups = FirebaseFirestore.instance
        .collection('groups')
        .where('category', isEqualTo: '공동 구매')
        .snapshots();
    _study = FirebaseFirestore.instance
        .collection('groups')
        .where('category', isEqualTo: '스터디')
        .snapshots();
    _hobby = FirebaseFirestore.instance
        .collection('groups')
        .where('category', isEqualTo: '취미 생활')
        .snapshots();
    _getUserAuthAndJoinedGroups();
  }

  _getUserAuthAndJoinedGroups() async {
    //groups = await FirebaseFirestore.instance.collection('groups').doc(groupId).get().data['members'];
    _user = await FirebaseAuth.instance.currentUser;
    await HelperFunctions.getUserNameSharedPreference().then((value) {
      setState(() {
        _userName = value;
      });
    });
    chats = await FirebaseFirestore.instance.collection('groups');
  }

  String _destructureId(String res) {
    // print(res.substring(0, res.indexOf('_')));
    return res.substring(0, res.indexOf('_'));
  }

  String _destructureName(String res) {
    // print(res.substring(res.indexOf('_') + 1));
    return res.substring(res.indexOf('_') + 1);
  }

  _getRecentStream(String groupId) async {
    recent = chats.doc(groupId).snapshots();
  }
  String _destructureEnteringTime(String res) {
    // print(res.substring(res.indexOf('_') + 1));
    // print('이름 으랴랴랴' + res.substring(res.indexOf('_') + 1));
    return res.substring(res.indexOf('`') + 1);
  }

  DateTime convertDateFromString(String strDate){
    return DateTime.parse(strDate);

  }



  Widget getGroupMembers(String groupId) {
    _getRecentStream(groupId);
    return StreamBuilder(
      stream: recent,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            padding: EdgeInsets.only(top: 0),
            shrinkWrap: true,
            itemCount: snapshot.data['members'].length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Row(children: [
                  Text(_destructureName(snapshot.data['members'][index])),
                  snapshot.data['admin'] ==
                          _destructureName(snapshot.data['members'][index])
                      ? Text(' (방장)')
                      : Text(''),
                ]),
              );
            },
          );
        } else {
          return Text('noOne');
        }
      },
    );
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
                  groupMembers:
                      getGroupMembers(snapshot.data.docs[reqIndex]['groupId']),
                  groupName: snapshot.data.docs[reqIndex]['groupName'],
                  title: snapshot.data.docs[reqIndex]['title'],
                  body: snapshot.data.docs[reqIndex]['body'],
                  time_limit: snapshot.data.docs[reqIndex]['time_limit'],
                  category: snapshot.data.docs[reqIndex]['category'],
                  subcategory: snapshot.data.docs[reqIndex]['subcategory'],
                  uid: _user.uid,
                  max_person: snapshot.data.docs[reqIndex]['max_person'],
                  current_person: snapshot.data.docs[reqIndex]['membersNum'],
                  profilePic: _user.photoURL,
                  deletePermit: snapshot.data.docs[reqIndex]['deletePermit'],
                  admin: snapshot.data.docs[reqIndex]['admin'],
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

  Widget getStudy() {
    return StreamBuilder(
        stream: _study,
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
                  groupMembers:
                      getGroupMembers(snapshot.data.docs[reqIndex]['groupId']),
                  groupName: snapshot.data.docs[reqIndex]['groupName'],
                  title: snapshot.data.docs[reqIndex]['title'],
                  body: snapshot.data.docs[reqIndex]['body'],
                  time_limit: snapshot.data.docs[reqIndex]['time_limit'],
                  category: snapshot.data.docs[reqIndex]['category'],
                  subcategory: snapshot.data.docs[reqIndex]['subcategory'],
                  uid: _user.uid,
                  max_person: snapshot.data.docs[reqIndex]['max_person'],
                  current_person: snapshot.data.docs[reqIndex]['membersNum'],
                  profilePic: _user.photoURL,
                  deletePermit: snapshot.data.docs[reqIndex]['deletePermit'],
                  admin: snapshot.data.docs[reqIndex]['admin'],
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

  Widget getHobby() {
    return StreamBuilder(
        stream: _hobby,
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
                  groupMembers:
                      getGroupMembers(snapshot.data.docs[reqIndex]['groupId']),
                  groupName: snapshot.data.docs[reqIndex]['groupName'],
                  title: snapshot.data.docs[reqIndex]['title'],
                  body: snapshot.data.docs[reqIndex]['body'],
                  time_limit: snapshot.data.docs[reqIndex]['time_limit'],
                  category: snapshot.data.docs[reqIndex]['category'],
                  subcategory: snapshot.data.docs[reqIndex]['subcategory'],
                  uid: _user.uid,
                  max_person: snapshot.data.docs[reqIndex]['max_person'],
                  current_person: snapshot.data.docs[reqIndex]['membersNum'],
                  profilePic: _user.photoURL,
                  deletePermit: snapshot.data.docs[reqIndex]['deletePermit'],
                  admin: snapshot.data.docs[reqIndex]['admin'],
                   // enteringTime : convertDateFromString(_destructureEnteringTime(snapshot.data['groups'][reqIndex]))
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
                  showSearch(
                      context: context,
                      delegate: Search(
                          uid: _user.uid,
                          userName: _userName,
                          profilePic: _user.photoURL));
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
              //group purchase
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                  ),
                  Container(
                    child: Expanded(
                      child: getBoard(),
                    ),
                  ),
                ],
              ),

              //study
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(bottom: 8),
                  ),
                  Container(
                    child: Expanded(
                      child: getStudy(),
                    ),
                  ),
                ],
              ),

              //hobby
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(bottom: 8),
                  ),
                  Container(
                    child: Expanded(
                      child: getHobby(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
