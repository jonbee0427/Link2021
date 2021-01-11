import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AccountScreen extends StatefulWidget {
  String name;
  String password;
  String email;
  String bank;
  String account;
  AccountScreen();

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Stream<QuerySnapshot> streamData;

  @override
  void initState() {
    super.initState();
    streamData = firestore.collection('MyUsers').snapshots();
  }

  String value = '';
  Map data;

  final idController = TextEditingController();
  final pwController = TextEditingController();
  final emailController = TextEditingController();
  final bankController = TextEditingController();
  final accountController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  fetchData() {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('MyUsers');
    collectionReference.snapshots().listen((snapshot) {
      setState(() {
        data = snapshot.docs[2].data();
        widget.name = data['name'].toString();
        widget.password = data['password'].toString();
        widget.email = data['email'].toString();
        widget.bank = data['bank'].toString();
        widget.account = data['account'].toString();
      });
    });
  }

  updateData() async {
    //print(widget.bank);
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('MyUsers');
    QuerySnapshot querySnapshot = await collectionReference.get();
    querySnapshot.docs[2].reference.update({
      "name": widget.name,
      "password": widget.password,
      "email": widget.email,
      "bank": widget.bank,
      "account": widget.account
    });
  }

  Widget _buildName() {
    String textName;
    if (widget.name == null) {
      textName = '아이디';
    } else {
      textName = '아이디 : ' + widget.name;
    }
    return TextFormField(
      controller: idController,
      decoration: InputDecoration(
        labelText: textName,
        labelStyle: TextStyle(color: Colors.black),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(250, 247, 162, 144)),
          //borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          //borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
      ),
      maxLength: 10,
      /*
      validator: (String value) {
        if (value.isEmpty) {
          return '아이디를 입력하세요';
        }

        return null;
      },
      */
      onSaved: (String value) {
        widget.name = value;
        data['name'] = widget.name;
      },
    );
  }

  Widget _buildPassword() {
    String labelText;
    if (widget.password == null) {
      labelText = '비밀번호';
    } else {
      labelText = '비밀번호 : ' + widget.password;
    }
    return TextFormField(
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.black),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(250, 247, 162, 144)),
          //borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          //borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
      ),
      keyboardType: TextInputType.visiblePassword,
      maxLength: 16,
      /*
      validator: (String value) {
        if (value.isEmpty) {
          return '비밀번호를 입력하세요';
        }

        return null;
      },
      */
      onSaved: (String value) {
        widget.password = value;
        data['password'] = widget.password;
      },
    );
  }

  Widget _buildEmail() {
    String textEmail;
    if (widget.email == null) {
      textEmail = '이메일';
    } else {
      textEmail = '이메일 : ' + widget.email;
    }
    return TextFormField(
      decoration: InputDecoration(
        labelText: textEmail,
        labelStyle: TextStyle(color: Colors.black),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(250, 247, 162, 144)),
          //borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          //borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
      ),
      maxLength: 20,
      /*
      validator: (String value) {
        if (value.isEmpty) {
          return '이메일을 입력하세요';
        }

        if (!RegExp(
                r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
          return '정확한 이메일 주소를 입력해주세요';
        }

        return null;
      },
      */
      onSaved: (String value) {
        widget.email = value;
        data['email'] = widget.email;
      },
    );
  }

  Widget _buildBank() {
    String textBank;
    if (widget.bank == null) {
      textBank = '은행명';
    } else {
      textBank = '은행명 : ' + widget.bank;
    }
    return TextFormField(
      decoration: InputDecoration(
        labelText: textBank,
        labelStyle: TextStyle(color: Colors.black),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(250, 247, 162, 144)),
          //borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          //borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
      ),
      maxLength: 10,
      /*
      validator: (String value) {
        if (value.isEmpty) {
          return '은행명을 입력하세요';
        }
        return null;
      },
      */
      onSaved: (String value) {
        widget.bank = value;
        data['bank'] = widget.bank;
      },
    );
  }

  Widget _buildAccount() {
    String textAccount;
    if (widget.account == null) {
      textAccount = '계좌번호';
    } else {
      textAccount = '게좌번호 : ' + widget.account;
    }
    return TextFormField(
      decoration: InputDecoration(
        labelText: textAccount,
        labelStyle: TextStyle(color: Colors.black),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(250, 247, 162, 144)),
          //borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          //borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
      ),
      maxLength: 20,
      /*
      validator: (String value) {
        if (value.isEmpty) {
          return '계좌번호를 입력하세요';
        }
        return null;
      },
      */
      onSaved: (String value) {
        widget.account = value;
        data['account'] = widget.account;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('개인정보'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(250, 247, 162, 144),
        elevation: 10.0,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildName(),
                _buildPassword(),
                _buildEmail(),
                _buildBank(),
                _buildAccount(),
                SizedBox(height: 80),
                MaterialButton(
                  child: Container(
                    child: Text(
                      'Fetch',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red[300],
                    ),
                    padding: const EdgeInsets.all(10.0),
                  ),
                  onPressed: () {
                    fetchData();
                  },
                  /*
                    _formKey.currentState.save();
                    print(widget.user.id);
                    print(widget.user.password);
                    print(widget.user.email);
                    print(widget.user.account);
                     }   //Send to API
                     */
                ),
                //Text(data.toString()),
                SizedBox(height: 30),
                MaterialButton(
                  child: Container(
                    child: Text(
                      'Update',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red[300],
                    ),
                    padding: const EdgeInsets.all(10.0),
                  ),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      updateData();
                    }
                  },
                  /*
                    _formKey.currentState.save();
                    print(widget.user.id);
                    print(widget.user.password);
                    print(widget.user.email);
                    print(widget.user.account);
                    //Send to API
                  }, */
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
