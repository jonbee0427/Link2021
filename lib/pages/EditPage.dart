import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
// import 'package:fluttertoast/fluttertoast.dart';
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
List<dynamic> members;
User _user;
String _groupName;
String _category;
String _userName = '';
String _email = '';
Stream _groups;
CollectionReference chats;
int maxpicture = 0;
bool usingtimepicker = false;
bool timeiscorrect = false;

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
      Toast.show('no more images', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
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
      Toast.show('이 파일은 사진이 아닙니다.', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
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
              elevation: 10,
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
                        Row(
                          children: [
                            Flexible(
                              flex: 2,
                              child: TextFormField(
                                cursorColor: Colors.black,
                                initialValue: '${widget.max_person}',
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
                                    widget.time_limit = val;
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
                              "display": "운동",
                              "value": "운동",
                            },
                            {
                              "display": "보드게임",
                              "value": "보드게임",
                            },
                            {
                              "display": "게임",
                              "value": "게임",
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
                                        if (usingtimepicker =
                                            true || timeiscorrect == true) {
                                          if (_category != null) {
                                            if (widget.time_limit == null) {
                                              widget.time_limit = '시간 없음';
                                            }
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
                                            print(widget.max_person);
                                            print('------------------------');
                                            groups.doc(widget.groupId).update({
                                              'title': widget.title,
                                              'groupName': widget.title,
                                              'body': widget.body,
                                              'time_limit': widget.time_limit,
                                              'max_person': widget.max_person,
                                              'category': widget.category,
                                              'subcategory': _category,
                                            }).then((value) {
                                              members.forEach((element) {
                                                String membersId =
                                                    _destructureId(element);
                                                DatabaseService(uid: membersId)
                                                    .updateGroupName(
                                                        membersId,
                                                        widget.title,
                                                        widget.groupId);
                                              });

                                              print('updated');
                                              Navigator.of(context).pop();
                                              Navigator.of(context).pop();
                                            }).catchError((value) =>
                                                print('failed to add'));
                                            //사용자들을 가져온다.
                                            //그리고 그 사용자들의 uid를 추출한다.
                                            //해당 사용자의 document로 간 다음.
                                            //데이터추출 후에 해당 필드에 맞는 값을 발견한다면.
                                            //그 필드만 업데이트 하는것인데.
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
                                          usingtimepicker = false;
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

  String _destructureId(String res) {
    // print(res.substring(0, res.indexOf('_')));
    return res.substring(0, res.indexOf('_'));
  }

  String _destructureName(String res) {
    // print(res.substring(res.indexOf('_') + 1));
    return res.substring(res.indexOf('_') + 1);
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
    await chats.doc(widget.groupId).get().then((value) {
      members = value.get('members');
    });
  }
}
