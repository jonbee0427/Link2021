import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:link_ver1/pages/board_page.dart';

class BoardTile extends StatelessWidget {
  final String title;
  final String category;
  final String time_limit;
  final String body;
  final Timestamp create_time;
  final int max_person;
  final int current_person;
  final String userName;
  final String groupId;
  final String groupName;
  final String uid;
  final Widget groupMembers;
  final String profilePic;
  final int deletePermit;

  BoardTile({
    this.title,
    this.category,
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
    this.deletePermit
  });

  @override
  Widget build(BuildContext context) {
    //print(groupId);
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BoardPage(
                      title: title,
                      category: category,
                      time_limit: time_limit,
                      body: body,
                      create_time: create_time,
                      max_person: max_person,
                      current_person: current_person,
                      groupId: groupId,
                      groupMembers: groupMembers,
                      groupName: groupName,
                      userName: userName,
                      uid: uid,
                  profilePic: profilePic,
                  deletePermit: deletePermit,
                    )));
      },
      child: Column(
        children: [
          Container(
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: category == null || category == ""
                              ? Text('Nothing')
                              : Text(category, style: TextStyle(fontSize: 14)),
                        ),
                        Container(
                          child: title == null || title == ""
                              ? Text(
                                  'nothing',
                                  overflow: TextOverflow.ellipsis,
                                )
                              : Container(
                                  constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.6),
                                  child: Text(
                                    title,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    /*
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent)), */
                    child: SizedBox(
                      width: 50,
                    ),
                  ),
                  Container(
                    child: time_limit == null || time_limit == ""
                        ? Text('시간없음')
                        : Text(time_limit,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
