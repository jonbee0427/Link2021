import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:toast/toast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:link_ver1/helper/helper_functions.dart';
import 'package:link_ver1/services/auth_service.dart';
import 'package:link_ver1/services/database_service.dart';
import 'package:link_ver1/services/database_service.dart';
import 'message.dart';
/*
1. timestamp 완료
2.0 사진 업로드 갯수 제한 구현 완료
2.1 사진 업로드 할때 생기는 문제 ???
3. 게시글 작성시 업로드되는 사진들을 하나의 폴더에 넣기  완료 

*/
// import 'package:day_night_time_picker/day_night_time_picker.dart';
import '../shared/constants.dart';

class PostBuyTogether extends StatefulWidget {
  @override
  _PostBuyTogether createState() => _PostBuyTogether();
}

List<String> images = [];
List<String> path = [];
User _user;
String _groupName;
String _userName = '';
String _email = '';
Stream _groups;
CollectionReference chats;
int maxpicture = 0;

class _PostBuyTogether extends State<PostBuyTogether> {
  @override
  void initState() {
    super.initState();
    _getUserAuthAndJoinedGroups();
    maxpicture = 0;
    images = [];
  }

  final _formKey = GlobalKey<FormState>();
  CollectionReference groups = FirebaseFirestore.instance.collection('groups');
  String title;
  String body, datetime;
  int max_person;
  final AuthService _auth = AuthService();

  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile image = await imagePicker.getImage(source: ImageSource.gallery);
    if (image != null && maxpicture <= 3) {
      setState(() {
        path.add(image.path);
        images.add(image.path);
        maxpicture++;
      });
      //uploadFile(path);
    } else {
      Fluttertoast.showToast(msg: 'no more images');
      print('no more picture');
    }
  }

  Future uploadFile(String path, String groupname) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference =
        FirebaseStorage.instance.ref().child('$groupname/' + fileName);
    UploadTask uploadTask = reference.putFile(File(path));
    TaskSnapshot taskSnapshot = await uploadTask;
    taskSnapshot.ref.getDownloadURL().then((downloadURL) {
      setState(() {
        //_sendMessage('image', path: downloadURL);
      });
    }, onError: (err) {
      Fluttertoast.showToast(msg: 'This File is not an image');
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime _selectedDateTime = DateTime.now();

    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text('공동 구매 글 작성'),
              centerTitle: true,
              backgroundColor: Color.fromARGB(250, 247, 162, 144),
              elevation: 0,
            ),
            body: Form(
              key: _formKey,
              child: Container(
                color: Color.fromARGB(250, 247, 162, 144),
                child: ListView(
                  padding:
                      EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("게시글 작성",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          cursorColor: Colors.black,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          maxLength: 50,
                          decoration:
                              textInputDecoration.copyWith(labelText: '게시글 제목'),
                          validator: (val) =>
                              val.length < 2 ? '2글자 이상 입력해주세요' : null,
                          onChanged: (val) {
                            setState(() {
                              title = val;
                              _groupName = val;
                            });
                          },
                        ),
                        Text("마감시간",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Flexible(
                              flex: 4,
                              child: DateTimePicker(
                                decoration: textInputDecoration,
                                type: DateTimePickerType.dateTimeSeparate,
                                dateMask: 'd MMM, yyyy',
                                initialValue: DateTime.now().toString(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                                // icon: Icon(Icons.event),
                                dateLabelText: 'Date',
                                timeLabelText: "Hour",
                                selectableDayPredicate: (date) {
                                  // Disable weekend days to select from the calendar
                                  // if (date.weekday == 6 || date.weekday == 7) {
                                  //   return false;
                                  // }
                                  return true;
                                },
                                onChanged: (val) {
                                  setState(() {
                                    datetime = val;
                                    print('1');
                                  });
                                },
                                validator: (val) {
                                  print('2');
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              flex: 2,
                              child: TextFormField(
                                cursorColor: Colors.black,
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                                decoration: textInputDecoration.copyWith(
                                    labelText: '최대 인원수'),
                                validator: (val) =>
                                    val.length < 1 ? '최대 인원을 입력해주세요' : null,
                                onChanged: (val) {
                                  setState(() {
                                    max_person = int.parse(val);
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          cursorColor: Colors.black,
                          maxLines: 20,
                          minLines: 15,
                          maxLength: 1000,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          decoration: textInputDecoration.copyWith(
                              labelText: '내용 작성', alignLabelWithHint: true),
                          validator: (val) =>
                              val.length < 1 ? '게시할 내용을 입력하세요' : null,
                          onChanged: (val) {
                            setState(() {
                              body = val;
                            });
                          },
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 50.0,
                          child: RaisedButton(
                              elevation: 0.0,
                              color: Colors.blueAccent[200],
                              // Color.fromARGB(300, 247, 162, 144),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0)),
                              child: Text('이미지 업로드',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16.0)),
                              onPressed: () {
                                print('이미지 업로드 시작!');
                                getImage();
                              }),
                        ),
                        Container(
                          width: 400,
                          height: 300,
                          child: Swiper(
                            itemBuilder: (BuildContext context, int index) {
                              return new Image.asset(
                                images[index],
                              );
                            },
                            itemCount: images.length,
                            autoplayDisableOnInteraction: true,
                            pagination: SwiperPagination(),
                            control: SwiperControl(),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: SizedBox(
                                width: double.infinity,
                                height: 50.0,
                                child: RaisedButton(
                                    elevation: 0.0,
                                    color: Colors.pink[300],
                                    // Color.fromARGB(300, 247, 162, 144),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0)),
                                    child: Text('작성 취소',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0)),
                                    onPressed: () {
                                      print('글 작성 취소!');
                                    }),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              child: SizedBox(
                                width: double.infinity,
                                height: 50.0,
                                child: RaisedButton(
                                    elevation: 0.0,
                                    color: Colors.pink[300],
                                    // Color.fromARGB(300, 247, 162, 144),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0)),
                                    child: Text('작성 완료',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0)),
                                    onPressed: () async {
                                      var create_time = new DateTime.now()
                                          .millisecondsSinceEpoch;
                                      if (_formKey.currentState.validate()) {
                                        await HelperFunctions
                                                .getUserNameSharedPreference()
                                            .then((val) {
                                          DatabaseService(uid: _user.uid)
                                              .createGroup(val, _groupName);
                                        });
                                        for (String p in path) {
                                          uploadFile(p, _groupName);
                                        }
                                        groups.add(
                                          {
                                            'title': title,
                                            'body': body,
                                            'time_limit': datetime,
                                            'max_person': max_person,
                                            'create_time': create_time,
                                            'category': '공동 구매'
                                          },
                                        ).then((value) {
                                          print('writing added');
                                          setState(() {
                                            images = [];
                                          });
                                          Navigator.of(context).pop();
                                        }).catchError(
                                            (value) => print('failed to add'));
                                      }
                                    }),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )));
  }

  _getUserAuthAndJoinedGroups() async {
    _user = await FirebaseAuth.instance.currentUser;
    await HelperFunctions.getUserNameSharedPreference().then((value) {
      setState(() {
        _userName = value;
      });
    });
    DatabaseService(uid: _user.uid).getUserGroups().then((snapshots) {
      // print(snapshots);
      setState(() {
        _groups = snapshots;
      });
    });
    await HelperFunctions.getUserEmailSharedPreference().then((value) {
      setState(() {
        _email = value;
      });
    });

    chats = await FirebaseFirestore.instance.collection('groups');
  }
}
