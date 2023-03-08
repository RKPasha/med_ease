import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

List<Appointments_Model> postModelFromJson(String str) =>
    List<Appointments_Model>.from(
        json.decode(str).map((x) => Appointments_Model.fromJson(x)));

String postModelToJson(List<Appointments_Model> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

//This file was copied from previous project

class Appointments_Model {
  Appointments_Model({
    required this.id,
    required this.time,
    required this.status,
    required this.doctor,
    required this.clinic,
    required this.date,
  });

  String id;
  String time;
  String status;
  String doctor;
  String date;
  String clinic;

  factory Appointments_Model.fromJson(Map<String, dynamic> json) =>
      Appointments_Model(
        id: json["id"],
        time: json["time"],
        doctor: json["doctor"],
        status: json["status"],
        date: json["date"],
        clinic: json["clinic"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": time,
        "description": doctor,
        "status": status,
        "date": date,
        "deadline": clinic,
      };

  factory Appointments_Model.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    // print(data["tittle"]);
    // print(data["description"]);
    // print(data["status"]);
    return Appointments_Model(
        id: document.id,
        time: data["TaskDes"],
        status: data["Status"],
        doctor: data["Task"],
        date: data["Date"],
        clinic: data["DeadLine"]);
  }
}
