import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:link_ver1/screen/profile.dart';
import 'package:link_ver1/screen/account.dart';
import 'package:link_ver1/screen/nofitication.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          ProfilePic(),
          SizedBox(height: 20),
          ProfileMenu(
            text: "개인정보",
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
            text: "설정",
            icon: "assets/settings.png",
            press: () {},
          ),
          ProfileMenu(
            text: "문의하기",
            icon: "assets/question.png",
            press: () {},
          ),
          ProfileMenu(
            text: "로그아웃",
            icon: "assets/exit.png",
            press: () {},
          ),
        ],
      ),
    );
  }
}
