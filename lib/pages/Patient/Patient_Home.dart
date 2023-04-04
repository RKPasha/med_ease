import 'package:clipboard/clipboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:med_ease/models/Appointments_Model.dart';
import 'package:med_ease/pages/Patient/Manage_Info.dart';
import 'package:med_ease/pages/Patient/patient_side_navbar.dart';
import 'package:med_ease/services/remort_services.dart';
import '../../models/Patient_Model.dart';
import '../../utils/widgets_function.dart';
import 'Appointments.dart';
import 'Make_Appointment.dart';
import 'Patient_Reports.dart';
import 'Patient_Side_Menu.dart';

class Patient_Home extends StatefulWidget {
  final User user;
  const Patient_Home({super.key, required this.user});

  @override
  State<Patient_Home> createState() => _Patient_HomeState();
}

class _Patient_HomeState extends State<Patient_Home> {
  List<Patient_Model>? all_patients;
  List<Patient_Model>? patient;
  List<Appointments_Model>? appointments;
  String id = '';
  String contact = '';
  int total_appointments = 0;
  bool loaded = false;

  getData() async {
    all_patients = await remort_services().getPatients();
    appointments = await remort_services().getAppointments();
    SearchResults();
  }

  SearchResults() {
    final Suggestions = all_patients!.where((patient) {
      final email = patient.Email;
      return email.contains(widget.user.email.toString());
    }).toList();
    setState(() {
      patient = Suggestions;
      if (patient![0].Contact != "Not Yet Added") {
        Populate(patient);
        total_appointments = appointments!.length;
      } else {
        id = patient![0].id;
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Manage_Info(
                    user: widget.user,
                    ID: id,
                    pm: Data(patient),
                  )),
        );
      }
    });
  }

  Populate(List<Patient_Model>? patient) {
    id = patient![0].id;
    First_Name = patient[0].First_Name;
    Last_Name = patient[0].Last_Name;
    DOB = patient[0].DOB;
    Gender = patient[0].Gender;
    Contact = patient[0].Contact;
    Address = patient[0].Address;
    HealthInsuranceID = patient[0].HealthInsuranceID;
    EmergencyContact = patient[0].EmergencyContact;
    MedicalHistory = patient[0].MedicalHistory;
    Allergies_Medication = patient[0].Allergies_Medication;
    Prefrence = patient[0].Prefrence;
    Email = patient[0].Email;
    Information = patient[0].Information;
    contact = patient[0].Contact;
    setState(() {
      loaded = true;
    });
  }

  Data(List<Patient_Model>? patient) {
    Patient_Model pm = Patient_Model(
        id: patient![0].id,
        First_Name: patient[0].First_Name,
        Last_Name: patient[0].Last_Name,
        DOB: patient[0].DOB,
        Gender: patient[0].Gender,
        Contact: patient[0].Contact,
        Address: patient[0].Address,
        HealthInsuranceID: patient[0].HealthInsuranceID,
        EmergencyContact: patient[0].EmergencyContact,
        MedicalHistory: patient[0].MedicalHistory,
        Allergies_Medication: patient[0].Allergies_Medication,
        Prefrence: patient[0].Prefrence,
        Email: patient[0].Email,
        Information: patient[0].Information,
        Password: Password,
        isDeleted: 0);
    return pm;
  }

  loading() {
    return Container(
      color: Colors.white,
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    getData();
  }

  String First_Name = '';
  String Last_Name = '';
  String DOB = '';
  String Gender = '';
  String Contact = '';
  String Address = '';
  String HealthInsuranceID = '';
  String EmergencyContact = '';
  String MedicalHistory = '';
  String Allergies_Medication = '';
  String Prefrence = '';
  String Email = '';
  String Password = '';
  String Information = '';

  Future<bool?> _onBackPressed() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Exit?'),
            content: const Text('Are you sure you want to exit?'),
            actions: <Widget>[
              TextButton(
                child: const Text('NO'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              TextButton(
                child: const Text('YES'),
                onPressed: () {
                  pop();
                },
              ),
            ],
          );
        });
  }

  static Future<void> pop({bool? animated}) async {
    await SystemChannels.platform
        .invokeMethod<void>('SystemNavigator.pop', animated);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final now = DateTime.now();
    final hour = now.hour;
    String greeting = '';
    if (hour < 12 && hour >= 5) {
      greeting = 'Good Morning';
    } else if (hour >= 12 && hour < 18) {
      greeting = 'Good Afternoon';
    } else {
      greeting = 'Good Evening';
    }

    return loaded != true
        ? loading()
        : WillPopScope(
            onWillPop: () async {
              bool? result = await _onBackPressed();
              result ??= false;
              return result;
            },
            child: Scaffold(
              drawer: PatientSideNav(
                user: widget.user,
                id: id,
                pm: Data(patient),
                name: '$First_Name $Last_Name',
              ),
              body: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[
                      addVerticalSpace(30),
                      Row(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 0.0, right: 0.0),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                color: Colors.blue,
                              ),
                              child: Builder(builder: (context) {
                                return IconButton(
                                  padding: const EdgeInsets.all(0.0),
                                  iconSize: 30,
                                  icon: const Icon(
                                    Icons.menu_outlined,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    Scaffold.of(context).openDrawer();
                                  },
                                );
                              }),
                            ),
                          ),
                          addHorizontalSpace(30),
                          const Text(
                            'Home',
                            style: TextStyle(
                                fontSize: 27, fontWeight: FontWeight.w700),
                          )
                        ],
                      ),
                      addVerticalSpace(20),
                      Center(
                        child: Text(
                          First_Name.length > 10
                              ? "$greeting\n$First_Name"
                              : "$greeting $First_Name",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Appointments(
                                            user: widget.user,
                                            patient_ID: id,
                                          )),
                                );
                              },
                              child: Container(
                                height: 100,
                                width: width * 0.42,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.blue),
                                child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: const <Widget>[
                                            Text(
                                              "View\nAppointments",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                  fontSize: 14),
                                            ),
                                            Material(
                                              color: Colors.transparent,
                                              child: CircleAvatar(
                                                  backgroundColor:
                                                      Colors.white54,
                                                  radius: 18,
                                                  child: Icon(
                                                    Icons.read_more,
                                                    color: Colors.white,
                                                  )),
                                            )
                                          ],
                                        ),
                                        //addVerticalSpace(15),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            const Text(
                                              "Appointments",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14),
                                            ),
                                            Text(
                                              total_appointments.toString(),
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        )
                                      ],
                                    )),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Manage_Info(
                                            user: widget.user,
                                            pm: Data(patient),
                                            ID: id,
                                          )),
                                );
                              },
                              child: Container(
                                height: 100,
                                width: width * 0.42,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.blue),
                                child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: const <Widget>[
                                            Text(
                                              "Mange Your\nInformation",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                  fontSize: 16),
                                            ),
                                            Material(
                                              color: Colors.transparent,
                                              child: CircleAvatar(
                                                  backgroundColor:
                                                      Colors.white54,
                                                  radius: 18,
                                                  child: Icon(
                                                    Icons.edit,
                                                    color: Colors.white,
                                                  )),
                                            )
                                          ],
                                        ),
                                        //addVerticalSpace(15),
                                      ],
                                    )),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Make_Appointment(
                                            user: widget.user,
                                            appointment: 'New',
                                            patient_ID: id,
                                            appointment_ID: '',
                                          )),
                                );
                              },
                              child: Container(
                                width: width * 0.87,
                                padding: const EdgeInsets.only(right: 0),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.blue),
                                child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.calendar_month_outlined,
                                              color: Colors.white,
                                              size: 25,
                                            ),
                                            addHorizontalSpace(10),
                                            const Text(
                                              "Make Appointments With Doctor.",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: const [
                                            CircleAvatar(
                                                backgroundColor: Colors.white54,
                                                radius: 18,
                                                child: Icon(
                                                  Icons.notifications,
                                                  color: Colors.white,
                                                )),
                                          ],
                                        ),
                                      ],
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Patient_Reports(
                                            user: widget.user,
                                            patientId: id,
                                          )),
                                );
                              },
                              child: Container(
                                width: width * 0.87,
                                padding: const EdgeInsets.only(right: 0),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.blue),
                                child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.medical_information,
                                              color: Colors.white,
                                              size: 25,
                                            ),
                                            addHorizontalSpace(10),
                                            const Text(
                                              "View Your Medical Reports",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: const [
                                            CircleAvatar(
                                                backgroundColor: Colors.white54,
                                                radius: 18,
                                                child: Icon(
                                                  Icons.edit_document,
                                                  color: Colors.white,
                                                )),
                                          ],
                                        ),
                                      ],
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                      addVerticalSpace(25),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              "Your Details",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      addVerticalSpace(10),
                      Container(
                        width: width * 0.9,
                        height: height * 0.4,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.blue),
                        child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Patient_Details(width)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  SingleChildScrollView Patient_Details(double width) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Text(
                        "Full Name",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(15),
                        width: width * 0.8,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '$First_Name $Last_Name',
                                style: const TextStyle(color: Colors.black),
                              ),
                              GestureDetector(
                                onTap: () {
                                  FlutterClipboard.copy(
                                          '$First_Name $Last_Name')
                                      .then((value) => ScaffoldMessenger.of(
                                              context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Text Copped to Clipboard!'))));
                                },
                                child: const Icon(
                                  Icons.copy_outlined,
                                  color: Colors.blue,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                addVerticalSpace(20),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Text(
                        "Date Of Birth",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(15),
                        width: width * 0.8,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                DOB,
                                style: const TextStyle(color: Colors.black),
                              ),
                              GestureDetector(
                                onTap: () {
                                  FlutterClipboard.copy(DOB).then((value) =>
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Text Copped to Clipboard!'))));
                                },
                                child: const Icon(
                                  Icons.copy_outlined,
                                  color: Colors.blue,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                addVerticalSpace(20),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Text(
                        "Gender",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(15),
                        width: width * 0.8,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                Gender,
                                style: const TextStyle(color: Colors.black),
                              ),
                              GestureDetector(
                                onTap: () {
                                  FlutterClipboard.copy(DOB).then((value) =>
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Text Copped to Clipboard!'))));
                                },
                                child: const Icon(
                                  Icons.copy_outlined,
                                  color: Colors.blue,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                addVerticalSpace(20),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Text(
                        "Contact",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(15),
                        width: width * 0.8,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                Contact,
                                style: const TextStyle(color: Colors.black),
                              ),
                              GestureDetector(
                                onTap: () {
                                  FlutterClipboard.copy(Contact).then((value) =>
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Text Copped to Clipboard!'))));
                                },
                                child: const Icon(
                                  Icons.copy_outlined,
                                  color: Colors.blue,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                addVerticalSpace(20),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Text(
                        "Address",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(15),
                        width: width * 0.8,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                Address,
                                style: const TextStyle(color: Colors.black),
                              ),
                              GestureDetector(
                                onTap: () {
                                  FlutterClipboard.copy(Address).then((value) =>
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Text Copped to Clipboard!'))));
                                },
                                child: const Icon(
                                  Icons.copy_outlined,
                                  color: Colors.blue,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                addVerticalSpace(20),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Text(
                        "Health Insurance ID",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(15),
                        width: width * 0.8,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                HealthInsuranceID,
                                style: const TextStyle(color: Colors.black),
                              ),
                              GestureDetector(
                                onTap: () {
                                  FlutterClipboard.copy(HealthInsuranceID).then(
                                      (value) => ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Text Copped to Clipboard!'))));
                                },
                                child: const Icon(
                                  Icons.copy_outlined,
                                  color: Colors.blue,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                addVerticalSpace(20),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Text(
                        "Emergency Contact",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(15),
                        width: width * 0.8,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                EmergencyContact,
                                style: const TextStyle(color: Colors.black),
                              ),
                              GestureDetector(
                                onTap: () {
                                  FlutterClipboard.copy(EmergencyContact).then(
                                      (value) => ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Text Copped to Clipboard!'))));
                                },
                                child: const Icon(
                                  Icons.copy_outlined,
                                  color: Colors.blue,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                addVerticalSpace(20),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Text(
                        "Medical History",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(15),
                        width: width * 0.8,
                        height: 80,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                MedicalHistory,
                                style: const TextStyle(color: Colors.black),
                              ),
                              GestureDetector(
                                onTap: () {
                                  FlutterClipboard.copy(MedicalHistory).then(
                                      (value) => ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Text Copped to Clipboard!'))));
                                },
                                child: const Icon(
                                  Icons.copy_outlined,
                                  color: Colors.blue,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                addVerticalSpace(20),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Text(
                        "Allergies and Medications",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(15),
                        width: width * 0.8,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                Allergies_Medication,
                                style: const TextStyle(color: Colors.black),
                              ),
                              GestureDetector(
                                onTap: () {
                                  FlutterClipboard.copy(Allergies_Medication)
                                      .then((value) => ScaffoldMessenger.of(
                                              context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Text Copped to Clipboard!'))));
                                },
                                child: const Icon(
                                  Icons.copy_outlined,
                                  color: Colors.blue,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                addVerticalSpace(20),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Text(
                        "Preffered Health Care",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(15),
                        width: width * 0.8,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                Prefrence,
                                style: const TextStyle(color: Colors.black),
                              ),
                              GestureDetector(
                                onTap: () {
                                  FlutterClipboard.copy(Prefrence).then(
                                      (value) => ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Text Copped to Clipboard!'))));
                                },
                                child: const Icon(
                                  Icons.copy_outlined,
                                  color: Colors.blue,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
