import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Alarm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("한동모아"),
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          defaultScreen(),
        ],
      ),
    );
  }
}

//알림페이지 초기 화면
Container defaultScreen() {
  return Container(
    alignment: Alignment.center,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.notifications,
          size: 100,
          color: const Color.fromARGB(110, 247, 162, 144),
        ),
        Text(
          "준비중",
          style:
              TextStyle(fontSize: 20, color: const Color.fromARGB(75, 0, 0, 0)),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
