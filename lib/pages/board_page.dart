import 'dart:ffi';

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
  Color priority = Color.fromARGB(250, 247, 162, 144);
  DocumentReference myDoc;
  List<dynamic> myGroup;
  String inEnteringTime;

  // void print_test() {
  //   print('title : ' + widget.title);
  //   print('category : ' + widget.category);
  //   print('time limit : ' + widget.time_limit);
  //   print('body : ' + widget.body);
  //   //print('create time : ' + widget.create_time);
  //   print('max person : ' + widget.max_person.toString());
  //   print('group id : ' + widget.groupId);
  //   print('group name : ' + widget.groupName);
  //   print('user name : ' + widget.userName);
  // }
  String _destructureId(String res) {
    // print(res.substring(0, res.indexOf('_')));
    return res.substring(0, res.indexOf('_'));
  }

  String _destructureName(String res) {
    // print(res.substring(res.indexOf('_') + 1));
    return res.substring(res.indexOf('_') + 1);
  }

  String _destructureEnteringTime(String res) {
    // print(res.substring(res.indexOf('_') + 1));
    print('이름 으랴랴랴' + res.substring(res.indexOf('_') + 1));
    return res.substring(res.indexOf('`') + 1);
  }

  DateTime convertDateFromString(String strDate) {
    return DateTime.parse(strDate);
  }

  @override
  void initState()  {
    // TODO: implement initState
    super.initState();
     initialize();
  }

  initialize() async {
    myDoc =
        await FirebaseFirestore.instance.collection('MyUsers').doc(widget.uid);
    await myDoc.get().then((value) {
      myGroup = value.get('groups');
    });

<<<<<<< HEAD
    myGroup.forEach((element) async {
      if(element.contains(widget.groupId)){
        inEnteringTime =  _destructureEnteringTime(element);
=======
    myGroup.forEach((element) {
      if (element.contains(widget.groupId)) {
        inEnteringTime = _destructureEnteringTime(element);
>>>>>>> JH
        print('Entering TIme : ' + inEnteringTime);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print(widget.title + "  "  +   widget.category + "  " + widget.subcategory);
    print(widget.time_limit + "  "  +   widget.body + "  " + widget.create_time.toString());//create_time null
    print(widget.max_person.toString() + "  "  +   widget.current_person.toString() + "  " + widget.userName);
    print(widget.userName + "  "  +   widget.groupId + "  " + widget.groupName);
    print(widget.uid + "  "  +   widget.profilePic + "  " + widget.deletePermit.toString());
    print(widget.admin + "  "  +   widget.enteringTime.toString() );//enteringTime null

<<<<<<< HEAD
  //  print('Entering TIme : ' + convertDateFromString(widget.enteringTime.toString()).toString());

=======
>>>>>>> JH
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
              await initialize();

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatPage(
                            groupId: widget.groupId,
                            userName: widget.userName,
                            groupName: widget.groupName,
                            groupMembers: widget.groupMembers,
                            profilePic: widget.profilePic,
                            enteringTime:  convertDateFromString(inEnteringTime),
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
          SizedBox(
            height: 10,
          ),
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
                    widget.current_person - 1 == widget.deletePermit || widget.category != '공동 구매'
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
                                      await initialize();
                                      print('삭제예정 ID : ' + userId);
                                      await DatabaseService(uid: userId)
                                          .OutChat(
                                              widget.groupId,
                                              widget.groupName,
                                              userName,
                                              "");
                                    });
                                  });
                                  DatabaseService(uid: widget.uid).DeleteChat(
                                      widget.groupId,
                                      widget.groupName,
                                      widget.userName);
                                  Navigator.pop(context);

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
      bottomNavigationBar: null,
    );
  }
}
