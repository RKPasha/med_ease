import 'package:clipboard/clipboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:med_ease/models/Appointments_Model.dart';
import 'package:med_ease/pages/Doctor/Doctor_SignUp.dart';
import 'package:med_ease/pages/Doctor/doctor_side_navbar.dart';
import 'package:med_ease/services/remort_services.dart';
import '../../models/Doctors_Model.dart';
import '../../models/Report_Model.dart';
import '../../utils/widgets_function.dart';
import '../Patient/Patient_Side_Menu.dart';
import 'Appnintment_Requests.dart';
import 'Generate_Reports.dart';
import 'Manage_Patients.dart';
import 'Manage_Reports.dart';
import 'View_Appointments.dart';

class Doctor_Home extends StatefulWidget {
  final User user;
  const Doctor_Home({super.key, required this.user});

  @override
  State<Doctor_Home> createState() => _Doctor_HomeState();
}

class _Doctor_HomeState extends State<Doctor_Home> {
  List<Doctor_Model>? all_doctors;
  List<Doctor_Model>? docs;
  List<Appointments_Model>? appointments;
  List<Appointments_Model>? approvedappointments;
  List<Report_Model>? reports;
  String id = '';
  String contact = '';
  int total_appointments = 0;
  bool loaded = false;
  int total_reports = 0;

  loading() {
    return Container(
      color: Colors.white,
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  getData() async {
    all_doctors = await remort_services().getDoctors();
    SearchResults();
  }

  TotalAppointments() async {
    int counter = 0;
    appointments = await remort_services().getAllAppointments_byDoctor(id);
    approvedappointments =
        await remort_services().getApprovedAppointments_byDoctor(id);
    if (appointments != null) {
      for (int i = 0; i < appointments!.length; i++) {
        if (appointments![i].isapproved == 0) {
          counter = counter + 1;
        }
      }
      setState(() {
        total_appointments = counter;
      });
    } else {
      setState(() {
        total_appointments = 0;
      });
    }
  }

  TotalReports() async {
    int counter = 0;
    reports = await remort_services().getAllReports_byDoctor(id);
    if (reports != null) {
      for (int i = 0; i < reports!.length; i++) {
        counter = counter + 1;
      }
      setState(() {
        total_reports = counter;
      });
    } else {
      setState(() {
        total_reports = 0;
      });
    }
  }

  notification() {
    if (total_appointments != 0) {
      return IconButton(
          onPressed: () {},
          icon: Stack(
            children: const <Widget>[
              Icon(
                Icons.notifications,
                color: Colors.white,
              ),
              Positioned(
                  left: 15.0,
                  child: Icon(
                    Icons.brightness_1,
                    color: Colors.red,
                    size: 9.0,
                  ))
            ],
          ));
    } else {
      return const Icon(
        Icons.notifications,
        color: Colors.white,
      );
    }
  }

  SearchResults() {
    final Suggestions = all_doctors!.where((doc) {
      final email = doc.Email;
      return email.contains(widget.user.email.toString());
    }).toList();
    setState(() {
      docs = Suggestions;
      if (CheckData()) {
        Populate(docs);
        TotalAppointments();
        TotalReports();
        setState(() {
          loaded = true;
        });
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Doctor_SignUp(
                    user: widget.user,
                    dm: Doctor_Model(
                        id: docs![0].id,
                        First_Name: docs![0].First_Name,
                        Certification: docs![0].Certification,
                        Gender: docs![0].Gender,
                        Last_Name: docs![0].Last_Name,
                        Experience: docs![0].Experience,
                        Experties: docs![0].Experties,
                        Contact: docs![0].Contact,
                        InsuranceID: docs![0].InsuranceID,
                        LiabilityID: docs![0].LiabilityID,
                        LicenseNo: docs![0].LicenseNo,
                        Publication: docs![0].Publication,
                        Specialist: docs![0].Specialist,
                        Email: docs![0].Email,
                        isDeleted: 0,
                        Clinic: docs![0].Clinic,
                        Degree: docs![0].Degree,
                        EducationTrainingID: docs![0].EducationTrainingID),
                  )),
        );
      }
    });
  }

  bool CheckData() {
    if (docs![0].Certification == 'Not Yet Added') {
      return false;
    } else {
      return true;
    }
  }

