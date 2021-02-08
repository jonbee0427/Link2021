import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'dart:async';

import 'package:link_ver1/helper/helper_functions.dart';
import 'package:link_ver1/pages/home_page.dart';

import 'authenticate_page.dart';

class Loading1 extends StatefulWidget {
  @override
  _LoadingState1 createState() => _LoadingState1();
}

class _LoadingState1 extends State<Loading1> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;
  bool _isLoggedIn = false;

  void initState() {
    _controller = AnimationController(
        duration: Duration(seconds: 2), vsync: this, value: 0.1);

    _animation =
        CurvedAnimation(parent: _controller, curve: Curves.bounceInOut);

    _controller.forward();
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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: MainPage(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData == false) {
            return Column(
              children: [
                Expanded(
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: ScaleTransition(
                        scale: _animation,
                        alignment: Alignment.center,
                        child: Image.asset(
                          'assets/camera.png',
                          fit: BoxFit.fitWidth,
                        ),
                      )),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Text('에러');
          } else
            return Center();
        },
      ),
    );
  }

  Future MainPage() async {
    await Future.delayed(Duration(seconds: 3), () => Navigator.pop(context));
    return Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                _isLoggedIn ? HomePage() : AuthenticatePage()));
  }
}
