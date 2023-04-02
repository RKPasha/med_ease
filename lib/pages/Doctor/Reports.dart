import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:med_ease/models/Report_Model.dart';
import 'package:med_ease/services/remort_services.dart';

import '../../utils/constants.dart';
import '../../utils/widgets_function.dart';
import 'Generate_Reports.dart';
import 'Manage_Reports.dart';

class Reports extends StatefulWidget {
  final String type;
  final String accessedFrom;
  final String patientID;
  final String patientName;
  final String date;
  final String time;
  final String description;
  final String reportId;
  final String docID;
  final User user;
  const Reports(
      {super.key,
      required this.docID,
      required this.user,
      required this.patientID,
      required this.patientName,
      required this.date,
      required this.time,
      required this.description,
      required this.reportId,
      required this.type,
      required this.accessedFrom});

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  TextEditingController name = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController time = TextEditingController();
  TextEditingController description = TextEditingController();
  String patient_Id = '';
  String doctor_Id = '';

  setDate() {
    String currentDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
    return currentDate;
  }

  setTime() {
    String currentTime = DateFormat("hh:mm a").format(DateTime.now());
    return currentTime;
  }

  populate() {
    setState(() {
      name.text = widget.patientName;
      patient_Id = widget.patientID;
      doctor_Id = widget.docID;
      date.text = setDate();
      time.text = setTime();
    });
  }

  populate_Edit() {
    setState(() {
      name.text = widget.patientName;
      patient_Id = widget.patientID;
      doctor_Id = widget.docID;
      date.text = widget.date;
      time.text = widget.time;
      description.text = widget.description;
    });
  }

