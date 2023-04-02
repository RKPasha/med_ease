import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

List<Doctor_Model> postModelFromJson(String str) => List<Doctor_Model>.from(
    json.decode(str).map((x) => Doctor_Model.fromJson(x)));

String postModelToJson(List<Doctor_Model> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Doctor_Model {
  Doctor_Model({
    required this.id,
    required this.First_Name,
    required this.Certification,
    required this.Gender,
    required this.Last_Name,
    required this.Experience,
    required this.Experties,
    required this.Contact,
    required this.InsuranceID,
    required this.LiabilityID,
    required this.LicenseNo,
    required this.Publication,
    required this.Specialist,
    required this.Email,
    required this.isDeleted,
    required this.Clinic,
    required this.Degree,
    required this.EducationTrainingID,
  });
  String id;
  String Certification;
  int EducationTrainingID;
  String Gender;
  String Degree;
  String Clinic;
  String First_Name;
  String Last_Name;
  int Experience;
  String Experties;
  String Contact;
  int InsuranceID;
  int LiabilityID;
  String LicenseNo;
  String Publication;
  String Specialist;
  String Email;
  int isDeleted;

  factory Doctor_Model.fromJson(Map<String, dynamic> json) => Doctor_Model(
      id: json["id"],
      First_Name: json["First_Name"],
      Last_Name: json["Last_Name"],
      Certification: json["Certification"],
      EducationTrainingID: json["EducationTrainingID"],
      Degree: json["Degree"],
      Gender: json["Gender"],
      Clinic: json["Clinic"],
      Experience: json["Experience"],
      Experties: json["Experties"],
      Contact: json["Contact"],
      InsuranceID: json["InsuranceID"],
      LiabilityID: json["LiabilityID"],
      LicenseNo: json["LicenseNo"],
      Publication: json["Publication"],
      Specialist: json["Specialist"],
      Email: json["Email"],
      isDeleted: json["isDeleted"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "Certification": Certification,
        "EducationTrainingID": EducationTrainingID,
        "Degree": Degree,
        "Clinic": Clinic,
        "Gender": Gender,
        "First_Name": First_Name,
        "Last_Name": Last_Name,
        "Experience": Experience,
        "Experties": Experties,
        "Contact": Contact,
        "InsuranceID": InsuranceID,
        "LiabilityID": LiabilityID,
        "LicenseNo": LicenseNo,
        "Publication": Publication,
        "Specialist": Specialist,
        "Email": Email,
        "isDeleted": isDeleted
      };

  factory Doctor_Model.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return Doctor_Model(
      id: document.id,
      Certification: data["certification"],
      EducationTrainingID: data["educationTrainingID"],
      Gender: data["gender"],
      Degree: data["degree"],
      Clinic: data["clinic"],
      First_Name: data["firstName"],
      Last_Name: data["lastName"],
      Experience: data["experience"],
      Experties: data["experties"],
      Contact: data["contactNo"],
      InsuranceID: data["insuranceID"],
      LiabilityID: data["liabilityID"],
      LicenseNo: data["LicenseNo"],
      Publication: data["publication"],
      Specialist: data["specialist"],
      Email: data["email"],
      isDeleted: data["isDeleted"],
    );
  }
}
