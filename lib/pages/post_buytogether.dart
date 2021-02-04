import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:toast/toast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:link_ver1/helper/helper_functions.dart';
import 'package:link_ver1/services/auth_service.dart';
import 'package:link_ver1/services/database_service.dart';
import 'package:link_ver1/services/database_service.dart';
import 'message.dart';
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
bool timeiscorrect = false;
bool usingtimepicker = true;
CollectionReference chats;
int maxpicture = 0;

class _PostBuyTogether extends State<PostBuyTogether> {
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
  String title;
  String body, datetime;
  int max_person;
  String category = '공동 구매';
  String subcategory;
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
      Toast.show('no more images.', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      print('no more picture');
    }
  }

  Future uploadFile(String path, String groupname) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference = FirebaseStorage.instance
        .ref()
        .child('$groupname$_userName/' + fileName);
    UploadTask uploadTask = reference.putFile(File(path));
    TaskSnapshot taskSnapshot = await uploadTask;
    taskSnapshot.ref.getDownloadURL().then((downloadURL) {
      setState(() {
        //_sendMessage('image', path: downloadURL);
      });
    }, onError: (err) {
      Toast.show('the file is not a image.', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
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
              elevation: 05,
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
                          validator: (val) => val.length < 2
                              ? '2글자 이상 입력해주세요'
                              : (val.contains('_')
                                  ? '특수문자 \'_\'를 사용하지 말아주세요.'
                                  : null),
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
                            Checkbox(
                              value: usingtimepicker, //처음엔 false
                              onChanged: (value) {
                                //value가 false -> 클릭하면 true로 변경됨(두개 중 하나니까)
                                setState(() {
                                  usingtimepicker = value; //true가 들어감.
                                });
                              },
                            ),
                            Text(
                              '마감시간을 사용한다',
                              style: TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 1.0,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold),
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
                        usingtimepicker == true
                            ? DateTimePicker(
                                decoration: textInputDecoration,
                                type: DateTimePickerType.dateTimeSeparate,
                                dateMask: 'd MMM, yyyy',
                                //initialValue: DateTime.now().toString(),
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
                                  if (val.compareTo(DateTime.now().toString()) >
                                      0) {
                                    timeiscorrect = true;
                                    print(val
                                        .compareTo(DateTime.now().toString()));
                                  } else
                                    timeiscorrect = false;
                                },
                              )
                            : SizedBox(),
                        SizedBox(
                          height: 10,
                        ),
                        DropDownFormField(
                          titleText: '세부 카테고리',
                          hintText: '선택하세요',
                          value: subcategory,
                          onSaved: (value) {
                            setState(() {
                              subcategory = value;
                            });
                          },
                          onChanged: (value) {
                            setState(() {
                              subcategory = value;
                            });
                          },
                          dataSource: [
                            {
                              "display": "배달 음식",
                              "value": "배달 음식",
                            },
                            {
                              "display": "생필품",
                              "value": "생필품",
                            },
                            {
                              "display": "의류/잡화",
                              "value": "의류/잡화",
                            },
                            {
                              "display": "식품",
                              "value": "식품",
                            },
                            {
                              "display": "기타",
                              "value": "기타",
                            },
                          ],
                          textField: 'display',
                          valueField: 'value',
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
                                      var create_time = new DateTime.now()
                                          .millisecondsSinceEpoch;
                                      var create_time_s = new Timestamp.now();
                                      if (_formKey.currentState.validate()) {
                                        if (usingtimepicker =
                                            false || timeiscorrect == true) {
                                          if (subcategory != null) {
                                            if (datetime != null) {
                                              //datetime = '없음';
                                              await HelperFunctions
                                                      .getUserNameSharedPreference()
                                                  .then((val) {
                                                DatabaseService(uid: _user.uid)
                                                    .createGroup(
                                                        val,
                                                        _groupName,
                                                        title,
                                                        body,
                                                        datetime,
                                                        max_person,
                                                        subcategory,
                                                        category,
                                                        create_time_s);
                                              });
                                              for (String p in path) {
                                                uploadFile(p, _groupName);
                                                print(p);
                                              }
                                              Navigator.of(context).pop();
                                            } else {
                                              Toast.show(
                                                  '마감시간을 입력해주세요.', context,
                                                  duration: Toast.LENGTH_LONG,
                                                  gravity: Toast.BOTTOM);
                                            }
                                          } else {
                                            Toast.show(
                                                '서브 카테고리를 입력해주세요.', context,
                                                duration: Toast.LENGTH_LONG,
                                                gravity: Toast.BOTTOM);
                                          }
                                        } else {
                                          Toast.show(
                                              '마감시간은 현재 시간보다 나중으로 입력해주세요.',
                                              context,
                                              duration: Toast.LENGTH_LONG,
                                              gravity: Toast.BOTTOM);
                                          usingtimepicker = true;
                                        }
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
