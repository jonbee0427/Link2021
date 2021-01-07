// //
// // // Copyright 2017, 2020 The Flutter team. All rights reserved.
// // // Use of this source code is governed by a BSD-style license
// // // that can be found in the LICENSE file.
// //
// // import './login_screen.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/foundation.dart';
// // import 'login_screen.dart';
// // import 'package:firebase_core/firebase_core.dart';
// //
// // Future<void> main() async {
// //   WidgetsFlutterBinding.ensureInitialized();
// //   await Firebase.initializeApp();
// //   runApp(
// //     FriendlyChatApp(),
// //   );
// // }
// //
// // final ThemeData kIOSTheme = ThemeData(
// //   primarySwatch: Colors.orange,
// //   primaryColor: Colors.grey[100],
// //   primaryColorBrightness: Brightness.light,
// // );
// //
// // final ThemeData kDefaultTheme = ThemeData(
// //   primarySwatch: Colors.purple,
// //   accentColor: Colors.orangeAccent[400],
// // );
// //
// //
// // class FriendlyChatApp extends StatelessWidget {
// //   const FriendlyChatApp({
// //     Key key,
// //   }) : super(key: key);
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'FriendlyChat',
// //       theme: defaultTargetPlatform == TargetPlatform.iOS
// //           ? kIOSTheme
// //           : kDefaultTheme,
// //       home: LoginScreen(),
// //     );
// //   }
// // }
// //
//
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
//
// import 'const.dart';
// import 'login_screen.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Chat Demo',
//       theme: ThemeData(
//         primaryColor: themeColor,
//       ),
//       home: LoginScreen(title: 'CHAT DEMO'),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }


import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:link_ver1/helper/helper_functions.dart';
import 'package:link_ver1/pages/authenticate_page.dart';
import 'package:link_ver1/pages/home_page.dart';

void main() {
  initializeFlutterFire();
  return runApp(MyApp());

}

void initializeFlutterFire() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _getUserLoggedInStatus();
  }

  _getUserLoggedInStatus() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
      if(value != null) {
        setState(() {
          _isLoggedIn = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Group Chats',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      //home: _isLoggedIn != null ? _isLoggedIn ? HomePage() : AuthenticatePage() : Center(child: CircularProgressIndicator()),
      home: _isLoggedIn ? HomePage() : AuthenticatePage(),
      //home: HomePage(),
    );
  }
}
