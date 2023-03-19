import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

List<Patient_Model> postModelFromJson(String str) => List<Patient_Model>.from(
    json.decode(str).map((x) => Patient_Model.fromJson(x)));

String postModelToJson(List<Patient_Model> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Patient_Model {
  Patient_Model({
    required this.id,
    required this.First_Name,
    required this.Last_Name,
    required this.DOB,
    required this.Gender,
    required this.Contact,
    required this.Address,
    required this.HealthInsuranceID,
    required this.EmergencyContact,
    required this.MedicalHistory,
    required this.Allergies_Medication,
    required this.Prefrence,
    required this.Email,
    required this.Information,
    required this.Password,
    required this.isDeleted,
  });
  String id;
  String First_Name;
  String Last_Name;
  String DOB;
  String Gender;
  String Contact;
  String Address;
  String HealthInsuranceID;
  String EmergencyContact;
  String MedicalHistory;
  String Allergies_Medication;
  String Prefrence;
  String Email;
  String Password;
  String Information;
  int isDeleted;

  factory Patient_Model.fromJson(Map<String, dynamic> json) => Patient_Model(
      id: json["id"],
      First_Name: json["First_Name"],
      Last_Name: json["Last_Name"],
      DOB: json["DOB"],
      Gender: json["Gender"],
      Contact: json["Contact"],
      Address: json["Address"],
      HealthInsuranceID: json["HealthInsuranceInfo"],
      EmergencyContact: json["EmergencyContact"],
      MedicalHistory: json["MedicalHistory"],
      Allergies_Medication: json["Allergies_Medication"],
      Prefrence: json["Prefrence"],
      Email: json["Email"],
      Information: json["Information"],
      Password: json["Password"],
      isDeleted: json["isDeleted"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "First_Name": First_Name,
        "Last_Name": Last_Name,
        "DOB": DOB,
        "Gender": Gender,
        "Contact": Contact,
        "Address": Address,
        "HealthInsuranceID": HealthInsuranceID,
        "EmergencyContact": EmergencyContact,
        "MedicalHistory": MedicalHistory,
        "Allergies_Medication": Allergies_Medication,
        "Prefrence": Prefrence,
        "Email": Email,
        "Information": Information,
        "Password": Password,
        "isDeleted": isDeleted
      };

  factory Patient_Model.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    // print(data["tittle"]);
    // print(data["description"]);
    // print(data["status"]);
    return Patient_Model(
      id: document.id,
      First_Name: data["firstName"],
      Last_Name: data["lastName"],
      DOB: data["DOB"],
      Gender: data["gender"],
      Contact: data["contactNo."],
      Address: data["Address"],
      HealthInsuranceID: data["InsuranceID"],
      EmergencyContact: data["EmergencyContact"],
      MedicalHistory: data["Medical_ID"],
      Allergies_Medication: data["AllergiesAndMedication"],
      Prefrence: data["PreferedHealthCare"],
      Email: data["email"],
      Information: data["Info"],
      Password: "",
      isDeleted: data["isDeleted"],
    );
  }
}
