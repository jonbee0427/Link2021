import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class PasswordChangeScreen extends StatefulWidget {
  String password;

  @override
  _PasswordChangeScreenState createState() => _PasswordChangeScreenState();
}

class _PasswordChangeScreenState extends State<PasswordChangeScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Stream<QuerySnapshot> streamData;

  @override
  void initState() {
    super.initState();
    streamData = firestore.collection('MyUsers').snapshots();
  }

  String value = '';
  String password;
  String email;
  String newpassword;
  //Map data;

  final pwController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildPassword() {
    String labelText;
    if (widget.password == null) {
      labelText = '학번';
    } else {
      labelText = '비밀번호 : ' + widget.password;
    }
    return TextFormField(
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.black),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(250, 247, 162, 144)),
          //borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          //borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
      ),
      keyboardType: TextInputType.visiblePassword,
      maxLength: 16,
      validator: (String value) {
        if (value.isEmpty) {
          return '학번을 입력하세요';
        }

        return null;
      },
      onSaved: (String value) {
        email = value;
        //data['password'] = widget.password;
      },
    );
  }

  Widget _buildPassword2() {
    String textPassword;
    if (widget.password == null) {
      textPassword = '현재 비밀번호';
    } else {
      textPassword = '현재 비밀번호 : ' + widget.password;
    }
    return TextFormField(
      decoration: InputDecoration(
        labelText: textPassword,
        labelStyle: TextStyle(color: Colors.black),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(250, 247, 162, 144)),
          //borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          //borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
      ),
      keyboardType: TextInputType.visiblePassword,
      maxLength: 16,
      validator: (String value) {
        if (value.isEmpty) {
          return '비밀번호를 다시 한번 입력해주세요';
        }

        return null;
      },
      onSaved: (String value) {
        password = value;
        //data['password'] = widget.password;
      },
    );
  }

  Widget _checkPassword() {
    String textPassword;
    if (widget.password == null) {
      textPassword = '새로운 비밀번호';
    } else {
      textPassword = '새로운 비밀번호 : ' + widget.password;
    }
    return TextFormField(
      decoration: InputDecoration(
        labelText: textPassword,
        labelStyle: TextStyle(color: Colors.black),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(250, 247, 162, 144)),
          //borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          //borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
      ),
      maxLength: 16,
      validator: (String value) {
        if (value.isEmpty) {
          return '새로운 비밀번호를 입력하세요';
        }

        return null;
      },
      onSaved: (String value) {
        newpassword = value;
        //data['password'] = widget.password;
      },
    );
  }

  updatePassword(String password, String email, String newPassword) async {
    var firebaseUser = await FirebaseAuth.instance.currentUser;
    EmailAuthCredential credential = EmailAuthProvider.credential(
        email: email + '@handong.edu', password: password);
    await FirebaseAuth.instance.currentUser
        .reauthenticateWithCredential(credential);
    firebaseUser
        .updatePassword(newPassword)
        .then((value) => Navigator.of(context).pop());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('개인정보'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(250, 247, 162, 144),
        elevation: 10.0,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildPassword(),
                _buildPassword2(),
                _checkPassword(),
                SizedBox(height: 80),
                MaterialButton(
                  child: Container(
                    child: Text(
                      '확인',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red[300],
                    ),
                    padding: const EdgeInsets.all(10.0),
                  ),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                    }
                    print(password);
                    updatePassword(password, email, newpassword);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
