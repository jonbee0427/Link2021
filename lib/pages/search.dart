import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Search extends SearchDelegate<String> {
  @override
  String get searchFieldLabel => "검색";

  //검색 창의 상단 appBar 디자인
  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = ThemeData(
        primaryColor: const Color.fromARGB(250, 247, 162, 144),
        primaryIconTheme: IconThemeData(color: Colors.white),
        inputDecorationTheme: InputDecorationTheme(
            hintStyle: TextStyle(
          color: Color.fromARGB(150, 255, 255, 255),
        )),
        cursorColor: Colors.white);
    return theme;
  }

  //검색 창에 있는 상단 오른쪽 appBar에 위치한 검색 단어 삭제 기능
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(
            Icons.clear,
          ),
          onPressed: () {
            query = "";
          })
    ];
  }

  //검색 창에 있는 상단 왼쪽 appBar에 위치한 뒤로 가기 기능
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  //검색 결과 출력 화면 (Enter 입력 후) [게시물 CRUD 구현이 끝나면 상세 페이지로 넘기기]
  @override
  Widget buildResults(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
              child: Text(
            query,
            style: TextStyle(fontSize: 50),
          ))
        ],
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('cities').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        //파이어베이스에 데이터가 없을 경우
        if (!snapshot.hasData) return new Text('검색중...');

        //검색어 입력하기 전
        if (query.isEmpty) return defaultScreen();

        //검색어를 토대로 파이어베이스에서 검색어가 포함되는 데이터들을 확인하여 저장
        final results =
            snapshot.data.docs.where((a) => a['city'].contains(query));

        //검색어와 일치하는 데이터가 없다면 초기 화면, 있다면 상세 페이지로 이동
        return results.isEmpty
            ? defaultScreen()
            : ListView(
                children: results
                    .map((a) => ListTile(
                          leading: Icon(Icons.location_city),
                          title: Text(a['city']),
                          contentPadding: EdgeInsets.fromLTRB(15, 5, 5, 0),
                          onTap: () {
                            //print(a['city']);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        //게시물 CRUD 상세 페이지가 구현되면 그것으로 대치해야 됨
                                        getResult(a['city'])));
                          },
                        ))
                    .toList());
      },
    );
  }

  //검색 초기 화면
  Container defaultScreen() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 100,
            color: const Color.fromARGB(110, 247, 162, 144),
          ),
          Text(
            "게시글을 검색해보세요",
            style: TextStyle(
                fontSize: 20, color: const Color.fromARGB(75, 0, 0, 0)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  //게시물 CRUD 상세 페이지가 구현되면 그것으로 대치해야 됨
  Container getResult(a) {
    return Container(
      child: Scaffold(
        appBar: AppBar(title: Text("LINK"), centerTitle: true, elevation: 10.0),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
                child: Text(
              a,
              style: TextStyle(fontSize: 50),
            ))
          ],
        ),
      ),
    );
  }
}
