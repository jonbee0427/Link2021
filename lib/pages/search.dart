import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Search extends SearchDelegate<String> {
  @override
  String get searchFieldLabel => "검색";

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
        if (!snapshot.hasData) return new Text('검색중...');

        //검색 초기 화면
        if (query.isEmpty) return defaultScreen();

        final results =
            snapshot.data.docs.where((a) => a['city'].contains(query));

        return results.isEmpty
            ? defaultScreen()
            : ListTile(
                onTap: () {
                  showResults(context);
                },
                title: Column(
                  children: results
                      .map<Widget>((a) => Text(
                            a['city'],
                            style: TextStyle(fontSize: 20),
                            textAlign: TextAlign.center,
                          ))
                      .toList(),
                ));

        // return InkWell(
        //     child: ListView(
        //       children: ,
        //     ),
        //     onTap: () {
        //       Navigator.of(context).push(MaterialPageRoute<Null>(
        //           fullscreenDialog: true,
        //           builder: (BuildContext context) {
        //             return DetailScreen(results);
        //           }));
        //     });
      },
    );
  }

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
}