  createReport() async {
    try {
      Report_Model rm = Report_Model(
          id: '',
          DoctorID: widget.docID,
          PatientID: widget.patientID,
          PatientName: widget.patientName,
          Date: date.text,
          Time: time.text,
          Description: description.text,
          isDeleted: 0);
      await remort_services().CreateReport(rm);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  updateReport(String id) async {
    try {
      await remort_services().UpDate_Report(description.text, id);
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    print(widget.accessedFrom);
    if (widget.type == "Create") {
      populate();
    } else {
      populate_Edit();
    }
  }

  Future<bool?> _onBackPressed() async {
    if (widget.accessedFrom == 'Doctor' && widget.type == 'Create') {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Generate_Reports(
                  user: widget.user,
                  docId: widget.docID,
                  accessedFrom: widget.accessedFrom,
                )),
      );
    } else {
      if (widget.accessedFrom == 'Admin' && widget.type == 'Update') {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Manage_Reports(
                    user: widget.user,
                    accessedFrom: 'Admin',
                    docId: '',
                  )),
        );
      } else if (widget.accessedFrom == 'Doctor' && widget.type == 'Update') {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Manage_Reports(
                    user: widget.user,
                    accessedFrom: 'Doctor',
                    docId: widget.docID,
                  )),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool? result = await _onBackPressed();
        result ??= false;
        return result;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            backgroundColor: Colors.blue,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                if (widget.accessedFrom == 'Doctor' &&
                    widget.type == 'Create') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Generate_Reports(
                              user: widget.user,
                              docId: widget.docID,
                              accessedFrom: widget.accessedFrom,
                            )),
                  );
                } else {
                  if (widget.accessedFrom == 'Admin' &&
                      widget.type == 'Update') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Manage_Reports(
                                user: widget.user,
                                accessedFrom: 'Admin',
                                docId: '',
                              )),
                    );
                  } else if (widget.accessedFrom == 'Doctor' &&
                      widget.type == 'Update') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Manage_Reports(
                                user: widget.user,
                                accessedFrom: 'Doctor',
                                docId: widget.docID,
                              )),
                    );
                  }
                }
              },
            ),
            centerTitle: true,
            title: const SizedBox(
                height: 100,
                width: 120,
                child: Image(
                  image: AssetImage('assets/images/logo_white.png'),
                  fit: BoxFit.contain,
                ))),
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Form(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width,
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: Column(
                children: <Widget>[
                  addVerticalSpace(30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${widget.type} Report',
                        style: const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  addVerticalSpace(50),
                  Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${widget.type} Description For the \nFollowing Patient:',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            description.clear();
                          },
                          icon: const Icon(
                            Icons.clear,
                            size: 15,
                          ),
                          label: const Text(
                            'Clear',
                            style: TextStyle(fontSize: 12),
                          ),
                        )
                      ],
                    ),
                  ),
                  addVerticalSpace(25),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TextFormField(
                              controller: name,
                              enabled: false,
                              style: const TextStyle(fontSize: 14),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(5),
                                labelText: 'Name',
                                prefixIcon: const Icon(
                                  Icons.person,
                                  color: Colors.blue,
                                  size: 20,
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ],
                        ),
                        addVerticalSpace(20),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TextFormField(
                              controller: date,
                              enabled: false,
                              style: const TextStyle(fontSize: 14),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(5),
                                labelText: 'Date',
                                prefixIcon: const Icon(
                                  Icons.calendar_month_outlined,
                                  color: Colors.blue,
                                  size: 20,
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ],
                        ),
                        addVerticalSpace(20),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TextFormField(
                              controller: time,
                              enabled: false,
                              style: const TextStyle(fontSize: 14),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(5),
                                labelText: 'Time',
                                prefixIcon: const Icon(
                                  Icons.av_timer_outlined,
                                  color: Colors.blue,
                                  size: 20,
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ],
                        ),
                        addVerticalSpace(15),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TextFormField(
                              controller: description,
                              maxLines: 10,
                              style: const TextStyle(fontSize: 15),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(15),
                                labelText: 'Description',
                                prefixIcon: const Icon(
                                  Icons.description,
                                  color: Colors.blue,
                                  size: 20,
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ],
                        ),
                        addVerticalSpace(20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  fixedSize: const Size(100, 30),
                                  backgroundColor: Colors.blue,
                                ),
                                onPressed: () {
                                  if (widget.type == "Create") {
                                    if (description.text != "") {
                                      createReport();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              Generate_Reports(
                                            user: widget.user,
                                            docId: widget.docID,
                                            accessedFrom: 'Doctor',
                                          ),
                                        ),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content:
                                                  Text('Report Created!')));
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text('Input Missing!')));
                                    }
                                  } else {
                                    if (description.text != "") {
                                      updateReport(widget.reportId);
                                      print(widget.accessedFrom);
                                      if (widget.accessedFrom == 'Admin') {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                Manage_Reports(
                                              user: widget.user,
                                              docId: '',
                                              accessedFrom: widget.accessedFrom,
                                            ),
                                          ),
                                        );
                                      } else {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                Manage_Reports(
                                              user: widget.user,
                                              docId: widget.docID,
                                              accessedFrom: widget.accessedFrom,
                                            ),
                                          ),
                                        );
                                      }

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content:
                                                  Text('Report Updated!')));
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text('Input Missing!')));
                                    }
                                  }
                                },
                                icon: const Icon(
                                  Icons.save,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                label: Text(
                                  'Save',
                                  style: TEXT_THEME_DEFAULT.bodyText1,
                                )),
                            addHorizontalSpace(20),
                            OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  fixedSize: const Size(100, 30),
                                  backgroundColor: Colors.blue,
                                ),
                                onPressed: () {
                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      title: const Text('Go Back?'),
                                      content: const Text(
                                          'Are Your sure you want to go back?'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, 'Cancel'),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            if (widget.type == "Create") {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      Generate_Reports(
                                                    user: widget.user,
                                                    docId: widget.docID,
                                                    accessedFrom:
                                                        widget.accessedFrom,
                                                  ),
                                                ),
                                              );
                                            } else {
                                              if (widget.accessedFrom ==
                                                  'Doctor') {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Generate_Reports(
                                                            user: widget.user,
                                                            docId: widget.docID,
                                                            accessedFrom: widget
                                                                .accessedFrom,
                                                          )),
                                                );
                                              } else {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Manage_Reports(
                                                            user: widget.user,
                                                            accessedFrom:
                                                                'Admin',
                                                            docId: '',
                                                          )),
                                                );
                                              }
                                            }
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.exit_to_app_outlined,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                label: Text(
                                  'Back',
                                  style: TEXT_THEME_DEFAULT.bodyText1,
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
