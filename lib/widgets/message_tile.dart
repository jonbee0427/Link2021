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
    final form = new DateFormat('yyyy-MM-dd hh:mm');
    return Container(
      padding: EdgeInsets.only(
        top: 4,
        bottom: 4,
        left: sentByMe ? 0 : 24,
        right: sentByMe ? 24 : 0),
        alignment: sentByMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: sentByMe ? EdgeInsets.only(left: 30) : EdgeInsets.only(right: 30),
          padding: EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
          decoration: BoxDecoration(
          borderRadius: sentByMe ? BorderRadius.only(
            topLeft: Radius.circular(23),
            topRight: Radius.circular(23),
            bottomLeft: Radius.circular(23)
          )
          :
          BorderRadius.only(
            topLeft: Radius.circular(23),
            topRight: Radius.circular(23),
            bottomRight: Radius.circular(23)
          ),
          color: sentByMe ? Colors.white : Color.fromARGB(250, 247, 162, 144),
            border: Border.all(color: Color.fromARGB(250, 247, 162, 144))

        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(sender.toUpperCase(), textAlign: TextAlign.start, style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold, color: Colors.black, letterSpacing: -0.5)),
            SizedBox(height: 7.0),
            _buildContent(),
            Text(form.format(now.toDate())),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(){
    print(type);
    if(type == 'image'){
      return Image.network(message);
    }
    else{
      return Text(message,textAlign: TextAlign.start, style: TextStyle(fontSize: 15.0, color: sentByMe? Colors.black: Colors.white));
    }
  }

}