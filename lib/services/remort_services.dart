import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Models/Patient_Model.dart';
import '../Models/Task_Model.dart';
import '../models/Admin_Insert_Model.dart';

//This file was copied from previous project

class remort_services {
  final ref = FirebaseFirestore.instance;

  final _auth = FirebaseAuth.instance;

  Future<bool> Insert(Admin_Insert_Model apm) async {
    final insert = ref.collection("Patients");
    try {
      insert.add({
        "FirstName": apm.firstname,
        "LastName": apm.lastname,
        "Gender": "Not_Yet_Added",
        "DOB": "Not_Yet_Added",
        "Email": apm.email,
        "Contact": "Not_Yet_Added",
        "Address": "Not_Yet_Added",
        "Allergies_Medication": "Not_Yet_Added",
        "HealthInsurence": "Not_Yet_Added",
        "EmergencyContact": "Not_Yet_Added",
        "MedicalHistory": "Not_Yet_Added",
        "Preference": "Not_Yet_Added"
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<Patient_Model>> getPatients() async {
    final snapshot = await ref
        .collection("users")
        .where("role", isEqualTo: "patient")
        .where("isDeleted", isEqualTo: 0)
        .get();
    final patients =
        snapshot.docs.map((e) => Patient_Model.fromSnapshot(e)).toList();
    // print(patients);
    return patients;
  }

  Future<bool> UpDate(Patient_Model pm, String id) async {
    final update = ref.collection("users");
    try {
      update.doc(id).update({
        'firstName': pm.First_Name,
        'Address': pm.Address,
        'AllergiesAndMedication': pm.Allergies_Medication,
        'DOB': pm.DOB,
        'EmergencyContact': pm.EmergencyContact,
        'Info': pm.Information,
        'InsuranceID': pm.HealthInsuranceID,
        'Medical_ID': pm.MedicalHistory,
        'PreferedHealthCare': pm.Prefrence,
        'contactNo': pm.Contact,
        'email': pm.Email,
        'isDeleted': pm.isDeleted,
        'lastName': pm.Last_Name,
        'gender':pm.Gender
      }).then((value) => {});
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> Delete(String id) async {
    print(id);
    final delete = ref.collection("users");
    try {
      delete.doc(id).update({"isDeleted": 1}).then((value) => {});
      return true;
    } catch (e) {
      return false;
    }
    return true;
  }
}
