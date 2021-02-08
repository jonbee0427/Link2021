// //Stf
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:link_ver1/pages/chat_page.dart';
// class GroupTile extends StatefulWidget {
//
//   final String userName;
//   final String groupId;
//   final String groupName;
//   final String profilePic;
//   Widget recentMsg;
//   final Widget groupMembers;
//   Widget recentTime;
//   final DateTime enteringTime;
//
//   GroupTile(
//       {this.userName,
//         this.groupId,
//         this.groupName,
//         this.recentMsg,
//         this.groupMembers,
//         this.recentTime,
//         this.profilePic,
//         this.enteringTime});
//
//   @override
//   _GroupTileState createState() => _GroupTileState();
// }
//
// class _GroupTileState extends State<GroupTile> {
//   Timestamp recentTimeStamp;
//   DateTime recentTimeCmp;
//   getRecentTime()async{
//     await FirebaseFirestore.instance.collection('groups').doc(widget.groupId).get().then((value)async{
//       recentTimeStamp = await value.data()['recentMessageTime'];
//       recentTimeCmp =await DateTime.fromMicrosecondsSinceEpoch(recentTimeStamp.microsecondsSinceEpoch);
//       //recentTimeCmp = recentTimeStamp.toDate();
//     });
//
//    // recentTimeCmp =  convertDateFromString(recentTimeStamp);
//   }
//
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getRecentTime();
//   }
//
//   DateTime convertDateFromString(String strDate){
//     print("Current Time : " + strDate);
//     return DateTime.parse(strDate);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     print(recentTimeCmp);
//     //convertDateFromString(recentTimeStamp);
//
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => ChatPage(
//                     groupId: widget.groupId,
//                     userName: widget.userName,
//                     groupName: widget.groupName,
//                     groupMembers: widget.groupMembers,
//                     profilePic: widget.profilePic,
//                     enteringTime: widget.enteringTime
//                 )));
//       },
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
//         child: ListTile(
//             leading: CircleAvatar(
//               radius: 30.0,
//               backgroundColor: Color.fromARGB(250, 247, 162, 144),
//               child: Text(widget.groupName.substring(0, 1).toUpperCase(),
//                   textAlign: TextAlign.center,
//                   style: TextStyle(color: Colors.white)),
//             ),
//             title: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: Text(
//                     widget.groupName,
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//                 Container(
//                     padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
//                     child: recentTimeCmp.compareTo(widget.enteringTime) > 0 ?
//                     widget.recentTime : Text('없어영'))
//               ],
//             ),
//             //   subtitle: Text('Join the ' + groupName + ' as ' + userName,
//             // style: TextStyle(fontSize: 13.0)),
//
//             subtitle: recentTimeCmp.compareTo(widget.enteringTime) > 0 ?
//             widget.recentMsg : Text('메시지를 전송해보세요!')),
//       ),
//     );
//   }
// }
//


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:link_ver1/pages/chat_page.dart';

class GroupTile extends StatelessWidget {
  final String userName;
  final String groupId;
  final String groupName;
  final String profilePic;
  final Widget recentMsg;
  final Widget groupMembers;
  final Widget recentTime;
  final DateTime enteringTime;

  GroupTile(
      {this.userName,
        this.groupId,
        this.groupName,
        this.recentMsg,
        this.groupMembers,
        this.recentTime,
        this.profilePic,
        this.enteringTime});
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
                    profilePic: profilePic,
                    enteringTime: enteringTime
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
                Expanded(
                  child: Text(
                    groupName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                    padding: EdgeInsets.fromLTRB(5, 0, 0, 0), child:recentTime)
              ],
            ),
            //   subtitle: Text('Join the ' + groupName + ' as ' + userName,
            // style: TextStyle(fontSize: 13.0)),
            subtitle: recentMsg),
      ),
    );
  }
}
