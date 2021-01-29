import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:link_ver1/pages/board_page.dart';

class Search extends SearchDelegate<String> {
  final Widget groupMembers;
  final String profilePic;
  final String uid;
  final String userName;

  Search({
    this.groupMembers,
    this.profilePic,
    this.uid,
    this.userName
});
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

  //검색 결과 출력 화면 (Enter 입력 후)
  @override
  Widget buildResults(BuildContext context) {
    print(uid);
    return buildSuggestions(context);
  }


  Widget getGroupMembers(String groupId) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('groups').doc(groupId).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            padding: EdgeInsets.only(top: 0),
            shrinkWrap: true,
            itemCount: snapshot.data['members'].length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Row(children: [
                  Text(_destructureName(snapshot.data['members'][index])),
                  snapshot.data['admin'] ==
                      _destructureName(snapshot.data['members'][index])
                      ? Text(' (방장)')
                      : Text(''),
                ]),
              );
            },
          );
        } else {
          return Text('noOne');
        }
      },
    );
  }

  String _destructureName(String res) {
    // print(res.substring(res.indexOf('_') + 1));
    return res.substring(res.indexOf('_') + 1);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('groups').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        //파이어베이스에 데이터가 없을 경우
        if (!snapshot.hasData) return new Text('검색중...');

        //검색어 입력하기 전
        if (query.isEmpty) return defaultScreen();

        //검색어를 토대로 파이어베이스에서 검색어가 포함되는 데이터들을 확인하여 저장
        final results =
            snapshot.data.docs.where((a) => a['title'].contains(query));

        print("results size: " + results.length.toString());
        //검색어와 일치하는 데이터가 없다면 초기 화면, 있다면 상세 페이지로 이동
        return results.isEmpty
            ? defaultScreen()
            : ListView(
                children: results
                    .map((a) => ListTile(
                          //검색어가 포함된 제목의 카테고리에 따라 Icon 지정
                          leading: a['category'].toString() == "공동 구매"
                              ? Icon(Icons.local_grocery_store_outlined)
                              : a['category'].toString() == "스터디"
                                  ? Icon(Icons.school_outlined)
                                  : Icon(Icons.directions_bike_outlined),
                          title: Row(
                            children: [
                              //검색어가 포함된 제목의 카테고리
                              // Expanded(
                              //   child: Text(
                              //     a['category'],
                              //     style: TextStyle(
                              //         fontSize: 16,
                              //         fontWeight: FontWeight.bold),
                              //     overflow: TextOverflow.ellipsis,
                              //   ),
                              // ),

                              //검색어가 포함된 제목
                              Expanded(
                                flex: 2,
                                child: Text(
                                  a['title'],
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(
                                width: 30,
                              ),

                              //검색어가 포함된 제목의 마감시간
                              Expanded(
                                child: Text(
                                  a['time_limit'],
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          contentPadding: EdgeInsets.fromLTRB(15, 5, 5, 0),

                          onTap: () {
                            //검색 목록에서 원하는 게시글을 누르면 해당 상세정보로 이동
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BoardPage(
                                          title: a['title'],
                                          category: a['category'],
                                          time_limit: a['time_limit'],
                                          body: a['body'],
                                          create_time: a['create_time'],
                                          max_person: a['max_person'],
                                          current_person: a['current_person'],
                                          groupId: a['groupId'],
                                          groupName: a['groupName'],
                                          profilePic: profilePic,
                                          uid: uid,
                                          groupMembers: getGroupMembers(a['groupId']),
                                          userName: userName ,
                                          //userName: a['userName'],
                                          // uid: a['uid'],
                                        )
                                    //게시물 CRUD 상세 페이지가 구현되면 그것으로 대치해야 됨
                                    ));
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

//   //게시물 CRUD 상세 페이지가 구현되면 그것으로 대치해야 됨
//   Container getResult(a) {
//     return Container(
//       child: Scaffold(
//         appBar: AppBar(title: Text("LINK"), centerTitle: true, elevation: 10.0),
//         body: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Center(
//                 child: Text(
//               a,
//               style: TextStyle(fontSize: 50),
//             ))
//           ],
//         ),
//       ),
//     );
//   }
}
