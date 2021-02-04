import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:link_ver1/widgets/boardTile.dart';
import 'package:link_ver1/services/database_service.dart';
import 'package:link_ver1/helper/helper_functions.dart';
import 'package:link_ver1/pages/chat_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:link_ver1/helper/helper_functions.dart';
import 'package:toast/toast.dart';

import 'EditPage.dart';

class BoardPage extends StatefulWidget {
  final String title;
  final String category;
  final String subcategory;
  final String time_limit;
  final String body;
  final Timestamp create_time;
  final int max_person;
  final int current_person;
  final String userName;
  final String groupId;
  final String groupName;
  final String uid;
  final String profilePic;
  final Widget groupMembers;
  final int deletePermit;
  final String admin;
  final DateTime enteringTime;

  BoardPage(
      {this.title,
      this.category,
      this.subcategory,
      this.time_limit,
      this.body,
      this.create_time,
      this.max_person,
      this.current_person,
      this.groupId,
      this.groupMembers,
      this.groupName,
      this.userName,
      this.uid,
      this.profilePic,
      this.deletePermit,
      this.admin,
      this.enteringTime});
  @override
  _BoardPageState createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  List<dynamic> imageName;
  User user;
  Color priority = Color.fromARGB(250, 247, 162, 144);
  var downloadUrl;

  @override
  initState() {
    super.initState();
    initalizeUser();
  }

  initalizeUser() async {
    user = await FirebaseAuth.instance.currentUser;
  }

  Future getImage(String groupname, String admin) async {
    final _storage = FirebaseStorage.instance;
    int index = 0;
    await _storage.ref().child('$groupname$admin/').listAll().then((value) {
      value.items.forEach((element) {
        print('dsfsfsdfsdf' + element.toString());
        imageName[index] = element.toString();
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

  @override
  Widget build(BuildContext context) {
    print(context);
    print(widget.current_person);
    print(widget.deletePermit);
    getImage(widget.groupName, widget.admin);
    // print_test();
    return Scaffold(
      appBar: AppBar(
        title: Text('게시글 상세 정보'),
        centerTitle: true,
        backgroundColor: priority,
        elevation: 10.0,
        actions: [
          IconButton(
            icon: Icon(Icons.near_me_outlined),
            onPressed: () async {
              await DatabaseService(uid: widget.uid)
                  .JoinChat(widget.groupId, widget.groupName, widget.userName);

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatPage(
                            groupId: widget.groupId,
                            userName: widget.userName,
                            groupName: widget.groupName,
                            groupMembers: widget.groupMembers,
                            profilePic: widget.profilePic,
                            enteringTime: widget.enteringTime,
                          )));
            },
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              margin: const EdgeInsets.only(top: 30, left: 25),
              child: Text(
                '카테고리 : ' + widget.category,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width),
                  /*
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent)),
                      */
                  padding: const EdgeInsets.only(top: 10, left: 25),
                  child: Text(
                    '제목 : ' + widget.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    // overflow: TextOverflow.ellipse,
                  ),
                ),
              ],
            ),
            Container(
              /*
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent)),
                  */
              padding: const EdgeInsets.only(top: 10, left: 25),
              child: Text(
                '마감시간 : ' + widget.time_limit,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            Container(
              /*
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent)),
                  */
              padding: const EdgeInsets.only(top: 10, left: 25),
              child: Text(
                '최대 인원 : ' + '${widget.max_person}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            Container(
              /*
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent)),
                  */
              padding: const EdgeInsets.only(top: 10, left: 25),
              child: Text(
                '현재 인원 : ' + '${widget.current_person}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.875,
              //height: MediaQuery.of(context).size.height * 0.9,
              constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.width * 0.9),
              margin: const EdgeInsets.only(
                  top: 30, left: 25, right: 15, bottom: 10),
              padding: const EdgeInsets.only(
                  top: 15, left: 15, right: 15, bottom: 15),
              decoration: BoxDecoration(
                border: Border.all(color: priority, width: 3),
                borderRadius: BorderRadius.all(
                  Radius.circular(40),
                ),
              ),
              child: Flexible(
                //mainAxisAlignment: MainAxisAlignment.start,
                child: Text(
                  '내용 : ' + widget.body,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.visible,
                ),
              ),
            ),
          ]),
          /*
          SizedBox(
            height: 10,
            child: Stack(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(downloadUrl),
                  backgroundColor: Colors.white,
                ),
              ],
            ),
          ),*/
          widget.admin == widget.userName
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      //width: double.infinity,
                      height: 50.0,
                      child: RaisedButton(
                          elevation: 0.0,
                          color: Colors.pink[300],
                          // Color.fromARGB(300, 247, 162, 144),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                          child: Text('게시글 수정',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16.0)),
                          onPressed: () {
                            print('글 수정!');
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => EditPage(
                                      title: widget.title,
                                      category: widget.category,
                                      time_limit: widget.time_limit,
                                      body: widget.body,
                                      create_time: widget.create_time,
                                      max_person: widget.max_person,
                                      groupId: widget.groupId,
                                      groupName: widget.groupName,
                                      userName: widget.userName,
                                    )));
                          }),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    widget.current_person - 1 == widget.deletePermit
                        ? SizedBox(
                            //width: double.infinity,
                            height: 50.0,
                            child: RaisedButton(
                                elevation: 0.0,
                                color: Colors.pink[300],
                                // Color.fromARGB(300, 247, 162, 144),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0)),
                                child: Text('게시글 삭제',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16.0)),
                                onPressed: () async {
                                  DocumentReference currentDoc =
                                      await FirebaseFirestore.instance
                                          .collection('groups')
                                          .doc(widget.groupId);
                                  await currentDoc.get().then((value) {
                                    List<dynamic> currentMembers =
                                        value.get('members');
                                    currentMembers.forEach((element) async {
                                      String userId = _destructureId(element);
                                      String userName =
                                          _destructureName(element);
                                      await DatabaseService(uid: userId)
                                          .OutChat(
                                              widget.groupId,
                                              widget.groupName,
                                              userName,
                                              widget.enteringTime.toString());
                                    });
                                  });
                                  DatabaseService(uid: widget.uid).DeleteChat(
                                      widget.groupId,
                                      widget.groupName,
                                      widget.userName);
                                }),
                          )
                        : SizedBox(
                            //width: double.infinity,
                            height: 50.0,
                            child: RaisedButton(
                                elevation: 0.0,
                                color: Colors.grey,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0)),
                                child: Text('게시글 삭제',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16.0)),
                                onPressed: () {
                                  Fluttertoast.showToast(
                                      msg: '거래가 완료되지 않았습니다!');
                                }),
                          ),
                  ],
                )
              : Row(),
        ],
      ),
    );
  }
}
