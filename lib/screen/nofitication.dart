import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class NotiScreen extends StatefulWidget {
  @override
  _NotiScreenState createState() => _NotiScreenState();
}

class _NotiScreenState extends State<NotiScreen> {
  bool enabled = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('알림'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(250, 247, 162, 144),
        elevation: 10.0,
      ),
      body: Container(
        child: Switch(
          onChanged: (bool value) {
            setState(() {
              enabled = value;
              print(enabled);
            });
          },
          activeColor: Colors.red,
          activeTrackColor: Colors.redAccent[400],
          value: enabled,
        ),
      ),
    );
  }
}
