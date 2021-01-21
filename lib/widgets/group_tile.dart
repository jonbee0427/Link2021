import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:link_ver1/pages/chat_page.dart';

class GroupTile extends StatelessWidget {
  final String userName;
  final String groupId;
  final String groupName;
  final Widget recentMsg;
  final Widget groupMembers;
  final Widget recentTime;

  GroupTile(
      {this.userName,
      this.groupId,
      this.groupName,
      this.recentMsg,
      this.groupMembers,
      this.recentTime});

  // void getRecentMsg() async {
  //   await FirebaseFirestore.instance
  //       .collection('groups')
  //       .doc(groupId)
  //       .get()
  //       .then((DocumentSnapshot documentSnapshot) {
  //     if (documentSnapshot.exists) {
  //       recentMsg = documentSnapshot.get('recentMessage');
  //       print(recentMsg);
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatPage(
                      groupId: groupId,
                      userName: userName,
                      groupName: groupName,
                      groupMembers: groupMembers,
                    )));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
        child: ListTile(
            leading: CircleAvatar(
              radius: 30.0,
              backgroundColor: Color.fromARGB(250, 247, 162, 144),
              child: Text(groupName.substring(0, 1).toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white)),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(groupName, style: TextStyle(fontWeight: FontWeight.bold)),
                recentTime
              ],
            ),
            //   subtitle: Text('Join the ' + groupName + ' as ' + userName,
            // style: TextStyle(fontSize: 13.0)),
            subtitle: recentMsg),
      ),
    );
  }
}