  Populate(List<Doctor_Model>? doc) {
    id = doc![0].id;
    Certification = doc[0].Certification;
    EducationTrainingID = doc[0].EducationTrainingID;
    Gender = doc[0].Gender;
    Degree = doc[0].Degree;
    Clinic = doc[0].Clinic;
    First_Name = doc[0].First_Name;
    Last_Name = doc[0].Last_Name;
    Experience = doc[0].Experience;
    Experties = doc[0].Experties;
    Contact = doc[0].Contact;
    InsuranceID = doc[0].InsuranceID;
    LiabilityID = doc[0].LiabilityID;
    LicenseNo = doc[0].LicenseNo;
    Publication = doc[0].Publication;
    Specialist = doc[0].Specialist;
    Email = doc[0].Email;
  }

  Data(List<Doctor_Model>? doc) {
    Doctor_Model dm = Doctor_Model(
      id: id,
      Certification: doc![0].Certification,
      EducationTrainingID: doc[0].EducationTrainingID,
      Gender: doc[0].Gender,
      Degree: doc[0].Degree,
      Clinic: doc[0].Clinic,
      First_Name: doc[0].First_Name,
      Last_Name: doc[0].Last_Name,
      Experience: doc[0].Experience,
      Experties: doc[0].Experties,
      Contact: doc[0].Contact,
      InsuranceID: doc[0].InsuranceID,
      LiabilityID: doc[0].LiabilityID,
      LicenseNo: doc[0].LicenseNo,
      Publication: doc[0].Publication,
      Specialist: doc[0].Specialist,
      Email: doc[0].Email,
      isDeleted: 0,
    );
    return dm;
  }

  @override
  void initState() {
    getData();
  }

