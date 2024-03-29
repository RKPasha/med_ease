import 'package:clipboard/clipboard.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:med_ease/pages/Doctor/Manage_Patients.dart';

import '../../utils/widgets_function.dart';
import 'Admin_Drawer.dart';
import 'Admin_Manage.dart';

class ViewDetails_Patient extends StatefulWidget {
  final User user;
  final String detailsOf;
  final String First_Name;
  final String Last_Name;
  final String DOB;
  final String Gender;
  final String Contact;
  final String Address;
  final String HealthInsuranceID;
  final String EmergencyContact;
  final String MedicalHistory;
  final String Allergies_Medication;
  final String Prefrence;
  final String Email;
  final String Password;
  final String Information;
  final String accessedFrom;
  final String docID;

  ViewDetails_Patient(
      {super.key,
      required this.user,
      required this.detailsOf,
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
      required this.Password,
      required this.Information,
      required this.accessedFrom,
      required this.docID});

  @override
  State<ViewDetails_Patient> createState() => _ViewDetails_PatientState();
}

class _ViewDetails_PatientState extends State<ViewDetails_Patient> {
  String? _user = '';

  @override
  void initState() {
    _user = widget.user.email;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    ScrollController scollBarController = ScrollController();

    Display() {
      //print(this.show_detailsOf);
      if (widget.detailsOf == 'Patient') {
        return Patient_Details(width);
      }
    }

    Future<bool?> _onBackPressed() async {
      if (widget.accessedFrom == "Admin") {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  Admin_Manage(manage: widget.detailsOf, user: widget.user)),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Manage_Patients(
                    user: widget.user,
                    docId: widget.docID,
                  )),
        );
      }
    }

    return WillPopScope(
      onWillPop: () async {
        bool? result = await _onBackPressed();
        result ??= false;
        return result;
      },
      child: Scaffold(
          drawer: Admin_Drawer(
            User: _user.toString(),
          ),
          body: SingleChildScrollView(
              controller: scollBarController,
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(children: <Widget>[
                  addVerticalSpace(30),
                  Row(children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 0.0),
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
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              if (widget.accessedFrom == "Admin") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Admin_Manage(
                                          manage: widget.detailsOf,
                                          user: widget.user)),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Manage_Patients(
                                            user: widget.user,
                                            docId: widget.docID,
                                          )),
                                );
                              }
                            },
                          );
                        }),
                      ),
                    ),
                    addHorizontalSpace(30),
                    Text(
                      'View Details (${widget.detailsOf})',
                      style: const TextStyle(
                          fontSize: 27, fontWeight: FontWeight.w700),
                    )
                  ]),
                  addVerticalSpace(50),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: height * 0.75,
                        width: width * 0.9,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.blue)),
                        child: Display(),
                      ),
                    ],
                  )
                ]),
              ))),
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
                  padding: const EdgeInsets.only(left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        "Full Name",
                        style: TextStyle(color: Colors.white, fontSize: 18),
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
                                widget.First_Name + ' ' + widget.Last_Name,
                                style: const TextStyle(color: Colors.black),
                              ),
                              GestureDetector(
                                onTap: () {
                                  FlutterClipboard.copy(widget.First_Name +
                                          ' ' +
                                          widget.Last_Name)
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
                  padding: const EdgeInsets.only(left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        "Date Of Birth",
                        style: TextStyle(color: Colors.white, fontSize: 18),
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
                                widget.DOB,
                                style: const TextStyle(color: Colors.black),
                              ),
                              GestureDetector(
                                onTap: () {
                                  FlutterClipboard.copy(widget.DOB).then(
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
                  padding: const EdgeInsets.only(left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        "Gender",
                        style: TextStyle(color: Colors.white, fontSize: 18),
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
                                widget.Gender,
                                style: const TextStyle(color: Colors.black),
                              ),
                              GestureDetector(
                                onTap: () {
                                  FlutterClipboard.copy(widget.DOB).then(
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
                  padding: const EdgeInsets.only(left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        "Contact",
                        style: TextStyle(color: Colors.white, fontSize: 18),
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
                                widget.Contact,
                                style: const TextStyle(color: Colors.black),
                              ),
                              GestureDetector(
                                onTap: () {
                                  FlutterClipboard.copy(widget.Contact).then(
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
                  padding: const EdgeInsets.only(left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        "Address",
                        style: TextStyle(color: Colors.white, fontSize: 18),
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
                                widget.Address,
                                style: const TextStyle(color: Colors.black),
                              ),
                              GestureDetector(
                                onTap: () {
                                  FlutterClipboard.copy(widget.Address).then(
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
                  padding: const EdgeInsets.only(left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        "Health Insurance ID",
                        style: TextStyle(color: Colors.white, fontSize: 18),
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
                                widget.HealthInsuranceID,
                                style: const TextStyle(color: Colors.black),
                              ),
                              GestureDetector(
                                onTap: () {
                                  FlutterClipboard.copy(
                                          widget.HealthInsuranceID)
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
                  padding: const EdgeInsets.only(left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        "Emergency Contact",
                        style: TextStyle(color: Colors.white, fontSize: 18),
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
                                widget.EmergencyContact,
                                style: const TextStyle(color: Colors.black),
                              ),
                              GestureDetector(
                                onTap: () {
                                  FlutterClipboard.copy(widget.EmergencyContact)
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
                  padding: const EdgeInsets.only(left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        "Medical History",
                        style: TextStyle(color: Colors.white, fontSize: 18),
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
                                widget.MedicalHistory,
                                style: const TextStyle(color: Colors.black),
                              ),
                              GestureDetector(
                                onTap: () {
                                  FlutterClipboard.copy(widget.MedicalHistory)
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
                  padding: const EdgeInsets.only(left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        "Allergies and Medications",
                        style: TextStyle(color: Colors.white, fontSize: 18),
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
                                widget.Allergies_Medication,
                                style: const TextStyle(color: Colors.black),
                              ),
                              GestureDetector(
                                onTap: () {
                                  FlutterClipboard.copy(
                                          widget.Allergies_Medication)
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
                  padding: const EdgeInsets.only(left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        "Preffered Health Care",
                        style: TextStyle(color: Colors.white, fontSize: 18),
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
                                widget.Prefrence,
                                style: const TextStyle(color: Colors.black),
                              ),
                              GestureDetector(
                                onTap: () {
                                  FlutterClipboard.copy(widget.Prefrence).then(
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
