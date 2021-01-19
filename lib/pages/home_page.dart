import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:link_ver1/helper/helper_functions.dart';
import 'package:link_ver1/pages/authenticate_page.dart';
import 'package:link_ver1/pages/chat_page.dart';
import 'package:link_ver1/pages/profile_page.dart';
import 'package:link_ver1/pages/search_page.dart';
import 'package:link_ver1/services/auth_service.dart';
import 'package:link_ver1/services/database_service.dart';
import 'package:link_ver1/widgets/group_tile.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'home.dart';
import 'notification.dart';
import 'profile.dart';
import 'message.dart';
import 'addpost.dart';
import 'profile.dart';
import 'search.dart';
import 'package:link_ver1/screen/profileMain.dart';
import 'package:link_ver1/screen/profilePic.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedPage = 0;
  final _pageOptions = [Home(), Chat(), Post(), Alarm(), Profile()];
  // Building the HomePage widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("LINK"),
        centerTitle: true,
        //backgroundColor: const Color.fromARGB(250, 247, 162, 144),
        elevation: 10.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              showSearch(context: context, delegate: Search());
            },
          )
        ],
      ),
      body: _pageOptions[selectedPage],
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: const Color.fromARGB(250, 247, 162, 144),
        items: [
          TabItem(
            icon: Icons.home,
            title: '홈',
          ),
          TabItem(icon: Icons.textsms, title: '채팅'),
          TabItem(icon: Icons.add, title: '추가'),
          TabItem(icon: Icons.notifications, title: '알림'),
          TabItem(icon: Icons.person, title: '프로필'),
        ],
        initialActiveIndex: 0, //optional, default as 0
        onTap: (int i) {
          setState(() {
            selectedPage = i;
          });
        },
      ),
    );
  }
}
