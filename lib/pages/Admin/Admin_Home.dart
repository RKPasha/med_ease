import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:med_ease/models/Doctors_Model.dart';
import 'package:med_ease/models/Patient_Model.dart';
import 'package:med_ease/models/Report_Model.dart';
import 'package:med_ease/pages/Admin/Admin_Add.dart';
import 'package:med_ease/pages/Admin/Admin_Manage.dart';
import 'package:med_ease/pages/Admin/admin_side_navbar.dart';
import 'package:med_ease/pages/Doctor/Manage_Reports.dart';
import 'package:med_ease/services/remort_services.dart';
import 'package:med_ease/utils/widgets_function.dart';

class Admin_Home extends StatefulWidget {
  final User user;
  const Admin_Home({super.key, required this.user});

  @override
  State<Admin_Home> createState() => _Admin_HomeState();
}

class _Admin_HomeState extends State<Admin_Home> {
  List<Patient_Model>? allPatients;
  List<Doctor_Model>? allDoctors;
  List<Report_Model>? allReports;

  bool isLoaded = false;
  int totalPatients = 0;
  int totalDoctors = 0;

  getData() async {
    allDoctors = await remort_services().getDoctors();
    allPatients = await remort_services().getPatients();
    allReports = await remort_services().getAllReports();
    if (allPatients != null) {
      setState(() {
        isLoaded = true;
        totalPatients = allPatients!.length;
      });
    }
    if (allDoctors != null) {
      setState(() {
        totalDoctors = allDoctors!.length;
      });
    }
  }

  loading() {
    return const Scaffold(
      // color: Colors.white,
      body: Center(child: CircularProgressIndicator()),
    );
  }

  List<DataRow> populateTable() {
    return List<DataRow>.generate(
        allPatients!.length,
        (index) => DataRow(cells: [
              DataCell(Text(
                  '${allPatients![index].First_Name} ${allPatients![index].Last_Name}')),
              DataCell(Text(allPatients![index].Contact)),
              DataCell(Text(allPatients![index].Prefrence)),
            ]));
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

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
    String? userEmail = widget.user.email;
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

    ScrollController scollBarController = ScrollController();
    return isLoaded == false
        ? loading()
        : WillPopScope(
            onWillPop: () async {
              bool? result = await _onBackPressed();
              result ??= false;
              return result;
            },
            child: Scaffold(
              drawer: AdminSideNav(
                user: widget.user,
              ),
              body: SingleChildScrollView(
                controller: scollBarController,
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[
                      addVerticalSpace(30),
                      Row(
                        children: [
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
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                greeting,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '$userEmail',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          )
                        ],
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
                                      builder: (context) => Admin_Add(
                                            add: 'Patient',
                                            user: widget.user,
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
                                              "Add Patient",
                                              style: TextStyle(
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
                                                    CupertinoIcons.add,
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
                                              "Total Patients",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14),
                                            ),
                                            Text(
                                              totalPatients.toString(),
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
                                      builder: (context) => Admin_Add(
                                            add: 'Doctor',
                                            user: widget.user,
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
                                              "Add Doctor",
                                              style: TextStyle(
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
                                                    CupertinoIcons.add,
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
                                              "Total Doctors",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14),
                                            ),
                                            Text(
                                              totalDoctors.toString(),
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
                          ],
                        ),
                      ),
                      Container(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Admin_Manage(
                                            manage: 'Patients',
                                            user: widget.user,
                                          )),
                                );
                              },
                              child: Container(
                                width: width * 0.90,
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
                                              Icons.manage_accounts_outlined,
                                              color: Colors.white,
                                              size: 25,
                                            ),
                                            addHorizontalSpace(10),
                                            const Text(
                                              "Mange Patients",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: const [
                                            Icon(
                                              Icons.chevron_right_outlined,
                                              color: Colors.white,
                                              size: 30,
                                            ),
                                          ],
                                        ),
                                      ],
                                    )),
                              ),
                            ),
                            addVerticalSpace(10),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Admin_Manage(
                                            manage: 'Doctors',
                                            user: widget.user,
                                          )),
                                );
                              },
                              child: Container(
                                width: width * 0.90,
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
                                              Icons.manage_accounts_outlined,
                                              color: Colors.white,
                                              size: 25,
                                            ),
                                            addHorizontalSpace(10),
                                            const Text(
                                              "Manage Doctors",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: const [
                                            Icon(
                                              Icons.chevron_right_outlined,
                                              color: Colors.white,
                                              size: 30,
                                            ),
                                          ],
                                        ),
                                      ],
                                    )),
                              ),
                            ),
                            addVerticalSpace(10),
                            GestureDetector(
                              onTap: () {
                                if (allReports!.isNotEmpty) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Manage_Reports(
                                              user: widget.user,
                                              accessedFrom: 'Admin',
                                              docId: '',
                                            )),
                                  );
                                } else {
                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      title: const Text('Operation Denied!'),
                                      content: const Text('No Record Found!'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, 'Cancel'),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, 'OK'),
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                width: width * 0.90,
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
                                              Icons
                                                  .medical_information_outlined,
                                              color: Colors.white,
                                              size: 25,
                                            ),
                                            addHorizontalSpace(10),
                                            const Text(
                                              "Mange Medical Reports",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: const [
                                            Icon(
                                              Icons.chevron_right_outlined,
                                              color: Colors.white,
                                              size: 30,
                                            ),
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
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Text(
                                'Recent Data',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      addVerticalSpace(10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: width * 0.9,
                            height: height * 0.4,
                            padding: const EdgeInsets.only(right: 00),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.blue),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 5.0, right: 5.0, left: 5.0, bottom: 8.0),
                              child: SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                child: DataTable(
                                  headingTextStyle:
                                      const TextStyle(color: Colors.white),
                                  dataTextStyle:
                                      const TextStyle(color: Colors.black),
                                  showBottomBorder: true,
                                  headingRowColor:
                                      const MaterialStatePropertyAll(
                                          Colors.blue),
                                  dataRowColor: const MaterialStatePropertyAll(
                                      Colors.white),
                                  border: TableBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  columnSpacing: width * 0.11,
                                  columns: const [
                                    DataColumn(
                                      label: Text('Patient'),
                                    ),
                                    DataColumn(
                                      label: Text('Contact'),
                                    ),
                                    DataColumn(
                                      label: Text('Preference'),
                                    ),
                                  ],
                                  rows: populateTable(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
