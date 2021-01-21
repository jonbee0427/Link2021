import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:link_ver1/helper/helper_functions.dart';
import 'package:link_ver1/services/auth_service.dart';
import 'package:link_ver1/services/database_service.dart';
import 'package:link_ver1/widgets/group_tile.dart';
import 'package:async/async.dart';
import 'package:intl/intl.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  // data
  final AuthService _auth = AuthService();
  User _user;
  String _groupName;
  String _userName = '';
  String _email = '';
  Stream _groups;
  CollectionReference chats;
  Stream recent;
  String recentTimeString;

  // initState
  @override
  void initState() {
    super.initState();
    _getUserAuthAndJoinedGroups();
  }

  String getRecentTimeString(String result) {
    return result;
  }

<<<<<<< HEAD
  // widgets
=======
>>>>>>> abf7a74a236e346d5c807d9892e3e803dd171e39
  Widget noGroupWidget() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
                onTap: () {
                  _popupDialog(context);
                },
                child: Icon(Icons.add_circle,
                    color: Colors.grey[700], size: 75.0)),
            SizedBox(height: 20.0),
            Text(
                "You've not joined any group, tap on the 'add' icon to create a group or search for groups by tapping on the search button below."),
          ],
        ));
  }

  Widget getRecent(String groupId) {
    _getRecentStream(groupId);
    return StreamBuilder(
      stream: recent,
<<<<<<< HEAD
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          try {
            Timestamp recentTime = snapshot.data['recentMessageTime'];
            String type = snapshot.data['recentMessageType'];
            if (type == 'image') {
              return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Icon(Icons.photo),
                          Text('사진'),
                        ],
                      ),
                    ),
                  ]);
            } else {
              return Container(
                child: Row(children: [
                  Expanded(
                    flex: 85,
                    child: Container(
                      padding: EdgeInsets.only(right: 15),
                      child: Text(
                        snapshot.data['recentMessage'],
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 15,
                    child: Container(
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height * 0.04,
                      decoration: BoxDecoration(
                        color: Colors.pink,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '10',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ]),
              );
            }
          } catch (e) {
            return Text('nothing');
          }
        }
        return Text('nothing');
      },
    );
  }

  Widget getRecentTime(String groupId) {
    _getRecentStream(groupId);
    final form = new DateFormat('Md').add_Hm();
    return StreamBuilder(
      stream: recent,
=======
>>>>>>> abf7a74a236e346d5c807d9892e3e803dd171e39
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          try {
            Timestamp recentTime = snapshot.data['recentMessageTime'];
<<<<<<< HEAD
            return Text(form.format(recentTime.toDate()));
          } catch (e) {
            return Text(' ');
=======
            String type = snapshot.data['recentMessageType'];
            if (type == 'image') {
              return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Icon(Icons.photo),
                          Text('사진'),
                        ],
                      ),
                    ),
                  ]);
            } else {
              return Container(
                child: Row(children: [
                  Expanded(
                    flex: 85,
                    child: Container(
                      padding: EdgeInsets.only(right: 15),
                      child: Text(
                        snapshot.data['recentMessage'],
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 15,
                    child: Container(
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height * 0.04,
                      decoration: BoxDecoration(
                        color: Colors.pink,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '10',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ]),
              );
            }
          } catch (e) {
            return Text('nothing');
>>>>>>> abf7a74a236e346d5c807d9892e3e803dd171e39
          }
        }
        return Text('nothing');
      },
    );
  }

<<<<<<< HEAD
=======
  Widget getRecentTime(String groupId) {
    _getRecentStream(groupId);
    final form = new DateFormat('Md').add_Hm();
    return StreamBuilder(
      stream: recent,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          try {
            Timestamp recentTime = snapshot.data['recentMessageTime'];
            return Text(form.format(recentTime.toDate()));
          } catch (e) {
            return Text(' ');
          }
        }
        return Text('nothing');
      },
    );
  }

>>>>>>> abf7a74a236e346d5c807d9892e3e803dd171e39
  Widget getGroupMembers(String groupId) {
    _getRecentStream(groupId);
    return StreamBuilder(
      stream: recent,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data['members'].length,
            itemBuilder: (context, index) {
              int reqIndex = snapshot.data['members'].length - index - 1;
              return ListTile(
                title:
                    Text(_destructureName(snapshot.data['members'][reqIndex])),
              );
            },
          );
        } else {
          return Text('noOne');
        }
      },
    );
  }

  _getRecentStream(String groupId) async {
    recent = chats.doc(groupId).snapshots();
  }

  Widget groupsList() {
    return StreamBuilder(
      stream: _groups,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['groups'] != null) {
            // print(snapshot.data['groups'].length);
            if (snapshot.data['groups'].length != 0) {
              return ListView.builder(
                  itemCount: snapshot.data['groups'].length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    int reqIndex = snapshot.data['groups'].length - index - 1;
                    return GroupTile(
                      userName: snapshot.data['name'],
                      groupId:
<<<<<<< HEAD
                          _destructureId(snapshot.data['groups'][reqIndex]),
                      groupName:
                          _destructureName(snapshot.data['groups'][reqIndex]),
                      recentMsg: getRecent(
                          _destructureId(snapshot.data['groups'][reqIndex])),
                      groupMembers: getGroupMembers(
                          _destructureId(snapshot.data['groups'][reqIndex])),
                      recentTime: getRecentTime(
                          _destructureId(snapshot.data['groups'][reqIndex])),
                    );
=======
                      _destructureId(snapshot.data['groups'][reqIndex]),
                      groupName:
                      _destructureName(snapshot.data['groups'][reqIndex]),
                      recentMsg: getRecent( _destructureId(snapshot.data['groups'][reqIndex])),
                      groupMembers: getGroupMembers( _destructureId(snapshot.data['groups'][reqIndex])),
                        recentTime: getRecentTime(_destructureId(snapshot.data['groups'][reqIndex])),
                        profilePic: snapshot.data['profilePic']);
>>>>>>> abf7a74a236e346d5c807d9892e3e803dd171e39
                  });
            } else {
              return noGroupWidget();
            }
          } else {
            return noGroupWidget();
          }
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }


  // functions
  _getUserAuthAndJoinedGroups() async {
    _user = await FirebaseAuth.instance.currentUser;
    await HelperFunctions.getUserNameSharedPreference().then((value) {
      setState(() {
        _userName = value;
      });
    });
    DatabaseService(uid: _user.uid).getUserGroups().then((snapshots) {
      // print(snapshots);
      setState(() {
        _groups = snapshots;
      });
    });
    await HelperFunctions.getUserEmailSharedPreference().then((value) {
      setState(() {
        _email = value;
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

<<<<<<< HEAD
=======
  //사라질 기능
>>>>>>> abf7a74a236e346d5c807d9892e3e803dd171e39
  void _popupDialog(BuildContext context) {
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget createButton = FlatButton(
      child: Text("Create"),
      onPressed: () async {
        if (_groupName != null) {
          await HelperFunctions.getUserNameSharedPreference().then((val) {
            DatabaseService(uid: _user.uid).createGroup(val, _groupName);
          });
          Navigator.of(context).pop();
        }
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Create a group"),
      content: TextField(
          onChanged: (val) {
            _groupName = val;
          },
          style: TextStyle(fontSize: 15.0, height: 2.0, color: Colors.black)),
      actions: [
        cancelButton,
        createButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: groupsList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _popupDialog(context);
        },
        child: Icon(Icons.add, color: Colors.white, size: 30.0),
        backgroundColor: Colors.grey[700],
        elevation: 0.0,
      ),
    );
  }
}
