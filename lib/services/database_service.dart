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

  // create group
  Future createGroup(String userName, String groupName, String title,
      String body, String datetime, int max_person, int create_time) async {
    DocumentReference groupDocRef = await groupCollection.add({
      'groupName': groupName,
      'groupIcon': '',
      'admin': userName,
      'members': [],
      'membersNum': 1,
      //'messages': ,
      'groupId': '',
      'recentMessage': '채팅방이 생성되었습니다.',
      'recentMessageSender': '',
      'title': title,
      'body': body,
      'time_limit': datetime,
      'max_person': max_person,
      'create_time': create_time,
      'category': '공동 구매'
    });

    await groupDocRef.update({
      'members': FieldValue.arrayUnion([uid + '_' + userName]),
      'groupId': groupDocRef.id
    });

    DocumentReference userDocRef = userCollection.doc(uid);
    return await userDocRef.update({
      'groups': FieldValue.arrayUnion([groupDocRef.id + '_' + groupName])
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
    List<dynamic> groups = await userDocSnapshot.data()['groups'];
    if (groups.contains(groupId + '_' + groupName)) {
      Fluttertoast.showToast(msg: '이미 들어가있습니다');
    } else {
      //print('nay');
      await userDocRef.update({
        'groups': FieldValue.arrayUnion([groupId + '_' + groupName])
      });

      await groupDocRef.update({
        'members': FieldValue.arrayUnion([uid + '_' + userName]),
        'membersNum': FieldValue.increment(1)
      });
    }
  }

  // toggling the user group join
  Future OutChat(String groupId, String groupName, String userName) async {
    DocumentReference userDocRef = userCollection.doc(uid);
    DocumentSnapshot userDocSnapshot = await userDocRef.get();

    DocumentReference groupDocRef = groupCollection.doc(groupId);
    DocumentSnapshot groupDocSnapshot = await groupDocRef.get();
    FirebaseStorage desertRef = FirebaseStorage.instance;

    int membersNum = await groupDocSnapshot.data()['membersNum'];
    List<dynamic> groups = await userDocSnapshot.data()['groups'];
    if (groups.contains(groupId + '_' + groupName)) {
      //print('hey');
      await userDocRef.update({
        'groups': FieldValue.arrayRemove([groupId + '_' + groupName])
      });

      await groupDocRef.update({
        'members': FieldValue.arrayRemove([uid + '_' + userName]),
        'membersNum': FieldValue.increment(-1)
      });
      if (membersNum == 1) {
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
  getChats(String groupId) async {
    return FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId)
        .collection('messages')
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
