import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:link_ver1/pages/board_page.dart';
class BoardTile extends StatelessWidget {
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
  final Widget groupMembers;
  final String profilePic;
  final int deletePermit;
  final String admin;

  BoardTile(
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
      this.admin,});

  @override
  Widget build(BuildContext context) {
     // print(title + "  "  +   category + "  " + subcategory);
     // print(time_limit + "  "  +   body + "  " + create_time.toString());//create_time null
     // print(max_person.toString() + "  "  +   current_person.toString() + "  " + userName);
     // print(userName + "  "  +   groupId + "  " + groupName);
     // print(uid + "  "  +   profilePic + "  " + deletePermit.toString());
     // print(admin + "  "   );//enteringTime null
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BoardPage(
                    title: title,
                    category: category,
                    subcategory: subcategory,
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
                    admin: admin,)));
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
                          child: subcategory == null || subcategory == ""
                              ? Text(category, style: TextStyle(fontSize: 14))
                              : Text(subcategory,
                                  style: TextStyle(fontSize: 14)),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          child: title == null || title == ""
                              ? Text(
                                  '제목 없음',
                                  style: TextStyle(fontSize: 14),
                                  overflow: TextOverflow.ellipsis,
                                )
                              : Container(
                                  constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.6),
                                  child: Text(
                                    title,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                        ),
                        Container(
                          child: body == null || body == ""
                              ? Text(
                                  '내용 없음',
                                  style: TextStyle(fontSize: 14),
                                  overflow: TextOverflow.ellipsis,
                                )
                              : Container(
                                  constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.6),
                                  child: Text(
                                    body,
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 14),
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
                  Column(
                    children: [
                      Container(
                        child: time_limit == null || time_limit == ""
                            ? Text('시간없음')
                            : Text(
                                time_limit,
                              ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: max_person <= current_person
                            ? Text(
                                '인원 마감',
                                style: TextStyle(
                                    color: Colors.redAccent, fontSize: 20),
                              )
                            : SizedBox(),
                      ),
                    ],
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
