import 'package:flutter/material.dart';

class QuestionScreen extends StatefulWidget {
  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('문의하기'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(250, 247, 162, 144),
        elevation: 10.0,
      ),
    );
  }
}
