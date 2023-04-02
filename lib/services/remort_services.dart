import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:med_ease/models/Appointments_Model.dart';
import '../models/Admin_Insert_Model.dart';
import '../models/Doctors_Model.dart';
import '../models/Patient_Model.dart';
import '../models/ProfessionalInformation_Model.dart';
import '../models/Report_Model.dart';

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

  Future<List<Patient_Model>> getPatientsById(String ID) async {
    final snapshot = await ref
        .collection("users")
        .where("role", isEqualTo: "patient")
        .where("uid", isEqualTo: ID)
        .where("isDeleted", isEqualTo: 0)
        .get();
    final patients =
        snapshot.docs.map((e) => Patient_Model.fromSnapshot(e)).toList();
    // print(patients);
    return patients;
  }

  Future<bool> UpDate(Patient_Model pm, String id) async {
    final update = ref.collection("users");
    print(pm.Contact);
    print(id);
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
        'gender': pm.Gender
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
  }

  Future<List<Appointments_Model>> getAppointments() async {
    final snapshot = await ref
        .collection("Appointments")
        .where("isDeleted", isEqualTo: 0)
        .get();
    final appointments =
        snapshot.docs.map((e) => Appointments_Model.fromSnapshot(e)).toList();
    // print(patients);
    return appointments;
  }

  Future<bool> MakeAppointment(Appointments_Model a) async {
    final insert = ref.collection("Appointments");
    try {
      insert.add({
        "Date": a.date,
        "Time": a.time,
        "Clinic": a.clinic,
        "PatientID": a.patient_id,
        "DoctorID": a.doctor_id,
        "Doctor": a.doctor,
        "isApproved": a.isapproved,
        "isDeleted": a.isdeleted,
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> UpDate_Appointment(Appointments_Model a, String id) async {
    final update = ref.collection("Appointments");
    try {
      update.doc(id).update({
        "Date": a.date,
        "Time": a.time,
        "Clinic": a.clinic,
        "Doctor": a.doctor,
        "DoctorID": a.doctor_id,
        "isApproved": 0,
        "isDeleted": 0,
      }).then((value) => {});
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> DeleteAppointment(String id) async {
    print(id);
    final delete = ref.collection("Appointments");
    try {
      delete.doc(id).update({"isDeleted": 1}).then((value) => {});
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<Doctor_Model>> getDoctors() async {
    final snapshot = await ref
        .collection("users")
        .where("isDeleted", isEqualTo: 0)
        .where("role", isEqualTo: 'doctor')
        .get();
    final data =
        snapshot.docs.map((e) => Doctor_Model.fromSnapshot(e)).toList();
    print(data);
    return data;
  }

  Future<bool> Update_Doctor(Doctor_Model dm, String id) async {
    final update = ref.collection("users");
    try {
      update.doc(id).update({
        "firstName": dm.First_Name,
        "lastName": dm.Last_Name,
        "certification": dm.Certification,
        "clinic": dm.Clinic,
        "contactNo": dm.Contact,
        "degree": dm.Degree,
        "email": dm.Email,
        "experties": dm.Experties,
        "LicenseNo": dm.LicenseNo,
        "publication": dm.Publication,
        "specialist": dm.Specialist,
        "gender": dm.Gender
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> Delete_Doctor(String id) async {
    print(id);
    final delete = ref.collection("users");
    try {
      delete.doc(id).update({"isDeleted": 1}).then((value) => {});
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<Appointments_Model>> getAppointments_byDoctor(
      String docID) async {
    final snapshot = await ref
        .collection("Appointments")
        .where("isDeleted", isEqualTo: 0)
        .where("DoctorID", isEqualTo: docID)
        .where("isApproved", isEqualTo: 0)
        .get();
    final appointments =
        snapshot.docs.map((e) => Appointments_Model.fromSnapshot(e)).toList();
    // print(patients);
    return appointments;
  }

  Future<List<Appointments_Model>> getApprovedAppointments_byDoctor(
      String docID) async {
    final snapshot = await ref
        .collection("Appointments")
        .where("isDeleted", isEqualTo: 0)
        .where("DoctorID", isEqualTo: docID)
        .where("isApproved", isEqualTo: 1)
        .get();
    final appointments =
        snapshot.docs.map((e) => Appointments_Model.fromSnapshot(e)).toList();
    // print(patients);
    return appointments;
  }

  Future<List<Appointments_Model>> getAllAppointments_byDoctor(
      String docID) async {
    final snapshot = await ref
        .collection("Appointments")
        .where("isDeleted", isEqualTo: 0)
        .where("DoctorID", isEqualTo: docID)
        .get();
    final appointments =
        snapshot.docs.map((e) => Appointments_Model.fromSnapshot(e)).toList();
    // print(patients);
    return appointments;
  }

  Future<bool> Approve_Appointment(int isApproved, String id) async {
    final update = ref.collection("Appointments");
    try {
      update.doc(id).update({
        "isApproved": isApproved,
      }).then((value) => {});
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> UnApprove_Appointment(int isApproved, String id) async {
    final update = ref.collection("Appointments");
    try {
      update.doc(id).update({
        "isApproved": isApproved,
      }).then((value) => {});
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> CreateReport(Report_Model rm) async {
    final insert = ref.collection("Reports");
    try {
      insert.add({
        "PatientName": rm.PatientName,
        "Date": rm.Date,
        "Time": rm.Time,
        "PatientID": rm.PatientID,
        "DoctorID": rm.DoctorID,
        "Description": rm.Description,
        "isDeleted": 0
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<Report_Model>> getAllReports() async {
    final snapshot =
        await ref.collection("Reports").where("isDeleted", isEqualTo: 0).get();
    final reports =
        snapshot.docs.map((e) => Report_Model.fromSnapshot(e)).toList();
    // print(patients);
    return reports;
  }

  Future<List<Report_Model>> getAllReports_byDoctor(String docID) async {
    final snapshot = await ref
        .collection("Reports")
        .where("isDeleted", isEqualTo: 0)
        .where("DoctorID", isEqualTo: docID)
        .get();
    final reports =
        snapshot.docs.map((e) => Report_Model.fromSnapshot(e)).toList();
    // print(patients);
    return reports;
  }

  Future<bool> DeleteReport(String id) async {
    final delete = ref.collection("Reports");
    try {
      delete.doc(id).update({"isDeleted": 1}).then((value) => {});
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> UpDate_Report(String description, String id) async {
    final update = ref.collection("Reports");
    try {
      update.doc(id).update({
        "Description": description,
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> Add_ProffeessionalInformation(String edu, String insurance,
      String liablity, String doc_ID, int ID) async {
    final insert = ref.collection("ProfessionalInformation");
    try {
      insert.add({
        'DoctorID': doc_ID,
        'EducationTrainingDetails': edu,
        'InsuranceInformation': insurance,
        'LiabilityInsuranceInformation': liablity,
        'ID': ID
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<ProfessionalInformation_Model>> getProfessionalInfoByDoc(
      String DocID) async {
    final snapshot = await ref
        .collection("ProfessionalInformation")
        .where("DoctorID", isEqualTo: DocID)
        .get();
    final info = snapshot.docs
        .map((e) => ProfessionalInformation_Model.fromSnapshot(e))
        .toList();
    // print(patients);
    return info;
  }

  Future<List<ProfessionalInformation_Model>> getAllProfessionalInfo() async {
    final snapshot = await ref.collection("ProfessionalInformation").get();
    final info = snapshot.docs
        .map((e) => ProfessionalInformation_Model.fromSnapshot(e))
        .toList();
    // print(patients);
    return info;
  }

  Future<List<Doctor_Model>> getDoctorbyId(String id) async {
    final snapshot = await ref
        .collection("users")
        .where("isDeleted", isEqualTo: 0)
        .where("uid", isEqualTo: id)
        .get();
    final data =
        snapshot.docs.map((e) => Doctor_Model.fromSnapshot(e)).toList();
    print(data);
    return data;
  }

Future<List<Report_Model>> getAllReports_byPatient(String patientID) async {
    final snapshot = await ref
        .collection("Reports")
        .where("isDeleted", isEqualTo: 0)
        .where("PatientID", isEqualTo: patientID)
        .get();
    final reports =
        snapshot.docs.map((e) => Report_Model.fromSnapshot(e)).toList();
    // print(patients);
    return reports;
  }

}
