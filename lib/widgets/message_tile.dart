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
      child: Row(
        // mainAxisAlignment:
        //     sentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          //채팅 시간 출력 text
          Text(
            form.format(now.toDate()),
          ),
          //채팅 말풍선
          Container(
            margin:
                sentByMe ? EdgeInsets.only(left: 5) : EdgeInsets.only(right: 5),
            padding: EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
            decoration: BoxDecoration(
                borderRadius: sentByMe
                    ? BorderRadius.only(
                        topLeft: Radius.circular(23),
                        topRight: Radius.circular(23),
                        bottomLeft: Radius.circular(23))
                    : BorderRadius.only(
                        topLeft: Radius.circular(23),
                        topRight: Radius.circular(23),
                        bottomRight: Radius.circular(23)),
                color: sentByMe
                    ? Colors.white
                    : Color.fromARGB(250, 247, 162, 144),
                border: Border.all(color: Color.fromARGB(250, 247, 162, 144))),

            //메세지 내용 출력
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(sender.toUpperCase(),
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        letterSpacing: -0.5)),
                SizedBox(height: 7.0),
                _buildContent(),
              ],
            ),
          ),
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
