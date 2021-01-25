import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';

import 'package:link_ver1/helper/helper_functions.dart';
import 'package:link_ver1/services/auth_service.dart';
import 'package:link_ver1/screen/profileMain.dart';
import 'package:link_ver1/helper/helper_functions.dart';

//사진을 firebase storage에 저장 & 로그인된 사용자 필드값 update
class ProfilePic extends StatefulWidget {
  @override
  _ProfilePicState createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  String imageUrl;
  PickedFile image;
  String profilePic;

  Future uploadPic() async {
    final _storage = FirebaseStorage.instance; //FirebaseStorage의 인스턴스 가져오기
    final _picker = ImagePicker();

    //Select Image
    image = await _picker.getImage(source: ImageSource.gallery);
    String fileName = basename(image.path);
    print('filename is ' + fileName);
    var file = File(image.path);

    if (image != null) {
      var snapshot = await _storage
          .ref() //FirebaseStorage 인스턴스의 ref 가져오기
          .child('Mypage/' + fileName) //경로 지정
          .putFile(file); //putFile 메소드를 이용하여, 실제로 파일 저장하기

      var downloadUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        imageUrl = downloadUrl;
      });

      updateField();
    }
  }

  void updateField() async {
    var firebaseUser = await FirebaseAuth.instance.currentUser;
    firebaseUser.updateProfile(photoURL: imageUrl);
    FirebaseFirestore.instance
        .collection("MyUsers")
        .doc(firebaseUser.uid)
        .update({
      "profilePic": imageUrl.toString(),
    }).then((_) {
      print("success!");
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
            backgroundImage: image ==
                    null //만약 사용자가 로그아웃을 했더라도 마지막에 저장된 프로필 사진으로 자동적으로 보이기 필요.
                ? AssetImage("assets/user.png")
                : FileImage(File(image.path)),
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
                  uploadPic();
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

//현재 사용자 학번을 창에 표시하기 위해 username을 profileMain으로 전달하는 기능
class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AuthService _auth = AuthService();
  var _user;
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
      body: ProfileMain(
        userName: _userName, //pass user name
      ),
    );
  }
}
