import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:link_ver1/pages/search.dart';
import 'package:link_ver1/screen/profilePic.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("LINK"),
          centerTitle: true,
          //backgroundColor: const Color.fromARGB(250, 247, 162, 144),
          elevation: 10.0,
          // actions: <Widget>[
          //   IconButton(
          //     icon: Icon(
          //       Icons.search,
          //       color: Colors.white,
          //     ),
          //     onPressed: () {
          //       showSearch(context: context, delegate: Search());
          //     },
          //   )
          // ],
        ),
        body: ProfileScreen());
  }
}
