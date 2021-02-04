import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:link_ver1/helper/helper_functions.dart';
import 'package:link_ver1/pages/search.dart';
import 'package:link_ver1/widgets/boardTile.dart';

//먼저 GroupCollection을 가져와야한다. admin이 uid와 일치하는 snapshot을 가져오는 작업을 해야한다.
class myBoard extends StatefulWidget {
  @override
  _myBoardState createState() => _myBoardState();
}

class _myBoardState extends State<myBoard> {
  CollectionReference myBoard;
  Stream _myBoard;
  String userName;
  User user;
  final Color primary = Color.fromARGB(250, 247, 162, 144);

  @override
  void initState() {
    // TODO: implement initState
    getMyWriting();
    super.initState();
  }

  getMyWriting() async {
    await HelperFunctions.getUserNameSharedPreference().then((value) {
      setState(() {
        userName = value;
      });
    });
    user = await FirebaseAuth.instance.currentUser;
    myBoard = await FirebaseFirestore.instance.collection('groups');
    _myBoard = await myBoard.where('admin', isEqualTo: userName).snapshots();
  }

  String _destructureName(String res) {
    // print(res.substring(res.indexOf('_') + 1));
    return res.substring(res.indexOf('_') + 1);
  }

  Widget getGroupMembers(String groupId) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('groups')
          .doc(groupId)
          .snapshots(),
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
    return StreamBuilder<QuerySnapshot>(
        stream: _myBoard,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
              itemCount: snapshot.data.size,
              itemBuilder: (context, index) {
                //itemBuilder : 게시글 하나하나,  index : 순서
                int reqIndex = snapshot.data.docs.length - index - 1;
                return BoardTile(
                  userName: userName,
                  groupId: snapshot.data.docs[reqIndex]['groupId'],
                  groupMembers:
                      getGroupMembers(snapshot.data.docs[reqIndex]['groupId']),
                  groupName: snapshot.data.docs[reqIndex]['groupName'],
                  title: snapshot.data.docs[reqIndex]['title'],
                  body: snapshot.data.docs[reqIndex]['body'],
                  time_limit: snapshot.data.docs[reqIndex]['time_limit'],
                  category: snapshot.data.docs[reqIndex]['category'],
                  uid: user.uid,
                  max_person: snapshot.data.docs[reqIndex]['max_person'],
                  current_person: snapshot.data.docs[reqIndex]['membersNum'],
                  profilePic: user.photoURL,
                  deletePermit: snapshot.data.docs[reqIndex]['deletePermit'],
                );
              },
              separatorBuilder: (context, index) {
                return Divider(
                  color: primary,
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
    return Scaffold(
      appBar: AppBar(
        title: Text("LINK"),
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
                      uid: user.uid,
                      userName: userName,
                      profilePic: user.photoURL));
            },
          )
        ],
      ),
      body: getBoard(),
    );
  }
}
