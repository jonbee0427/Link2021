import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:link_ver1/pages/home.dart';

import 'package:link_ver1/screen/profilePic.dart';
import 'package:link_ver1/screen/passwordChange.dart';
import 'package:link_ver1/screen/question.dart';
import 'package:link_ver1/pages/authenticate_page.dart';
import 'package:link_ver1/services/auth_service.dart';

import 'myBoard.dart';

class ProfileMain extends StatefulWidget {
  final String userName;
  ProfileMain({this.userName});
  @override
  _ProfileMainState createState() => _ProfileMainState();
}

class _ProfileMainState extends State<ProfileMain> {
  bool enabled = true;
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: <Widget>[
            ProfilePic(),
            SizedBox(height: 30),
            Text('안녕하세요 :)', style: TextStyle(fontSize: 17.0)),
            SizedBox(height: 10),
            Text(widget.userName + ' 님',
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold)),
            SizedBox(height: 30),
            ListTile(
              leading: Icon(
                Icons.list,
                color: Color.fromARGB(250, 247, 162, 144),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('내가 쓴 글'),
                  Icon(Icons.arrow_forward_ios),
                ],
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => myBoard()));
              },
            ),
            SizedBox(height: 30),
            ListTile(
              leading: Icon(
                Icons.build,
                color: Color.fromARGB(250, 247, 162, 144),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('비밀번호 재설정'),
                  Icon(Icons.arrow_forward_ios),
                ],
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PasswordChangeScreen()));
              },
            ),
            SizedBox(height: 30),
            ListTile(
              leading: Icon(
                Icons.settings,
                color: Color.fromARGB(250, 247, 162, 144),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('알림'),
                  Switch(
                    value: enabled,
                    onChanged: (value) {
                      setState(() {
                        enabled = value;
                      });
                    },
                    activeColor: Colors.red[200],
                    activeTrackColor: Colors.redAccent[200],
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            ListTile(
              leading: Icon(
                Icons.help_outline,
                color: Color.fromARGB(250, 247, 162, 144),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('문의하기'),
                  Icon(Icons.arrow_forward_ios),
                ],
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("문의하기"),
                      content: Container(
                          child: Text(
                              "HandongLink@gmail.com로 문의 메일을 보내주시면 성심성의껏 답변해 드리겠습니다:)")),
                      actions: <Widget>[
                        FlatButton(
                          child: Text(
                            "확인",
                            style: TextStyle(
                                color: Color.fromARGB(250, 247, 162, 144)),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            SizedBox(height: 30),
            ListTile(
              leading: Icon(
                Icons.close,
                color: Color.fromARGB(250, 247, 162, 144),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('로그아웃'),
                  Icon(Icons.arrow_forward_ios),
                ],
              ),
              onTap: () async {
                await _auth.signOut();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => AuthenticatePage()),
                    (Route<dynamic> route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }
}
