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

class PostStudyTogether extends StatefulWidget {
  @override
  _PostStudyTogether createState() => _PostStudyTogether();
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

class _PostStudyTogether extends State<PostStudyTogether> {
  @override
  void initState() {
    super.initState();
    _getUserAuthAndJoinedGroups();
    maxpicture = 0;
    images = [];
    path = [];
    usingtimepicker = true;
  }

  final _formKey = GlobalKey<FormState>();
  CollectionReference groups = FirebaseFirestore.instance.collection('groups');
  String title;
  String body, datetime;
  int max_person;
  String _category;
  String category = '스터디';
  final AuthService _auth = AuthService();

  Color priority = Color.fromARGB(250, 247, 162, 144);

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

  @override
  Widget build(BuildContext context) {
    DateTime _selectedDateTime = DateTime.now();

    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text('스터디 글 작성'),
              centerTitle: true,
              backgroundColor: Color.fromARGB(250, 247, 162, 144),
              elevation: 05,
            ),
            body: Form(
              key: _formKey,
              child: Container(
                color: Colors.white,
                child: ListView(
                  controller: new ScrollController(),
                  padding:
                      EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
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
                        // Text("마감시간",
                        //     style: TextStyle(
                        //         color: Colors.black,
                        //         fontSize: 15.0,
                        //         fontWeight: FontWeight.bold)),
                        // SizedBox(
                        //   height: 10,
                        // ),
                        Row(
                          children: [
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
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              '마감시간을 사용한다',
                              style: TextStyle(
                                  color: Colors.black,
                                  letterSpacing: 1.0,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            Checkbox(
                              value: usingtimepicker, //처음엔 false
                              activeColor: Color.fromARGB(250, 247, 162, 144),
                              onChanged: (value) {
                                //value가 false -> 클릭하면 true로 변경됨(두개 중 하나니까)
                                setState(() {
                                  usingtimepicker = value; //true가 들어감.
                                });
                              },
                            ),
                            // SizedBox(
                            //   width: 30,
                            // ),
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
                          hintText: '선택하지 않아도 됩니다.',
                          filled: false,
                          value: _category,
                          onSaved: (value) {
                            setState(() {
                              _category = value;
                            });
                          },
                          onChanged: (value) {
                            setState(() {
                              _category = value;
                            });
                          },
                          dataSource: [
                            {
                              "display": "한동대 강의",
                              "value": "한동대 강의",
                            },
                            {
                              "display": "공모전",
                              "value": "공모전",
                            },
                            {
                              "display": "자격증",
                              "value": "자격증",
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
                              color: Color.fromARGB(250, 247, 162, 144),
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
                                          pagination: new SwiperPagination(
                                            alignment: Alignment.bottomCenter,
                                            builder:
                                                new DotSwiperPaginationBuilder(
                                                    color: Colors.grey,
                                                    activeColor: priority),
                                          ),
                                          control: new SwiperControl(
                                            color: priority,
                                          ),
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
                                    color: Color.fromARGB(250, 247, 162, 144),
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
                                    color: Color.fromARGB(250, 247, 162, 144),
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
                                        print(usingtimepicker.toString());
                                        if (usingtimepicker == false ||
                                            timeiscorrect == true) {
                                          if (_category != null) {
                                            if (datetime == null) {
                                              datetime = '시간 없음';
                                            }
                                            print(datetime);
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
                                                      _category,
                                                      category,
                                                      create_time_s,
                                                      path);
                                            });

                                            Navigator.of(context).pop();

                                            // } else {
                                            //   Toast.show(
                                            //       '마감시간을 입력해주세요.', context,
                                            //       duration: Toast.LENGTH_LONG,
                                            //       gravity: Toast.BOTTOM);
                                            // }
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
