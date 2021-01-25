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

  BoardTile({
    this.title,
    this.category,
    this.time_limit,
    this.body,
    this.create_time,
    this.max_person,
  });

  @override
  Widget build(BuildContext context) {
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
                    )));
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 8),
            child: ListTile(
              title: Row(
                children: [
                  const Divider(
                    color: Colors.black,
                    thickness: 5,
                    endIndent: 0,
                  ),
                  Expanded(
                    flex: 85, //필드의 사이즈를 정해줌
                    child: Text(category,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Expanded(
                    flex: 55,
                    child: Text(title,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  Expanded(
                    flex: 80,
                    child: Text(time_limit,
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
