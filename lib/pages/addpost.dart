import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../shared/constants.dart';

class Post extends StatefulWidget {
  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  final _formKey = GlobalKey<FormState>();
  CollectionReference writing =
      FirebaseFirestore.instance.collection('writing');
  String title;
  String body, datetime;
  int max_person;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
      key: _formKey,
      child: Container(
        color: Color.fromARGB(250, 247, 162, 144),
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
          children: <Widget>[
            Column(
              // mainAxisAlignment: MainAxisAlignment.center,
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
                  decoration: textInputDecoration.copyWith(labelText: '게시글 제목'),
                  validator: (val) => val.length < 2 ? '2글자 이상 입력해주세요' : null,
                  onChanged: (val) {
                    setState(() {
                      title = val;
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
                        decoration:
                            textInputDecoration.copyWith(labelText: '최대 인원수'),
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
                  validator: (val) => val.length < 1 ? '게시할 내용을 입력하세요' : null,
                  onChanged: (val) {
                    setState(() {
                      body = val;
                    });
                  },
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
                                borderRadius: BorderRadius.circular(30.0)),
                            child: Text('작성 취소',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16.0)),
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
                                borderRadius: BorderRadius.circular(30.0)),
                            child: Text('작성 완료',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16.0)),
                            onPressed: () {
                              var create_time = new DateTime.now();
                              if (_formKey.currentState.validate()) {
                                writing
                                    .add(
                                      {
                                        'title': title,
                                        'body': body,
                                        'time_limit': datetime,
                                        'max_person': max_person,
                                        'create_time': create_time
                                      },
                                    )
                                    .then((value) => print('writing added'))
                                    .catchError(
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
    ));
  }
}
