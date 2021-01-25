import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:link_ver1/helper/helper_functions.dart';
import 'package:link_ver1/services/database_service.dart';
import 'package:link_ver1/widgets/message_tile.dart';
import 'package:link_ver1/helper/helper_functions.dart';

//주석
class ChatPage extends StatefulWidget {
  //message.dart에서 데이터 읽어옴 (MyUsers collection used)
  final String groupId;
  final String userName;
  final String groupName;
  final Widget groupMembers;
  final String profilePic;

  ChatPage(
      {this.groupId,
      this.userName,
      this.groupName,
      this.groupMembers,
      this.profilePic});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  User _user;
  String _userName;
  //String profilePic;
  final checkingFormat = new DateFormat('dd');
  final printFormat = new DateFormat('yyyy년 MM월 dd일');
  bool _isJoined;
  Stream<QuerySnapshot> _chats;
  TextEditingController messageEditingController = new TextEditingController();
  ScrollController scrollController = new ScrollController();
  Timestamp recent;
  Stream _recentStream;
  Widget _chatMessages() {
    return StreamBuilder(
      stream: _chats,
      builder: (context, snapshot) {
        // Timer(
        //     Duration(milliseconds: 100),
        //     () => scrollController
        //         .jumpTo(scrollController.position.maxScrollExtent));
        return snapshot.hasData
            ? ListView.builder(
                reverse: true,
                controller: scrollController,
                padding: EdgeInsets.only(bottom: 80),
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                    type: snapshot.data.documents[index].data()["type"],
                    message: snapshot.data.documents[index].data()["message"],
                    sender: snapshot.data.documents[index].data()["sender"],
                    sentByMe: widget.userName ==
                        snapshot.data.documents[index].data()["sender"],
                    now: snapshot.data.documents[index].data()["time"],
                    profilePic:
                        snapshot.data.documents[index].data()["profilePic"],
                  );
                },
              )
            : Container();
      },
    );
  }

  // Widget _groupUsers(){
  //
  //
  //       return ListView.builder(
  //         padding: EdgeInsets.only(bottom: 80),
  //         itemCount: _groupInfo.
  //         itemBuilder: (context,index){
  //           return ListTile(
  //             title: Text(snapshot.data['members']),
  //           );
  //         },
  //       ) :
  //           Text('Nothing');
  //     },

  _sendMessage(String type, {path}) async {
    try {
      await getRecentTime();

      if (checkingFormat.format(recent.toDate()) !=
          checkingFormat.format(Timestamp.now().toDate())) {
        //print('Checking format : ' + checkingFormat.format(recent.toDate()).toString()  + 'Now : ' + checkingFormat.format(Timestamp.now().toDate()));

        Map<String, dynamic> chatMessageMap = {
          "message": printFormat.format(Timestamp.now().toDate()),
          "type": 'DateChecker',
          "sender": 'system',
          'time': DateTime.now(),
        };
        DatabaseService().sendMessage(widget.groupId, chatMessageMap, type);
      }
    } catch (e) {
      Map<String, dynamic> chatMessageMap = {
        "message": printFormat.format(Timestamp.now().toDate()),
        "type": 'DateChecker',
        "sender": 'system',
        'time': DateTime.now(),
      };
      DatabaseService().sendMessage(widget.groupId, chatMessageMap, type);
    }

    if (type == 'image') {
      Map<String, dynamic> chatMessageMap = {
        "message": path,
        "type": type,
        "sender": widget.userName,
        'time': DateTime.now(),
        'profilePic': widget.profilePic
      };
      DatabaseService().sendMessage(widget.groupId, chatMessageMap, type);
    } else if (type == 'text') {
      if (messageEditingController.text.isNotEmpty) {
        Map<String, dynamic> chatMessageMap = {
          "message": messageEditingController.text,
          "type": type,
          "sender": widget.userName,
          'time': DateTime.now(),
          'profilePic': widget.profilePic
        };

        DatabaseService().sendMessage(widget.groupId, chatMessageMap, type);

        setState(() {
          messageEditingController.text = "";
        });
      }

      //scrollController.jumpTo(scrollController.position.maxScrollExtent);
    } else if (type == 'system_out') {
      Map<String, dynamic> chatMessageMap = {
        "message": widget.userName + '님이 나가셨습니다',
        "type": type,
        "sender": widget.userName,
        'time': DateTime.now(),
      };
      DatabaseService().sendMessage(widget.groupId, chatMessageMap, type);
    }
  }

  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile image = await imagePicker.getImage(source: ImageSource.gallery);
    if (image != null) {
      String path = image.path;
      uploadFile(path);
    }
  }

  Future uploadFile(String path) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference =
        FirebaseStorage.instance.ref().child(widget.groupId + '/' + fileName);
    UploadTask uploadTask = reference.putFile(File(path));
    TaskSnapshot taskSnapshot = await uploadTask;
    taskSnapshot.ref.getDownloadURL().then((downloadURL) {
      setState(() {
        _sendMessage('image', path: downloadURL);
      });
    }, onError: (err) {
      Fluttertoast.showToast(msg: 'This File is not an image');
    });
  }

  void getRecentTime() async {
    await FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.groupId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        recent = documentSnapshot.get('recentMessageTime');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    DatabaseService().getChats(widget.groupId).then((val) {
      // print(val);
      setState(() {
        _chats = val;
      });
    });
    _getCurrentUserNameAndUid();
  }

  _getCurrentUserNameAndUid() async {
    await HelperFunctions.getUserNameSharedPreference().then((value) {
      _userName = value;
    });
    // await HelperFunctions.getUserProfilePicPreference().then((value)
    // {
    //   profilePic = value;
    // });
    _user = await FirebaseAuth.instance.currentUser;
  }

  _joinValueInGroup(
      String userName, String groupId, String groupName, String admin) async {
    bool value = await DatabaseService(uid: _user.uid)
        .isUserJoined(groupId, groupName, userName);
    setState(() {
      _isJoined = value;
    });
  }

  //채팅방 화면 빌드
  @override
  Widget build(BuildContext context) {
    Color basic = Color.fromARGB(250, 247, 162, 144);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.groupName, style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: basic,
        elevation: 10.0,
      ),
      endDrawer: Drawer(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 1,
              decoration: BoxDecoration(
                  color: Color.fromARGB(250, 247, 162, 144),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10))),
              child: Column(children: [
                widget.profilePic != null
                    ? CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(widget.profilePic),
                      )
                    : CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 60,
                        backgroundImage: AssetImage('assets/user.png'),
                      ),
                Container(
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Text(
                      _userName + '님',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ))
              ]),
            ),
            Expanded(
              child: Container(
                child: widget.groupMembers,
              ),
            ),
            // Expanded(
            //     child: SizedBox(
            //   child: widget.groupMembers,
            //       height: 600,
            // ),
            // ),

            Container(
              // color: Colors.grey[300],
              child: Row(children: [
                IconButton(
                  iconSize: 30,
                  color: basic,
                  icon: Transform.rotate(
                    angle: math.pi,
                    child: Icon(Icons.input),
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('나가시겠습니까?'),
                            actions: [
                              FlatButton(
                                  onPressed: () async {
                                    Navigator.pop(context);
                                  },
                                  child: Text('취소')),
                              FlatButton(
                                onPressed: () async {
                                  _sendMessage('system_out');
                                  // DatabaseService(uid: _user.uid)
                                  //     .togglingGroupJoin(widget.groupId,
                                  //         widget.groupName, widget.userName);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                child: Text('확인'),
                              )
                            ],
                          );
                        });
                  },
                ),
              ]),
            )
          ],
        ),
      ),

      //화면에 채팅 내용 출력 & 하단에 위치한 채팅 입력하는 칸
      body: Container(
        child: Stack(
          children: <Widget>[
            _chatMessages(),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: basic),
                  color: Colors.white,
                ),
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                // color: Colors.white,
                child: Row(
                  children: <Widget>[
                    IconButton(
                        icon: Icon(Icons.image),
                        onPressed: () {
                          getImage();
                        }),
                    Expanded(
                      child: TextField(
                        controller: messageEditingController,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            hintText: "Send a message ...",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                            border: InputBorder.none),
                      ),
                    ),
                    SizedBox(width: 12.0),
                    GestureDetector(
                      onTap: () {
                        _sendMessage('text');
                        Timer(
                            Duration(milliseconds: 100),
                            () => scrollController.jumpTo(
                                scrollController.position.minScrollExtent));
                      },
                      child: Container(
                        height: 50.0,
                        width: 50.0,
                        decoration: BoxDecoration(
                            color: basic,
                            borderRadius: BorderRadius.circular(50)),
                        child: Center(
                            child: Icon(Icons.send, color: Colors.white)),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
