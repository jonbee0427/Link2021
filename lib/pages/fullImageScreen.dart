import 'package:flutter/material.dart';

class FullScreenPage extends StatelessWidget {
  final String Url;
  FullScreenPage({this.Url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("LINK"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(250, 247, 162, 144),
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
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(Url),
              fit: BoxFit.contain
          ) ,
        ),
      ),
    );
  }
}
