import 'dart:io';

import 'package:flutter/material.dart';
import 'body.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:link_ver1/helper/helper_functions.dart';
import 'package:link_ver1/services/auth_service.dart';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

//profile screen
class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _auth = AuthService();
  User _user;
  String _userName = '';

  @override
  void initState() {
    super.initState();
    _getUserAuthAndJoinedGroups();
  }

  _getUserAuthAndJoinedGroups() async {
    _user = await FirebaseAuth.instance.currentUser;
    await HelperFunctions.getUserNameSharedPreference().then((value) {
      setState(() {
        _userName = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(
        userName: _userName,
      ),
    );
  }
}
//profile screen

//profile menu
const kPrimaryColor = Color(0xFFFF7643);

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    Key key,
    @required this.text,
    @required this.icon,
    this.press,
    this.value,
  }) : super(key: key);

  final String text, icon;
  final VoidCallback press;
  final bool value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: FlatButton(
        padding: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Color(0xFFF5F6F9),
        onPressed: press,
        child: Row(
          children: [
            Image.asset(
              icon,
              color: kPrimaryColor,
              width: 22,
            ),
            SizedBox(width: 20),
            Expanded(child: Text(text)),
            Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }
}
//profile menu

//profile pic

class ProfilePic extends StatefulWidget {
  @override
  _ProfilePicState createState() => _ProfilePicState();
  const ProfilePic({
    Key key,
  }) : super(key: key);
}

class _ProfilePicState extends State<ProfilePic> {
  File _imageFile;

  Future getImage() async {
    final image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        overflow: Overflow.visible,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage("assets/user.png"),
            backgroundColor: Colors.white,
          ),
          Positioned(
            right: -16,
            bottom: 0,
            child: SizedBox(
              height: 46,
              width: 46,
              child: FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                  side: BorderSide(color: Colors.white),
                ),
                color: Color(0xFFF5F6F9),
                onPressed: () {
                  getImage();
                },
                child: Image.asset("assets/camera.png"),
              ),
            ),
          )
        ],
      ),
    );
  }
}
//profile pic