  String Certification = "";
  int EducationTrainingID = 0;
  String Gender = "";
  String Degree = "";
  String Clinic = "";
  String First_Name = "";
  String Last_Name = "";
  int Experience = 0;
  String Experties = "";
  String Contact = "";
  int InsuranceID = 0;
  int LiabilityID = 0;
  String LicenseNo = "";
  String Publication = "";
  String Specialist = "";
  String Email = "";
  int isDeleted = 0;

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
              drawer: DoctorSideNav(
                name: '$First_Name $Last_Name',
                user: widget.user,
                id: id,
                approvedappointments: approvedappointments,
                docs: docs,
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
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                (First_Name.length < 10)
                                    ? '$greeting $First_Name'
                                    : '$greeting\n$First_Name',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
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
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  if (approvedappointments!.isNotEmpty) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Generate_Reports(
                                                user: widget.user,
                                                docId: id,
                                                accessedFrom: 'Doctor',
                                              )),
                                    );
                                  } else {
                                    showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        title: const Text('Operation Denied'),
                                        content: const Text('No Record Found!'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () => Navigator.pop(
                                                context, 'Cancel'),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, 'Ok'),
                                            child: const Text('Ok'),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
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
                                                "Generate\nReport",
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
                                                      Icons
                                                          .report_gmailerrorred,
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
                                                "Reports",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 12.0),
                                                child: Text(
                                                  total_reports.toString(),
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      )),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  if (approvedappointments!.isNotEmpty) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Manage_Patients(
                                                user: widget.user,
                                                docId: id,
                                              )),
                                    );
                                  } else {
                                    showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        title: const Text('Operation Denied'),
                                        content: const Text('No Record Found!'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () => Navigator.pop(
                                                context, 'Cancel'),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, 'Ok'),
                                            child: const Text('Ok'),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
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
                                                "Mange Your\nPatients",
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
                                                      Icons.manage_accounts,
                                                      color: Colors.white,
                                                    )),
                                              )
                                            ],
                                          ),
                                          //addVerticalSpace(15),
                                        ],
                                      )),
                                ),
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
                                if (total_appointments != 0) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            Appointment_Request(
                                              user: widget.user,
                                              doc_ID: id,
                                            )),
                                  );
                                } else {
                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      title: const Text('Operation Denied'),
                                      content: const Text('No Requests Found!'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, 'Cancel'),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, 'Ok'),
                                          child: const Text('Ok'),
                                        ),
                                      ],
                                    ),
                                  );
                                }
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
                                            const CircleAvatar(
                                              backgroundColor: Colors.white54,
                                              radius: 18,
                                              child: Icon(
                                                Icons.calendar_month_outlined,
                                                color: Colors.white,
                                                size: 25,
                                              ),
                                            ),
                                            addHorizontalSpace(10),
                                            const Text(
                                              "View Appointment Requests",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            notification(),
                                          ],
                                        ),
                                      ],
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                      addVerticalSpace(20),
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
                                      builder: (context) => View_Appointments(
                                          user: widget.user, doc_ID: id)),
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
                                            const CircleAvatar(
                                              backgroundColor: Colors.white54,
                                              radius: 18,
                                              child: Icon(
                                                Icons
                                                    .settings_applications_outlined,
                                                color: Colors.white,
                                                size: 25,
                                              ),
                                            ),
                                            addHorizontalSpace(10),
                                            const Text(
                                              "Manage Appointments",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: const [
                                            Icon(
                                              Icons.edit_calendar_outlined,
                                              color: Colors.white,
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
                      addVerticalSpace(20),
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
                                      builder: (context) => Manage_Reports(
                                            user: widget.user,
                                            docId: id,
                                            accessedFrom: 'Doctor',
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
                                            const CircleAvatar(
                                              backgroundColor: Colors.white54,
                                              radius: 18,
                                              child: Icon(
                                                Icons.report_gmailerrorred,
                                                color: Colors.white,
                                                size: 25,
                                              ),
                                            ),
                                            addHorizontalSpace(10),
                                            const Text(
                                              "Manage Reports",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: const [
                                            Icon(
                                              Icons.manage_history,
                                              color: Colors.white,
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
                            child: Doctor_Details(width)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  SingleChildScrollView Doctor_Details(double width) {
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
                                  FlutterClipboard.copy(Gender).then((value) =>
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
                        "Email",
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
                                Email,
                                style: const TextStyle(color: Colors.black),
                              ),
                              GestureDetector(
                                onTap: () {
                                  FlutterClipboard.copy(Email).then((value) =>
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
                        "Degree",
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
                                Degree,
                                style: const TextStyle(color: Colors.black),
                              ),
                              GestureDetector(
                                onTap: () {
                                  FlutterClipboard.copy(Degree).then((value) =>
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
                        "Clinic",
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
                                Clinic,
                                style: const TextStyle(color: Colors.black),
                              ),
                              GestureDetector(
                                onTap: () {
                                  FlutterClipboard.copy(Clinic).then((value) =>
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
                        "Experience",
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
                                Experience.toString(),
                                style: const TextStyle(color: Colors.black),
                              ),
                              GestureDetector(
                                onTap: () {
                                  FlutterClipboard.copy(Experience.toString())
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
                        "Experties",
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
                                Experties,
                                style: const TextStyle(color: Colors.black),
                              ),
                              GestureDetector(
                                onTap: () {
                                  FlutterClipboard.copy(Experties).then(
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
                        "Specialist",
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
                                Specialist,
                                style: const TextStyle(color: Colors.black),
                              ),
                              GestureDetector(
                                onTap: () {
                                  FlutterClipboard.copy(Specialist).then(
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
                        "Certification",
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
                                Certification,
                                style: const TextStyle(color: Colors.black),
                              ),
                              GestureDetector(
                                onTap: () {
                                  FlutterClipboard.copy(Certification).then(
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
                        "EducationTrainingID",
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
                                EducationTrainingID.toString(),
                                style: const TextStyle(color: Colors.black),
                              ),
                              GestureDetector(
                                onTap: () {
                                  FlutterClipboard.copy(
                                          EducationTrainingID.toString())
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
                        "Publication",
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
                                Publication,
                                style: const TextStyle(color: Colors.black),
                              ),
                              GestureDetector(
                                onTap: () {
                                  FlutterClipboard.copy(Publication).then(
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
                        "InsuranceID",
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
                                InsuranceID.toString(),
                                style: const TextStyle(color: Colors.black),
                              ),
                              GestureDetector(
                                onTap: () {
                                  FlutterClipboard.copy(InsuranceID.toString())
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
                        "LiabilityID",
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
                                LiabilityID.toString(),
                                style: const TextStyle(color: Colors.black),
                              ),
                              GestureDetector(
                                onTap: () {
                                  FlutterClipboard.copy(LiabilityID.toString())
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
                        "LicenseNo",
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
                                LicenseNo,
                                style: const TextStyle(color: Colors.black),
                              ),
                              GestureDetector(
                                onTap: () {
                                  FlutterClipboard.copy(LicenseNo).then(
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
