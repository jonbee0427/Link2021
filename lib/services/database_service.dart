import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  // Collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('MyUsers');
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection('groups');

  // update userdata
  Future updateUserData(String fullName, String email, String password) async {
    return await userCollection.doc(uid).set({
      'name': fullName,
      'email': email,
      'password': password,
      'groups': [],
      'profilePic': '',
      'account': ''
    });
  }

  String _destructureEnteringTime(String res) {
    // print(res.substring(res.indexOf('_') + 1));
    // print('이름 으랴랴랴' + res.substring(res.indexOf('_') + 1));
    return res.substring(res.indexOf('`') + 1);
  }

  Future updateGroupName(
    String uid,
    String newGroupName,
    String groupId,
  ) async {
    DocumentReference membersDocRec =
        await FirebaseFirestore.instance.collection('MyUsers').doc(uid);
    DocumentReference userDocRef = userCollection.doc(uid);
    DocumentSnapshot userDocSnapshot = await userDocRef.get();
    List<dynamic> groups = await userDocSnapshot.data()['groups'];
    int index = 0;
    groups.forEach((element) {
      if (element.contains(groupId)) {
        String enteringTime = _destructureEnteringTime(element);
        groups[index] = groupId + '_' + newGroupName + '`' + enteringTime;
      }
      index++;
    });
    membersDocRec.update({'groups': groups});
  }

  Future uploadFile(String path, String groupDocRefid) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference = FirebaseStorage.instance
        .ref()
        .child('${groupDocRefid}/' + 'board/' + fileName);
    UploadTask uploadTask = reference.putFile(File(path));
    TaskSnapshot taskSnapshot = await uploadTask;
    taskSnapshot.ref.getDownloadURL().then((downloadURL) {
      // setState(() {
      //   //_sendMessage('image', path: downloadURL);
      // });
    }, onError: (err) {
      // Toast.show('the file is not a image.', context,
      //     duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    });
  }

  // create group
  Future createGroup(
      String userName,
      String groupName,
      String title,
      String body,
      String datetime,
      int max_person,
      String subcategory,
      String category,
      Timestamp create_time,
      List<String> path) async {
    DocumentReference groupDocRef = await groupCollection.add({
      'groupName': groupName,
      'groupIcon': '',
      'admin': userName,
      'members': [],
      'membersNum': 1,
      //'messages': ,
      'groupId': '',
      'subcategory': subcategory,
      'recentMessage': '채팅방이 생성되었습니다.',
      'recentMessageSender': '',
      'title': title,
      'body': body,
      'time_limit': datetime,
      'max_person': max_person,
      'create_time': create_time,
      'category': category,
      'isdeleted': false,
      'deletePermit': 0
    });

    await groupDocRef.update({
      'members': FieldValue.arrayUnion([uid + '_' + userName]),
      'groupId': groupDocRef.id,
    });
    for (String p in path) {
      print(groupDocRef.id);
      uploadFile(p, groupDocRef.id);
    }

    DocumentReference userDocRef = userCollection.doc(uid);
    return await userDocRef.update({
      'groups': FieldValue.arrayUnion(
          [groupDocRef.id + '_' + groupName + '`' + DateTime.now().toString()])
    });
  }

  // toggling the user group join
  Future JoinChat(String groupId, String groupName, String userName) async {
    DocumentReference userDocRef = userCollection.doc(uid);
    DocumentSnapshot userDocSnapshot = await userDocRef.get();

    DocumentReference groupDocRef = groupCollection.doc(groupId);
    DocumentSnapshot groupDocSnapshot = await groupDocRef.get();
    FirebaseStorage desertRef = FirebaseStorage.instance;

    int membersNum = await groupDocSnapshot.data()['membersNum'];
    print(membersNum);
    //List<dynamic> groups = await userDocSnapshot.data()['groups'];
    bool isInit = false;
    String now = DateTime.now().toString();
    //int membersNum = await groupDocSnapshot.data()['membersNum'];
    try {
      print('Hello');
      List<dynamic> groups = await userDocSnapshot.data()['groups'];
      groups.forEach((element) async {
        if (element.contains(groupId + '_' + groupName)) {
          isInit = true;
        }
      });

      if (isInit == true) {
        Fluttertoast.showToast(msg: '이미 들어가있습니다');
      } else {
        await userDocRef.update({
          'groups':
              FieldValue.arrayUnion([groupId + '_' + groupName + '`' + now])
        });

        await groupDocRef.update({
          'members': FieldValue.arrayUnion([uid + '_' + userName]),
          'membersNum': FieldValue.increment(1)
        });
      }
    } catch (e) {
      print('Error Here');
      await userDocRef.update({
        'groups': FieldValue.arrayUnion([groupId + '_' + groupName + '`' + now])
      });

      print(e.toString());
      await groupDocRef.update({
        'members': FieldValue.arrayUnion([uid + '_' + userName]),
        'membersNum': FieldValue.increment(1)
      });
    }
  }

  // toggling the user group join
  Future OutChat(String groupId, String groupName, String userName,
      String enteringTime) async {
    print(groupId + ' ' + groupName);

    DocumentReference userDocRef = userCollection.doc(uid);
    DocumentSnapshot userDocSnapshot = await userDocRef.get();

    DocumentReference groupDocRef = groupCollection.doc(groupId);
    DocumentSnapshot groupDocSnapshot = await groupDocRef.get();
    FirebaseStorage desertRef = FirebaseStorage.instance;

    int membersNum = await groupDocSnapshot.data()['membersNum'];
    List<dynamic> groups = await userDocSnapshot.data()['groups'];
    if (groups.contains(groupId + '_' + groupName + '`' + enteringTime)) {
      await userDocRef.update({
        'groups': FieldValue.arrayRemove(
            [groupId + '_' + groupName + '`' + enteringTime])
      });

      await groupDocRef.update({
        'members': FieldValue.arrayRemove([uid + '_' + userName]),
        'membersNum': FieldValue.increment(-1)
      });
      print('currentNum: ' + membersNum.toString());
      if (membersNum <= 1) {
        desertRef.ref().child(groupId + '/').listAll().then((value) {
          value.items.forEach((element) {
            element.delete();
          });
        });
        await groupDocRef.collection('messages').get().then((snapshot) {
          for (DocumentSnapshot ds in snapshot.docs) {
            ds.reference.delete();
          }
        });
        await groupDocRef.delete();
      }
    } else {
      Fluttertoast.showToast(msg: '속해있는 채팅방이 아닙니다!');
    }
  }

  Future DeleteChat(String groupId, String groupName, String userName) async {
    DocumentReference userDocRef = userCollection.doc(uid);
    DocumentSnapshot userDocSnapshot = await userDocRef.get();

    DocumentReference groupDocRef = groupCollection.doc(groupId);
    DocumentSnapshot groupDocSnapshot = await groupDocRef.get();
    FirebaseStorage desertRef = FirebaseStorage.instance;
    desertRef.ref().child(groupId + '/').listAll().then((value) {
      value.items.forEach((element) {
        element.delete();
      });
    });
    await groupDocRef.collection('messages').get().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
    await groupDocRef.delete();
  }

  // has user joined the group
  Future<bool> isUserJoined(
      String groupId, String groupName, String userName) async {
    DocumentReference userDocRef = userCollection.doc(uid);
    DocumentSnapshot userDocSnapshot = await userDocRef.get();

    List<dynamic> groups = await userDocSnapshot.data()['groups'];

    if (groups.contains(groupId + '_' + groupName)) {
      //print('he');
      return true;
    } else {
      //print('ne');
      return false;
    }
  }

  // get user data
  Future getUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where('email', isEqualTo: email).get();
    print(snapshot.docs[0].data);
    return snapshot;
  }

  // get user groups
  getUserGroups() async {
    // return await Firestore.instance.collection("users").where('email', isEqualTo: email).snapshots();
    return FirebaseFirestore.instance
        .collection("MyUsers")
        .doc(uid)
        .snapshots();
  }

  // send message
  sendMessage(String groupId, chatMessageData, String type) {
    FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .add(chatMessageData);
    FirebaseFirestore.instance.collection('groups').doc(groupId).update({
      'recentMessage': chatMessageData['message'],
      'recentMessageSender': chatMessageData['sender'],
      'recentMessageTime': chatMessageData['time'],
      'recentMessageType': chatMessageData['type']
    });
  }

  // get chats of a particular group
  getChats(String groupId, DateTime enteringTime) async {
    return FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .where('time', isGreaterThan: enteringTime)
        .orderBy('time', descending: true)
        .snapshots();
  }

  getGroup(String groupId) async {
    return FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document data: ${documentSnapshot.data()['recentMessageTime']}');
        return documentSnapshot.data();
      } else {
        print('Document does not exist on the database');
      }
    });
  }

  getRecentTime(String groupId) async {
    FirebaseFirestore.instance.collection('groups').doc(groupId).snapshots();
  }

  // search groups
  searchByName(String groupName) {
    return FirebaseFirestore.instance
        .collection("groups")
        .where('groupName', isEqualTo: groupName)
        .get();
  }
}
