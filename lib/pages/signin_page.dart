import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:link_ver1/helper/helper_functions.dart';
import 'package:link_ver1/pages/ResetPasswordPage.dart';
import 'package:link_ver1/pages/home_page.dart';
import 'package:link_ver1/pages/register_page.dart';
import 'package:link_ver1/pages/verificationPage.dart';
import 'package:link_ver1/services/auth_service.dart';
import 'package:link_ver1/services/database_service.dart';
import 'package:link_ver1/shared/constants.dart';
import 'package:link_ver1/shared/loading.dart';
import 'package:toast/toast.dart';

class SignInPage extends StatefulWidget {
  final Function toggleView;
  SignInPage({this.toggleView});

  @override
  _SignInPageState createState() {
    initializeFlutterFire();
    return _SignInPageState();
  }
}

void initializeFlutterFire() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

class _SignInPageState extends State<SignInPage> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // text field state
  String email = '';
  String password = '';
  String error = '';

  _onSignIn() async {
    if (_formKey.currentState.validate()) {
      print('Validate!');

      setState(() {
        _isLoading = true;
      });

      await _auth
          .signInWithEmailAndPassword(email, password)
          .then((result) async {
        if (result != null) {
          print('in Result!');
          QuerySnapshot userInfoSnapshot =
              await DatabaseService().getUserData(email);

          await HelperFunctions.saveUserLoggedInSharedPreference(true);
          await HelperFunctions.saveUserEmailSharedPreference(email);
          await HelperFunctions.saveUserNameSharedPreference(
              userInfoSnapshot.docs[0].data()['name']);

          print("Signed In");
          await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
            print("Logged in: $value");
          });
          await HelperFunctions.getUserEmailSharedPreference().then((value) {
            print("Email: $value");
          });
          await HelperFunctions.getUserNameSharedPreference().then((value) {
            print("Full Name: $value");
          });
          User users = FirebaseAuth.instance.currentUser;
          if (users.emailVerified) {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => HomePage()));
          } else {
            Toast.show('이메일 인증이 아직 완료되지 않았습니다. 인증페이지로 넘어갑니다.', context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            users.sendEmailVerification();
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => SignInPage()));
          }
        } else {
          print('in ERROR!');

          setState(() {
            error = 'Error signing in!';
            _isLoading = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Color.fromARGB(250, 247, 162, 144),
              elevation: 0,
            ),
            body: Form(
              key: _formKey,
              child: Container(
                color: Color.fromARGB(250, 247, 162, 144),
                child: ListView(
                  padding:
                      EdgeInsets.symmetric(horizontal: 30.0, vertical: 30.0),
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text("H-Link",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 40.0,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 30.0),
                        Text("Sign In",
                            style:
                                TextStyle(color: Colors.white, fontSize: 25.0)),
                        SizedBox(height: 50.0),
                        Row(
                          children: [
                            Flexible(
                              flex: 2,
                              child: Column(
                                children: [
                                  TextFormField(
                                    style: TextStyle(color: Colors.white),
                                    decoration: textInputDecoration.copyWith(
                                        labelText: 'Student ID'),
                                    // validator: (val) {
                                    //   return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ? null : "Please enter a valid email";
                                    // },
                                    onChanged: (val) {
                                      setState(() {
                                        email = val + '@handong.edu';
                                      });
                                    },
                                  ),
                                  SizedBox(height: 15.0),
                                  TextFormField(
                                    style: TextStyle(color: Colors.white),
                                    decoration: textInputDecoration.copyWith(
                                        labelText: 'Password'),
                                    validator: (val) => val.length < 6
                                        ? 'Password not strong enough'
                                        : null,
                                    obscureText: true,
                                    onChanged: (val) {
                                      setState(() {
                                        password = val;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 15.0),
                            Flexible(
                              flex: 1,
                              child: SizedBox(
                                width: double.infinity,
                                height: 100.0,
                                child: RaisedButton(
                                    elevation: 0.0,
                                    color: Colors.pink[300],
                                    // Color.fromARGB(300, 247, 162, 144),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0)),
                                    child: Text('로그인',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0)),
                                    onPressed: () {
                                      print('Signin started!');
                                      _onSignIn();
                                    }),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 40.0),
                        Row(
                          children: [
                            Flexible(
                              child: SizedBox(
                                width: double.infinity,
                                height: 50.0,
                                child: RaisedButton(
                                    elevation: 0.0,
                                    color: Colors.pink[300],
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0)),
                                    child: Text('비밀번호 찾기',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0)),
                                    onPressed: () {
                                      print('비밀번호 찾기 started!');
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ResetPasswordPage()));
                                    }),
                              ),
                            ),
                            SizedBox(width: 10.0),
                            Flexible(
                              child: SizedBox(
                                width: double.infinity,
                                height: 50.0,
                                child: RaisedButton(
                                    elevation: 0.0,
                                    color: Colors.pink[300],
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0)),
                                    child: Text('회원가입',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0)),
                                    onPressed: () {
                                      print('register started!');
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  RegisterPage()));
                                    }),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Text(error,
                            style:
                                TextStyle(color: Colors.red, fontSize: 14.0)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
