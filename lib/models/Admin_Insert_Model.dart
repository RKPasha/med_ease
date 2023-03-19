import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

List<Admin_Insert_Model> postModelFromJson(String str) =>
    List<Admin_Insert_Model>.from(
        json.decode(str).map((x) => Admin_Insert_Model.fromJson(x)));

String postModelToJson(List<Admin_Insert_Model> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

//This file was copied from previous project

class Admin_Insert_Model {
  Admin_Insert_Model({
    required this.uid,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.password,
  });
  String uid;
  String firstname;
  String lastname;
  String email;
  String password;

  factory Admin_Insert_Model.fromJson(Map<String, dynamic> json) =>
      Admin_Insert_Model(
        uid: json["uid"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        email: json["email"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "firstname": firstname,
        "lastname": lastname,
        "email": email,
        "password": password,
      };

  factory Admin_Insert_Model.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    // print(data["tittle"]);
    // print(data["description"]);
    // print(data["status"]);
    return Admin_Insert_Model(
        uid: document.id,
        firstname: data["FirstName"],
        lastname: data["LastName"],
        email: data["Email"],
        password: data["Password"]);
  }
}
