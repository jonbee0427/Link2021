import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_core/firebase_core.dart';

class User {
  String name;
  String password;
  String email;
  String account;
  String bank;
  final DocumentReference reference;

  User.fromMap(Map<dynamic, dynamic> map, {this.reference})
      : name = map['name'],
        password = map['password'],
        email = map['email'],
        account = map['account'],
        bank = map['bank'];

  User.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  @override
  String toString() => "User<$name:$password>";
}
