import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:link_ver1/helper/helper_functions.dart';
import 'package:link_ver1/pages/home_page.dart';
import 'package:link_ver1/pages/verificationPage.dart';
import 'package:link_ver1/services/auth_service.dart';
import 'package:link_ver1/services/database_service.dart';
import 'package:link_ver1/shared/constants.dart';
import 'package:link_ver1/shared/loading.dart';
import 'package:toast/toast.dart';

class RegisterPage extends StatefulWidget {
  final Function toggleView;
  RegisterPage({this.toggleView});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

void initializeFlutterFire() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // text field state
  String fullName = '';
  String email = '';
  String password = '';
  String error = '';
  var _controller = TextEditingController();

  _onRegister() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      print('FullName : ' + fullName + 'Email :' + email);
      await _auth
          .registerWithEmailAndPassword(fullName, email, password)
          .then((result) async {
        if (result != null) {
          //User user = FirebaseAuth.instance.currentUser;
          // await user.sendEmailVerification();
          await HelperFunctions.saveUserLoggedInSharedPreference(true);
          await HelperFunctions.saveUserEmailSharedPreference(email);
          await HelperFunctions.saveUserNameSharedPreference(fullName);

          print("Registered");
          await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
            print("Logged in: $value");
          });
          await HelperFunctions.getUserEmailSharedPreference().then((value) {
            print("Email: $value");
          });
          await HelperFunctions.getUserNameSharedPreference().then((value) {
            print("Full Name: $value");
          });

          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => VerificationPage()));
        } else {
          setState(() {
            error = 'Error while registering the user!';
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
            body: Form(
                key: _formKey,
                child: Container(
                  color: Colors.blue[100],
                  child: ListView(
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 80.0),
                    children: <Widget>[
                      Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text("H-links",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 45.0,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(height: 30.0),
                          Text("Register",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 25.0)),
                          SizedBox(height: 20.0),

                          // TextFormField(
                          //   style: TextStyle(color: Colors.white),
                          //   decoration: textInputDecoration.copyWith(
                          //       labelText: 'Full Name'),
                          //   onChanged: (val) {
                          //     setState(() {
                          //       fullName = val;
                          //     });
                          //   },
                          // ),
                          // SizedBox(height: 15.0),
                          TextFormField(
                            style: TextStyle(color: Colors.white),
                            decoration: textInputDecoration.copyWith(
                              labelText: 'student id',
                            ),

                            // validator: (val) {
                            //   return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ? null : "Please enter a valid email";
                            // },
                            onChanged: (val) {
                              setState(() {
                                email = val + '@handong.edu';
                                fullName = val;
                              });
                            },
                          ),
                          SizedBox(
                            width: 10,
                          ),

                          // SizedBox(height: 15.0),

                          SizedBox(height: 15.0),
                          TextFormField(
                            style: TextStyle(color: Colors.white),
                            decoration: textInputDecoration.copyWith(
                                labelText: 'Password'),
                            //validator: (val) => val.length < 6 ? 'Password not strong enough' : null,
                            obscureText: true,
                            onChanged: (val) {
                              setState(() {
                                password = val;
                              });
                            },
                          ),
                          SizedBox(height: 20.0),
                          SizedBox(
                            width: double.infinity,
                            height: 50.0,
                            child: RaisedButton(
                                elevation: 0.0,
                                color: Colors.blueAccent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0)),
                                child: Text('Register',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16.0)),
                                onPressed: () async {
                                  _onRegister();
                                }),
                          ),
                          SizedBox(height: 10.0),
                          SizedBox(
                            width: double.infinity,
                            height: 50.0,
                            child: RaisedButton(
                                elevation: 0.0,
                                color: Colors.blue,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0)),
                                child: Text('sign in',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16.0)),
                                onPressed: () {
                                  print('register started!');
                                  Navigator.of(context).pop(MaterialPageRoute(
                                      builder: (context) => RegisterPage()));
                                }),
                          ),
                          SizedBox(height: 10.0),

                          Text.rich(
                            TextSpan(
                              text: "Do you already have an account? ",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 14.0),
                            ),
                          ),
                          Text(error,
                              style:
                                  TextStyle(color: Colors.red, fontSize: 14.0)),
                        ],
                      ),
                    ],
                  ),
                )),
          );
  }
}
