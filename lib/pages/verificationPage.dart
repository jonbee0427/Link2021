import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:link_ver1/pages/signin_page.dart';
import 'package:link_ver1/services/auth_service.dart';
import 'package:link_ver1/shared/constants.dart';
import 'package:toast/toast.dart';

class VerificationPage extends StatefulWidget {
  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  bool _showSignIn = true;

  void _toggleView() {
    setState(() {
      _showSignIn = !_showSignIn;
    });
  }

  bool isVerified;
  final AuthService _auth = AuthService();
  @override
  void initState() {
    super.initState();
    isVerified = FirebaseAuth.instance.currentUser.emailVerified;
  }

  _onVerification() async {
    User user = FirebaseAuth.instance.currentUser;
    // await user.sendEmailVerification();
    Toast.show('회원가입이 성공적으로 되었습니다.\n이메일 인증을 한 후 로그인 하십시오', context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => SignInPage(
              toggleView: _toggleView,
            )));
  }

  bool emailverified = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(250, 247, 162, 144),
        elevation: 0,
      ),
      body: Form(
          child: Container(
        color: Color.fromARGB(250, 247, 162, 144),
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 30.0),
          children: <Widget>[
            Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text("H-link",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 45.0,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 30.0),
                Text("Varification Page",
                    style: TextStyle(color: Colors.white, fontSize: 25.0)),
                SizedBox(height: 120.0),
                Text.rich(
                  TextSpan(
                    text: "send varification email by pressing the button ",
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                ),
                SizedBox(height: 40.0),
                SizedBox(
                  width: double.infinity,
                  height: 50.0,
                  child: RaisedButton(
                      elevation: 0.0,
                      color: Colors.pink[300],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      child: Text('send varification email',
                          style:
                              TextStyle(color: Colors.white, fontSize: 16.0)),
                      onPressed: () {
                        setState(() {
                          User users = FirebaseAuth.instance.currentUser;
                          _onVerification();
                        });
                      }),
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }
}
