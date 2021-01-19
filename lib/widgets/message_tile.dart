import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageTile extends StatelessWidget {
  final String message;
  final String sender;
  final bool sentByMe;
  final Timestamp now;
  final String type;

  MessageTile({this.message, this.sender, this.sentByMe, this.now, this.type});

  @override
  Widget build(BuildContext context) {
    //Date format
    final form = new DateFormat().add_jm(); //12 hour format
    //final form = new DateFormat().add_Hm(); //24 hour format

    return Container(
      padding: EdgeInsets.only(
          top: 4, bottom: 4, left: sentByMe ? 0 : 10, right: sentByMe ? 10 : 0),
      child: sentByMe
          ? Row(
              //내가 보낸 msg - 오른쪽 정렬 & Customization
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                //채팅 시간 출력 text
                Text(
                  form.format(now.toDate()),
                ),
                //채팅 말풍선
                Container(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.60),
                  margin: EdgeInsets.only(left: 5),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Color.fromARGB(50, 247, 162, 144),
                            spreadRadius: 3,
                            blurRadius: 3)
                      ],
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(23),
                          bottomRight: Radius.circular(23),
                          bottomLeft: Radius.circular(23)),
                      color: Colors.white,
                      border: Border.all(
                          color: Color.fromARGB(250, 247, 162, 144))),
                  //메세지 내용 출력
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _buildContent(),
                    ],
                  ),
                ),
              ],
            )
          : Row(
              //다른 사람이 보낸 msg - 왼쪽 정렬 & Customization
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                //유저 프로필 사진
                CircleAvatar(
                  backgroundColor: Color.fromARGB(255, 247, 162, 144),
                  radius: 25,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5),
                    //유저 학번
                    Text(sender.toUpperCase(),
                        style: TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            letterSpacing: -0.5)),
                    //채팅 말풍선
                    Container(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.50),
                      margin: EdgeInsets.only(top: 5, left: 5, right: 5),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromARGB(50, 247, 162, 144),
                                spreadRadius: 3,
                                blurRadius: 3)
                          ],
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(23),
                              bottomLeft: Radius.circular(23),
                              bottomRight: Radius.circular(23)),
                          color: Color.fromARGB(150, 247, 162, 144),
                          border: Border.all(
                              color: Color.fromARGB(250, 247, 162, 144))),
                      //메세지 내용 출력
                      child: Column(
                        children: <Widget>[
                          _buildContent(),
                        ],
                      ),
                    ),
                  ],
                ),
                //채팅 시간 출력 text
                Text(
                  form.format(now.toDate()),
                )
              ],
            ),
    );
  }

  Widget _buildContent() {
    if (type == 'image') {
      return Image.network(message);
    } else {
      return Text(message,
          textAlign: TextAlign.start,
          style: TextStyle(
              fontSize: 15.0, color: sentByMe ? Colors.black : Colors.white));
    }
  }
}
