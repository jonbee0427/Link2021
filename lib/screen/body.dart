import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:link_ver1/screen/profile.dart';
import 'package:link_ver1/screen/account.dart';
import 'package:link_ver1/screen/nofitication.dart';
import 'package:link_ver1/screen/question.dart';
import 'package:link_ver1/pages/authenticate_page.dart';
import 'package:link_ver1/services/auth_service.dart';

class Body extends StatelessWidget {
  final String userName;
  final AuthService _auth = AuthService();

  Body({this.userName});

  @override
  Widget build(BuildContext context) {
    bool enabled = false;
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: <Widget>[
          ProfilePic(),
          SizedBox(height: 30),
          Text('안녕하세요 :)', style: TextStyle(fontSize: 17.0)),
          SizedBox(height: 10),
          Text(userName + ' 님',
              style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold)),
          SizedBox(height: 30),
          ProfileMenu(
            text: "비밀번호 재설정",
            icon: "assets/account.png",
            press: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AccountScreen()));
            },
          ),
          ProfileMenu(
            text: "알림",
            icon: "assets/notification.png",
            press: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NotiScreen()));
            },
          ),
          ProfileMenu(
            text: "문의하기",
            icon: "assets/question.png",
            press: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => QuestionScreen()));
            },
          ),
          ProfileMenu(
            text: "로그아웃",
            icon: "assets/exit.png",
            press: () async {
              {
                await _auth.signOut();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => AuthenticatePage()),
                    (Route<dynamic> route) => false);
              }
            },
          ),
        ],
      ),
    );
  }
}
