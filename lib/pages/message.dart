import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:link_ver1/helper/helper_functions.dart';
import 'package:link_ver1/pages/search.dart';
import 'package:link_ver1/services/auth_service.dart';
import 'package:link_ver1/services/database_service.dart';
import 'package:link_ver1/widgets/group_tile.dart';
import 'package:async/async.dart';
import 'package:intl/intl.dart';

//RecentMessageTime이 enteringTime보다 빠를 경우에는 null. 그렇지 않다면 recentMessage 전달.

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
  int selectedPage = 0;

  // initState
  @override
  void initState() {
    super.initState();
    _getUserAuthAndJoinedGroups();
  }

  String getRecentTimeString(String result) {
    return result;
  }

  Widget noGroupWidget() {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "사람들과 함께 새로운 활동을 해보세요! :)",
              style: TextStyle(fontSize: 15),
            ),
          ],
        )
      ],
    ));
  }

  Widget getRecent(String groupId) {
    _getRecentStream(groupId);
    return StreamBuilder(
      stream: recent,
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
                ]),
              );
            }
          } catch (e) {
            return Text(' ');
          }
        }
        return Text('');
      },
    );
  }

// Future<Timestamp>getEnteringTime(String groupId) async{
//   String enteringTime;
//   DateTime enteringTimeDate;
//   Timestamp enteringTimeDateStamp;
//   await FirebaseFirestore.instance.collection('MyUsers').doc(_user.uid).get().then((value) async {
//     List<dynamic> myGroup =await value.data()['groups'];
//     myGroup.forEach((element) async {
//       if(element.contains(groupId)){
//         enteringTime = await _destructureEnteringTime(element);
//         enteringTimeDate = await convertDateFromString(enteringTime);
//         enteringTimeDateStamp = await Timestamp.fromDate(enteringTimeDate);
//         print('DateTime to Timestamp' + enteringTimeDateStamp.toString());
//       }
//     });
//   });
//   return enteringTimeDateStamp;
// }
  Widget getRecentTime(String groupId) {
    _getRecentStream(groupId);
    Timestamp enteringTimeDateStamp;
    final form = new DateFormat('Md').add_Hm();
    return StreamBuilder(
      stream: recent,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          try {
            Timestamp recentTime = snapshot.data['recentMessageTime'];
            // getEnteringTime(groupId).then((value){
            //   enteringTimeDateStamp =  value;
            // });
            return Text(form.format(recentTime.toDate()));
          } catch (e) {
            print(e.toString());
            return Text('');
          }
        }
        return Text(' ');
      },
    );
  }

  Widget getGroupMembers(String groupId) {
    _getRecentStream(groupId);
    return StreamBuilder(
      stream: recent,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data['members'].length);
          return ListView.builder(
            padding: EdgeInsets.only(top: 0),
            shrinkWrap: true,
            itemCount: snapshot.data['members'].length,
            itemBuilder: (context, index) {
              print('숫자 : ' +
                  _destructureNameFromGroups(snapshot.data['members'][index]));
              return ListTile(
                title: Row(children: [
                  Text(_destructureNameFromGroups(
                      snapshot.data['members'][index])),
                  snapshot.data['admin'] ==
                          _destructureNameFromGroups(
                              snapshot.data['members'][index])
                      ? Text(' (방장)')
                      : Text(''),
                ]),
              );
            },
          );
        } else {
          print('ERROR');
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
                        profilePic: snapshot.data['profilePic'],
                        userName: snapshot.data['name'],
                        groupId:
                            _destructureId(snapshot.data['groups'][reqIndex]),
                        groupName:
                            _destructureName(snapshot.data['groups'][reqIndex]),
                        recentMsg: getRecent(
                            _destructureId(snapshot.data['groups'][reqIndex])),
                        groupMembers: getGroupMembers(
                            _destructureId(snapshot.data['groups'][reqIndex])),
                        recentTime: getRecentTime(
                            _destructureId(snapshot.data['groups'][reqIndex])),
                        enteringTime: convertDateFromString(
                            _destructureEnteringTime(
                                snapshot.data['groups'][reqIndex])));
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
    // print('이름 으랴랴랴' + res.substring(res.indexOf('_') + 1));
    return res.substring(res.indexOf('_') + 1, res.indexOf('`'));
    //return res.substring(res.indexOf('_') + 1);
  }

  String _destructureNameFromGroups(String res) {
    // print(res.substring(res.indexOf('_') + 1));
    // print('이름 으랴랴랴' + res.substring(res.indexOf('_') + 1));
    //return res.substring(res.indexOf('_') + 1,res.indexOf('`'));
    return res.substring(res.indexOf('_') + 1);
  }

  String _destructureEnteringTime(String res) {
    // print(res.substring(res.indexOf('_') + 1));
    // print('이름 으랴랴랴' + res.substring(res.indexOf('_') + 1));
    return res.substring(res.indexOf('`') + 1);
  }

  DateTime convertDateFromString(String strDate) {
    return DateTime.parse(strDate);
  }

  //사라질 기능
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
            // DatabaseService(uid: _user.uid).createGroup(val, _groupName);
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
      appBar: AppBar(
        title: Text("한동모아"),
        centerTitle: true,
        //backgroundColor: const Color.fromARGB(250, 247, 162, 144),
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
          )
        ],
      ),
      body: groupsList(),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     _popupDialog(context);
      //   },
      //   child: Icon(Icons.add, color: Colors.white, size: 30.0),
      //   backgroundColor: Colors.grey[700],
      //   elevation: 0.0,
      // ),
    );
  }
}
