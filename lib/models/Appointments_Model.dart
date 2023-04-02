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
    required this.patient_id,
    required this.doctor_id,
    required this.time,
    required this.isapproved,
    required this.doctor,
    required this.clinic,
    required this.date,
    required this.isdeleted,
  });

  String id;
  String patient_id;
  String doctor_id;
  String time;
  int isapproved;
  String doctor;
  String date;
  String clinic;
  int isdeleted;

  factory Appointments_Model.fromJson(Map<String, dynamic> json) =>
      Appointments_Model(
        id: json["id"],
        patient_id: json['patient_id'],
        doctor_id: json['doctor_id'],
        time: json["time"],
        doctor: json["doctor"],
        isapproved: json["isapproved"],
        date: json["date"],
        clinic: json["clinic"],
        isdeleted: json['isdeleted'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "time": time,
        "doctor_id": doctor_id,
        "patient_id": patient_id,
        "doctor": doctor,
        "isapproved": isapproved,
        "date": date,
        "clinic": clinic,
        "isdeleted": isdeleted
      };

  factory Appointments_Model.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    // print(data["tittle"]);
    // print(data["description"]);
    // print(data["status"]);
    return Appointments_Model(
        id: document.id,
        doctor_id: data["DoctorID"],
        patient_id: data["PatientID"],
        time: data["Time"],
        isapproved: data["isApproved"],
        doctor: data["Doctor"],
        date: data["Date"],
        clinic: data["Clinic"],
        isdeleted: data["isDeleted"]);
  }
}
