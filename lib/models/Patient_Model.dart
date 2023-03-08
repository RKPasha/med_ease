import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

// List<Patient_Model> postModelFromJson(String str) => List<Patient_Model>.from(
//     json.decode(str).map((x) => Patient_Model.fromJson(x)));

// String postModelToJson(List<Patient_Model> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

//This file was copied from previous project

class Patient_Model {
  Patient_Model({
    required this.First_Name,
    required this.Last_Name,
    required this.DOB,
    required this.Gender,
    required this.Contact,
    required this.Address,
    required this.HealthInsuranceInfo,
    required this.EmergencyContact,
    required this.MedicalHistory,
    required this.Allergies_Medication,
    required this.Prefrence,
    required this.Email,
    required this.Password,
    required this.ConfirmPassword,
  });

  String First_Name;
  String Last_Name;
  String DOB;
  String Gender;
  String Contact;
  String Address;
  String HealthInsuranceInfo;
  String EmergencyContact;
  String MedicalHistory;
  String Allergies_Medication;
  String Prefrence;
  String Email;
  String Password;
  String ConfirmPassword;

  // factory Patient_Model.fromJson(Map<String, dynamic> json) => Patient_Model(
  //       id: json["id"],
  //       title: json["title"],
  //       description: json["description"],
  //       status: json["status"],
  //       date: json["date"],
  //       deadline: json["deadline"],
  //       isDeleted: json["isdeleted"],
  //     );

  // Map<String, dynamic> toJson() => {
  //       "id": id,
  //       "title": title,
  //       "description": description,
  //       "status": status,
  //       "date": date,
  //       "deadline": deadline,
  //       "isdeleted": isDeleted
  //     };

  // factory Patient_Model.fromSnapshot(
  //     DocumentSnapshot<Map<String, dynamic>> document) {
  //   final data = document.data()!;
  //   // print(data["tittle"]);
  //   // print(data["description"]);
  //   // print(data["status"]);
  //   return Patient_Model(
  //       id: document.id,
  //       description: data["TaskDes"],
  //       status: data["Status"],
  //       title: data["Task"],
  //       date: data["Date"],
  //       deadline: data["DeadLine"],
  //       isDeleted: data["IsDeleted"]);
  // }
}
