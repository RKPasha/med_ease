import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

List<ProfessionalInformation_Model> postModelFromJson(String str) =>
    List<ProfessionalInformation_Model>.from(
        json.decode(str).map((x) => ProfessionalInformation_Model.fromJson(x)));

String postModelToJson(List<ProfessionalInformation_Model> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

//This file was copied from previous project

class ProfessionalInformation_Model {
  ProfessionalInformation_Model({
    required this.DocumentId,
    required this.ID,
    required this.DoctorID,
    required this.EducationTrainingDetails,
    required this.InsuranceInformation,
    required this.LiabilityInsuranceInformation,
  });

  String DocumentId;
  int ID;
  String DoctorID;
  String InsuranceInformation;
  String EducationTrainingDetails;
  String LiabilityInsuranceInformation;

  factory ProfessionalInformation_Model.fromJson(Map<String, dynamic> json) =>
      ProfessionalInformation_Model(
        DocumentId:json["DocumentId"],
        ID: json["ID"],
        DoctorID: json["DoctorID"],
        InsuranceInformation: json["InsuranceInformation"],
        EducationTrainingDetails: json["EducationTrainingDetails"],
        LiabilityInsuranceInformation: json["LiabilityInsuranceInformation"],
      );

  Map<String, dynamic> toJson() => {
        "ID": ID,
        "DoctorID": DoctorID,
        "InsuranceInformation": InsuranceInformation,
        "EducationTrainingDetails": EducationTrainingDetails,
        "LiabilityInsuranceInformation": LiabilityInsuranceInformation,
      };

  factory ProfessionalInformation_Model.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    // print(data["tittle"]);
    // print(data["description"]);
    // print(data["status"]);
    return ProfessionalInformation_Model(
        DocumentId:document.id,
        ID: data["ID"],
        DoctorID: data["DoctorID"],
        InsuranceInformation: data["InsuranceInformation"],
        EducationTrainingDetails: data["EducationTrainingDetails"],
        LiabilityInsuranceInformation: data["LiabilityInsuranceInformation"]);
  }
}
