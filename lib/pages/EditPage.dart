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
import 'board_page.dart';
import '../shared/constants.dart';

class EditPage extends StatefulWidget {
  String title;
  final String category;
  String time_limit;
  String body;
  final Timestamp create_time;
  int max_person;

  final String userName;
  final String groupId;
  final String groupName;

  EditPage({
    this.title,
    this.category,
    this.time_limit,
    this.body,
    this.create_time,
    this.max_person,
    this.groupId,
    this.groupName,
    this.userName,
  });

  @override
  _EditPage createState() => _EditPage();
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

class _EditPage extends State<EditPage> {
  @override
  void initState() {
    super.initState();
    _getUserAuthAndJoinedGroups();
    maxpicture = 0;
    images = [];
    path = [];
  }

  final _formKey = GlobalKey<FormState>();
  CollectionReference groups = FirebaseFirestore.instance.collection('groups');

  final AuthService _auth = AuthService();

  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile image = await imagePicker.getImage(source: ImageSource.gallery);
    if (image != null && maxpicture <= 7) {
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
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text('게시글 수정 페이지'),
              centerTitle: true,
              backgroundColor: Color.fromARGB(250, 247, 162, 144),
              elevation: 0,
            ),
            body: Form(
              key: _formKey,
              child: Container(
                color: Color.fromARGB(250, 247, 162, 144),
                child: ListView(
                  controller: new ScrollController(),
                  padding:
                      EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("게시글 수정",
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
                          decoration: textInputDecoration.copyWith(
                            labelText: '게시글 제목',
                          ),
                          initialValue: widget.title,
                          validator: (val) =>
                              val.length < 2 ? '2글자 이상 입력해주세요' : null,
                          onChanged: (val) {
                            setState(() {
                              widget.title = val;
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
                                    widget.time_limit = val;
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
                                initialValue: widget.max_person.toString(),
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                                decoration: textInputDecoration.copyWith(
                                    labelText: '최대 인원수'),
                                validator: (val) =>
                                    val.length < 1 ? '최대 인원을 입력해주세요' : null,
                                onChanged: (val) {
                                  setState(() {
                                    widget.max_person = int.parse(val);
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
                          initialValue: widget.body,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          decoration: textInputDecoration.copyWith(
                              labelText: '내용 작성', alignLabelWithHint: true),
                          validator: (val) =>
                              val.length < 1 ? '게시할 내용을 입력하세요' : null,
                          onChanged: (val) {
                            setState(() {
                              widget.body = val;
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
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          child: maxpicture != 0
                              ? Container(
                                  width: 400,
                                  height: 350,
                                  child: maxpicture != 0
                                      ? Swiper(
                                          key: UniqueKey(),
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Image.asset(
                                              images[index],
                                            );
                                          },
                                          itemCount: images.length,
                                          autoplayDisableOnInteraction: true,
                                          pagination: SwiperPagination(),
                                          control: SwiperControl(),
                                        )
                                      : null,
                                )
                              : null,
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
                                      Navigator.of(context).pop();
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
                                      // var create_time = new DateTime.now()
                                      //     .millisecondsSinceEpoch;
                                      if (_formKey.currentState.validate()) {
                                        for (String p in path) {
                                          uploadFile(p, _groupName);
                                          print(p);
                                        }
                                        if (widget.time_limit == null) {
                                          widget.time_limit = '없음';
                                        }
                                        print('------------------------');
                                        print(widget.groupId);
                                        print(widget.title);
                                        print(widget.body);
                                        print('------------------------');
                                        groups.doc(widget.groupId).update({
                                          'title': widget.title,
                                          'groupName': widget.title,
                                          'body': widget.body,
                                          'time_limit': widget.time_limit,
                                          'max_person': widget.max_person,
                                          'category': widget.category,
                                        }).then((value) {
                                          print('updated');
                                          Navigator.of(context).pop();
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
