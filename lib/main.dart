import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:link_ver1/helper/helper_functions.dart';
import 'package:link_ver1/pages/authenticate_page.dart';
import 'package:link_ver1/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  return runApp(MyApp());
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
      if (value != null) {
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
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: Color.fromARGB(250, 247, 162, 144),
        ),
      ),
      debugShowCheckedModeBanner: false,
      //home: _isLoggedIn != null ? _isLoggedIn ? HomePage() : AuthenticatePage() : Center(child: CircularProgressIndicator()),
      home: _isLoggedIn ? HomePage() : AuthenticatePage(),
      //home: HomePage(),
    );
  }
}
