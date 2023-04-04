import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:med_ease/api/pdf_api.dart';
import 'package:med_ease/api/pdf_paragraph_api.dart';
import 'package:med_ease/models/Doctors_Model.dart';
import 'package:med_ease/pages/Admin/Admin_Home.dart';
import 'package:med_ease/pages/Doctor/Doctor_Home.dart';
import 'package:med_ease/pages/Doctor/Reports.dart';
import 'package:med_ease/pages/Patient/Patient_Home.dart';
import 'package:med_ease/utils/widgets_function.dart';

import '../../models/Report_Model.dart';
import '../../services/remort_services.dart';

class Patient_Reports extends StatefulWidget {
  final String patientId;
  final User user;
  const Patient_Reports(
      {super.key, required this.user, required this.patientId});

  @override
  State<Patient_Reports> createState() => _Patient_ReportsState();
}

class _Patient_ReportsState extends State<Patient_Reports> {
  bool isLoaded = false;
  TextEditingController query = TextEditingController();
  String _clinic = '';
  String docname = '';
  bool isfetched = false;
  bool pressed = false;
  List<Report_Model>? reports;
  List<Report_Model>? allreports;

  Icon cusIcon = const Icon(
    Icons.search,
    color: Colors.white,
  );
  late Widget bar =
      const Text('Manage Reports', style: TextStyle(color: Colors.white));

