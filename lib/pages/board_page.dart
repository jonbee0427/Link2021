import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:link_ver1/pages/EditPage.dart';
import 'package:link_ver1/widgets/boardTile.dart';

class BoardPage extends StatefulWidget {
  final String title;
  final String category;
  final String time_limit;
  final String body;
  final Timestamp create_time;
  final int max_person;

  BoardPage({
    this.title,
    this.category,
    this.time_limit,
    this.body,
    this.create_time,
    this.max_person,
  });
  @override
  _BoardPageState createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  Color priority = Color.fromARGB(250, 247, 162, 144);
  void print_test() {
    print(widget.title);
    print(widget.category);
    print(widget.time_limit);
    print(widget.body);
    print(widget.create_time);
    print(widget.max_person);
  }

  @override
  Widget build(BuildContext context) {
    print_test();
    return Scaffold(
      appBar: AppBar(
        title: Text('게시글 상세 정보'),
        centerTitle: true,
        backgroundColor: priority,
        elevation: 10.0,
      ),
      body: Container(
        //카테고리,제목,마감시간 text 컨테이너와 getBoard()가 Column으로 묶여있다
        child: Row(
          children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 30, left: 25),
                    child: Text(
                      '카테고리 : ' + widget.category,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 10, left: 25),
                    child: Text(
                      '제목 : ' + widget.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 10, left: 25),
                    child: Text(
                      '마감시간 : ' + widget.time_limit,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 30, left: 25),
                    padding: EdgeInsets.only(
                        top: 10, left: 15, right: 180, bottom: 300),
                    decoration: BoxDecoration(
                      border: Border.all(color: priority, width: 3),
                      borderRadius: BorderRadius.all(
                        Radius.circular(40),
                      ),
                    ),
                    child: Text(
                      '내용 : ' + widget.body,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    //width: double.infinity,
                    height: 50.0,
                    child: RaisedButton(
                        elevation: 0.0,
                        color: Colors.pink[300],
                        // Color.fromARGB(300, 247, 162, 144),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        child: Text('게시글 수정',
                            style:
                                TextStyle(color: Colors.white, fontSize: 16.0)),
                        onPressed: () {
                          print('글 수정!');
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => EditPage()));
                        }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
