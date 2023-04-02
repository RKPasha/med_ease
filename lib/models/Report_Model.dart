import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

List<Report_Model> postModelFromJson(String str) => List<Report_Model>.from(
    json.decode(str).map((x) => Report_Model.fromJson(x)));

String postModelToJson(List<Report_Model> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

//This file was copied from previous project

class Report_Model {
  Report_Model({
    required this.id,
    required this.DoctorID,
    required this.PatientID,
    required this.PatientName,
    required this.Date,
    required this.Time,
    required this.Description,
    required this.isDeleted,
  });

  String id;
  String DoctorID;
  String PatientID;
  String PatientName;
  String Date;
  String Time;
  String Description;
  int isDeleted;

  factory Report_Model.fromJson(Map<String, dynamic> json) => Report_Model(
        id: json["id"],
        DoctorID: json["DoctorID"],
        PatientID: json["PatientID"],
        PatientName: json["PatientName"],
        Date: json["Date"],
        Time: json["Time"],
        Description: json["Description"],
        isDeleted: json["isdeleted"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "DoctorID": DoctorID,
        "PatientID": PatientID,
        "PatientName": PatientName,
        "Date": Date,
        "Time": Time,
        "Description": Description,
        "isDeleted": isDeleted
      };

  factory Report_Model.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    // print(data["tittle"]);
    // print(data["description"]);
    // print(data["status"]);
    return Report_Model(
        id: document.id,
        DoctorID: data["DoctorID"],
        PatientID: data["PatientID"],
        PatientName: data["PatientName"],
        Date: data["Date"],
        Time: data["Time"],
        Description: data["Description"],
        isDeleted: data["isDeleted"]);
  }
}
