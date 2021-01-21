import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageTile extends StatelessWidget {
  final String message;
  final String sender;
  final bool sentByMe;
  final Timestamp now;
  final String type;
  final String profilePic;

  MessageTile(
      {this.message,
      this.sender,
      this.sentByMe,
      this.now,
      this.type,
      this.profilePic});

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    //Date format
    final form = new DateFormat().add_jm(); //12 hour format

    //텍스트 또는 사진이 아니면 유저가 채팅방을 나갔음을 출력
    if (type == 'text' || type == 'image') {
      return Container(
        padding: EdgeInsets.only(
            top: 5,
            bottom: 5,
            left: sentByMe ? 0 : 10,
            right: sentByMe ? 10 : 0),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //유저 프로필 사진
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage("assets/user.png"),
                    radius: 25,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 5),
                      //유저 학번
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Text(sender.toUpperCase(),
                            style: TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                letterSpacing: -0.5)),
                      ),
                      //채팅 말풍선
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.50),
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
                          //채팅 시간 출력 text
                          Text(
                            form.format(now.toDate()),
                          )
=======
    final form = new DateFormat('Hm');
    if (type == 'text' || type == 'image') {
      return Column(
        children: [
          Container(
            padding: EdgeInsets.only(
                top: 10,
                bottom: 5,
                left: sentByMe ? 0 : 10,
                right: sentByMe ? 10 : 0),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      //유저 프로필 사진
                      profilePic == null || profilePic == ""?
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage: AssetImage("assets/user.png"),
                        radius: 25,
                      ) : CircleAvatar(
                        backgroundImage: NetworkImage(profilePic),
                        radius: 25,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 5),
                          //유저 학번
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: Text(sender.toUpperCase(),
                                style: TextStyle(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    letterSpacing: -0.5)),
                          ),
                          //채팅 말풍선
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width *
                                            0.50),
                                margin:
                                    EdgeInsets.only(top: 5, left: 5, right: 5),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          color:
                                              Color.fromARGB(50, 247, 162, 144),
                                          spreadRadius: 3,
                                          blurRadius: 3)
                                    ],
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(23),
                                        bottomLeft: Radius.circular(23),
                                        bottomRight: Radius.circular(23)),
                                    color: Color.fromARGB(150, 247, 162, 144),
                                    border: Border.all(
                                        color: Color.fromARGB(
                                            250, 247, 162, 144))),
                                //메세지 내용 출력
                                child: Column(
                                  children: <Widget>[
                                    _buildContent(),
                                  ],
                                ),
                              ),
                              //채팅 시간 출력 text
                              Text(
                                form.format(now.toDate()),
                              )
                            ],
                          ),
>>>>>>> abf7a74a236e346d5c807d9892e3e803dd171e39
                        ],
                      ),
                    ],
                  ),
<<<<<<< HEAD
                ],
              ),
=======
          ),
        ],
>>>>>>> abf7a74a236e346d5c807d9892e3e803dd171e39
      );
    } else {
      return Container(
        margin: EdgeInsets.fromLTRB(100, 20, 100, 20),
        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.grey, borderRadius: BorderRadius.circular(20)),
        child: Text(
          message,
          style: TextStyle(
            color: Colors.white,
            backgroundColor: Colors.grey,
          ),
        ),
      );
    }
<<<<<<< HEAD
=======
    //Date format
>>>>>>> abf7a74a236e346d5c807d9892e3e803dd171e39
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