  getData() async {
    allreports =
        await remort_services().getAllReports_byPatient(widget.patientId);
    reports = await remort_services().getAllReports_byPatient(widget.patientId);
    if (allreports != null && reports != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  SearchResults_Reports(String Query) {
    final Suggestions = allreports!.where((report) {
      final date = report.Date;
      return date.contains(Query);
    }).toList();
    setState(() {
      reports = Suggestions;
    });
  }

  deleteReport(String id) async {
    try {
      await remort_services().DeleteReport(id);
    } catch (e) {
      print(e);
    }
  }

  List<Doctor_Model>? list;
  GetDoc(String DocId, int num) async {
    list = await remort_services().getDoctorbyId(DocId);
    if (list != null) {
      fetchDoc_Clinic(num);
    }
  }

  fetchDoc_Clinic(int num) {
    if (num == 1) {
      setState(() {
        docname = list![0].First_Name + ' ' + list![0].Last_Name;
      });
    } else {
      setState(() {
        _clinic = list![0].Clinic;
        isfetched = true;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getData();
  }

  Future<bool?> _onBackPressed() async {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Patient_Home(
                user: widget.user,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScrollController scollBarController = ScrollController();

    return WillPopScope(
      onWillPop: () async {
        bool? result = await _onBackPressed();
        result ??= false;
        return result;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Patient_Home(
                          user: widget.user,
                        )),
              );
            },
          ),
          centerTitle: true,
          title: bar,
          //backgroundColor: Color.fromRGBO(68, 60, 104, 1.0),
          actions: <Widget>[
            IconButton(
                icon: cusIcon,
                onPressed: () {
                  setState(() {
                    if (pressed == false) {
                      this.cusIcon =
                          const Icon(Icons.cancel, color: Colors.white);
                      this.bar = Padding(
                        padding: const EdgeInsets.only(top: 50, bottom: 50),
                        child: TextField(
                            onChanged: (value) {
                              setState(() {
                                SearchResults_Reports(query.text);
                              });
                            },
                            controller: query,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                            decoration: InputDecoration(
                              hintText: "Search",
                              fillColor: Colors.white,
                              filled: true,
                              hintStyle: const TextStyle(color: Colors.black),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5)),
                            )),
                      );
                      pressed = true;
                    } else {
                      SearchResults_Reports('');
                      query.text = '';
                      this.cusIcon =
                          const Icon(Icons.search, color: Colors.white);
                      this.bar = const Text("Your Medical Reports");
                      pressed = false;
                    }
                  });
                }),
            IconButton(
                icon: const Icon(
                  Icons.info,
                  color: Colors.white,
                ),
                onPressed: () {}),
          ],
          // bottom: PreferredSize(preferredSize: Size(50, 50),
          // child:Container() ,
          // ),
        ),
        body: Scrollbar(
          controller: scollBarController,
          child: Visibility(
            visible: isLoaded,
            replacement: Center(
              child: const CircularProgressIndicator(),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: _patient(),
            ),
          ),
        ),
      ),
    );
  }

  ListView _patient() {
    return ListView.builder(
      itemCount: reports?.length,
      itemBuilder: (context, index) {
        const Text('Swipe right to Access Delete method');

        return Slidable(
          // Specify a key if the Slidable is dismissible.
          key: Key(reports![index].id),

          // The start action pane is the one at the left or the top side.
          // startActionPane: ActionPane(
          //   // A motion is a widget used to control how the pane animates.
          //   motion: const ScrollMotion(),

          //   // A pane can dismiss the Slidable.
          //   dismissible: DismissiblePane(
          //     key: Key(reports![index].id),
          //     onDismissed: () {
          //       deleteReport(reports![index].id);
          //       // Then show a snackbar.
          //       ScaffoldMessenger.of(context).showSnackBar(
          //           const SnackBar(content: Text('Report Deleted!')));
          //     },
          //   ),

          //   // All actions are defined in the children parameter.
          //   children: const [
          //     // A SlidableAction can have an icon and/or a label.
          //     SlidableAction(
          //       onPressed: null,
          //       backgroundColor: Colors.white,
          //       foregroundColor: Colors.blue,
          //       icon: Icons.delete,
          //       label: 'Swipe Right to Delete',
          //     ),
          //   ],
          // ),

          // The end action pane is the one at the right or the bottom side.
          // endActionPane: ActionPane(
          //   motion: const ScrollMotion(),
          //   children: [
          //     SlidableAction(
          //       // An action can be bigger than the others.
          //       flex: 2,
          //       onPressed: (context) {
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //               builder: (context) => Reports(
          //                     date: reports![index].Date,
          //                     description: reports![index].Description,
          //                     docID: reports![index].DoctorID,
          //                     patientID: reports![index].PatientID,
          //                     patientName: reports![index].PatientName,
          //                     reportId: reports![index].id,
          //                     time: reports![index].Time,
          //                     user: widget.user,
          //                     type: 'Update',
          //                     accessedFrom: widget.accessedFrom,
          //                   )),
          //         );
          //       },
          //       backgroundColor: Colors.white,
          //       foregroundColor: Colors.blue,
          //       icon: Icons.edit,
          //       label: 'Edit',
          //     ),
          //   ],
          // ),
          child: Container(
              width: 10000,
              height: 160,
              child: GestureDetector(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => ViewDetails_Patient(
                    //             user: widget.user,
                    //             detailsOf: "Patient",
                    //             Address: patients![index].Address,
                    //             Allergies_Medication:
                    //                 patients![index].Allergies_Medication,
                    //             Contact: patients![index].Contact,
                    //             DOB: patients![index].DOB,
                    //             Email: patients![index].Email,
                    //             EmergencyContact:
                    //                 patients![index].EmergencyContact,
                    //             First_Name: patients![index].First_Name,
                    //             Gender: patients![index].Gender,
                    //             HealthInsuranceID:
                    //                 patients![index].HealthInsuranceID,
                    //             Information: patients![index].Information,
                    //             Last_Name: patients![index].Last_Name,
                    //             MedicalHistory: patients![index].MedicalHistory,
                    //             Password: '',
                    //             Prefrence: patients![index].Prefrence,
                    //             accessedFrom: 'Doctor',
                    //             docID: widget.docId,
                    //           )),
                    // );
                  },
                  child: Card(
                    margin: const EdgeInsets.all(5),
                    color: Colors.blue,
                    shadowColor: Colors.white,
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Row(
                            children: const [
                              Icon(
                                Icons.download,
                                color: Colors.white,
                              ),
                              Text(
                                "Tap on Get PDF and wait for few seconds.",
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                          addVerticalSpace(10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5)),
                                width: 200,
                                padding: const EdgeInsets.all(8),
                                child: RichText(
                                  //remove const when integrating DB
                                  text: TextSpan(
                                      style: const TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.black,
                                      ),
                                      children: <TextSpan>[
                                        const TextSpan(
                                            text: 'Name   : ',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black)),
                                        TextSpan(
                                            text: reports?[index].PatientName),
                                        const TextSpan(
                                            text: '\nDoctor : ',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w800,
                                                color: Colors.black)),
                                        TextSpan(text: reports?[index].Date),
                                        const TextSpan(
                                            text: '\nTime    : ',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w800,
                                                color: Colors.black)),
                                        TextSpan(text: reports?[index].Time),
                                      ]),
                                ),
                              ),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          try {
                                            GetDoc(reports![index].DoctorID, 1);
                                            GetDoc(reports![index].DoctorID, 2);
                                            Future.delayed(
                                                const Duration(
                                                    milliseconds: 500),
                                                () async {
                                              final pdfFile =
                                                  await PdfParagraphApi
                                                      .generate(
                                                          _clinic,
                                                          docname,
                                                          reports![index]
                                                              .PatientName,
                                                          reports![index].Date,
                                                          reports![index].Time,
                                                          reports![index]
                                                              .Description);
                                              PdfApi.openFile(pdfFile);
                                            });
                                          } catch (e) {
                                            print(e);
                                          }
                                        },
                                        child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.white),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(13.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "Get PDF",
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 3.0),
                                                    child: Icon(
                                                      Icons.get_app_outlined,
                                                      color: Colors.blue,
                                                      size: 20,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )),
                                      )
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ))),
        );
      },
    );
  }
}
