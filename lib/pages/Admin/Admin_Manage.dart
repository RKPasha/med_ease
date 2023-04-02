import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:med_ease/models/Doctors_Model.dart';
import 'package:med_ease/pages/Admin/Admin_Home.dart';
import 'package:med_ease/pages/Admin/ViewDetails_Patient.dart';
import 'package:med_ease/utils/widgets_function.dart';
import '../../models/Patient_Model.dart';
import '../../services/remort_services.dart';
import 'Doctor_Edit.dart';
import 'Patient_Edit.dart';
import 'ViewDetails_Doctor.dart';

class Admin_Manage extends StatefulWidget {
  final String manage;
  final User user;
  const Admin_Manage({super.key, required this.manage, required this.user});

  @override
  State<Admin_Manage> createState() => _Admin_ManageState();
}

class _Admin_ManageState extends State<Admin_Manage> {
  bool isLoaded = false;

  Icon cusIcon = const Icon(
    Icons.search,
    color: Colors.white,
  );
  late Widget bar = Text('Manage ${widget.manage}',
      style: const TextStyle(color: Colors.white));
  bool pressed = false;
  List<Patient_Model>? patients;
  List<Patient_Model>? all_patients;
  List<Doctor_Model>? _doctors;
  List<Doctor_Model>? all_doctors;

  get_doctor_data() async {
    _doctors = await remort_services().getDoctors();
    all_doctors = await remort_services().getDoctors();
    //print(posts?.length);
    if (_doctors != null) {
      setState(() {
        //print("true");
        isLoaded = true;
      });
    }
  }

  SearchResults_Doctor(String Query) {
    final Suggestions = all_doctors!.where((doc) {
      final contact = doc.Contact;
      return contact.contains(Query);
    }).toList();
    setState(() {
      _doctors = Suggestions;
    });
  }

  get_patient_data() async {
    patients = await remort_services().getPatients();
    all_patients = await remort_services().getPatients();
    //print(posts?.length);
    if (patients != null) {
      setState(() {
        //print("true");
        isLoaded = true;
      });
    }
  }

  SearchResults_Patients(String query) {
    final Suggestions = all_patients!.where((patient) {
      final contact = patient.Contact;
      return contact.toLowerCase().contains(query.toLowerCase());
    }).toList();
    setState(() {
      patients = Suggestions;
    });
  }

  TextEditingController query = TextEditingController();

  @override
  void initState() {
    String? _user = widget.user.email;
    pressed = false;
    if (widget.manage == 'Doctors' || widget.manage == 'Doctor') {
      get_doctor_data();
    } else if (widget.manage == 'Patients' || widget.manage == 'Patient') {
      get_patient_data();
    } else if (widget.manage == 'Reports' || widget.manage == 'Report') {}
  }

  display() {
    if (widget.manage == 'Doctors' || widget.manage == 'Doctor') {
      return doctors();
    } else if (widget.manage == 'Patients' || widget.manage == 'Patient') {
      return patient();
    } else if (widget.manage == 'Reports' || widget.manage == 'Report') {
      return reports();
    }
  }

  Future<bool?> _onBackPressed() async {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Admin_Home(
                user: widget.user,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scollBarController = ScrollController();

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
                    builder: (context) => Admin_Home(
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
                      cusIcon = const Icon(Icons.cancel, color: Colors.white);
                      bar = Padding(
                        padding: const EdgeInsets.only(top: 50, bottom: 50),
                        child: TextField(
                            onChanged: (value) {
                              setState(() {
                                if (widget.manage == 'Doctors' ||
                                    widget.manage == 'Doctor') {
                                  SearchResults_Doctor(query.text);
                                } else if (widget.manage == 'Patients' ||
                                    widget.manage == 'Patient') {
                                  SearchResults_Patients(query.text);
                                } else if (widget.manage == 'Reports' ||
                                    widget.manage == 'Report') {}
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
                      if (widget.manage == 'Doctors' ||
                          widget.manage == 'Doctor') {
                        SearchResults_Doctor('');
                        query.text = '';
                        String manage = widget.manage;
                        cusIcon = const Icon(Icons.search, color: Colors.white);
                        bar = Text("Manage $manage");
                        pressed = false;
                      } else if (widget.manage == 'Patients' ||
                          widget.manage == 'Patient') {
                        SearchResults_Patients('0');
                        query.text = '';
                        String manage = widget.manage;
                        cusIcon = const Icon(Icons.search, color: Colors.white);
                        bar = Text("Manage $manage");
                        pressed = false;
                      } else if (widget.manage == 'Reports' ||
                          widget.manage == 'Report') {}
                    }
                  });
                }),
            IconButton(
                icon: const Icon(
                  Icons.info,
                  color: Colors.white,
                ),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Info:'),
                          content: const Text('> Search with name.'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      });
                }),
          ],
          // bottom: PreferredSize(preferredSize: Size(50, 50),
          // child:Container() ,
          // ),
        ),
        body: Scrollbar(
          controller: scollBarController,
          scrollbarOrientation: ScrollbarOrientation.right,
          child: Visibility(
            visible: isLoaded,
            replacement: const Center(
              child: CircularProgressIndicator(),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: display(),
            ),
          ),
        ),
      ),
    );
  }

  ListView doctors() {
    final scollBarController1 = ScrollController();
    return ListView.builder(
      itemCount: _doctors?.length,
      itemBuilder: (context, index) {
        const Text('Swipe right to Access Delete method');

        return Slidable(
          // Specify a key if the Slidable is dismissible.
          key: Key(_doctors![index].id),

          // The start action pane is the one at the left or the top side.
          startActionPane: ActionPane(
            // A motion is a widget used to control how the pane animates.
            motion: const ScrollMotion(),

            // A pane can dismiss the Slidable.
            dismissible: DismissiblePane(
              key: Key(_doctors![index].id),
              onDismissed: () async {
                try {
                  await remort_services().Delete_Doctor(_doctors![index].id);
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(_doctors![index].First_Name +
                          " " +
                          _doctors![index].Last_Name +
                          ' Successfully Deleted!')));
                } catch (e) {
                  print(e);
                }
              },
            ),

            // All actions are defined in the children parameter.
            children: const [
              // A SlidableAction can have an icon and/or a label.
              SlidableAction(
                onPressed: null,
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue,
                icon: Icons.delete,
                label: 'Swipe Right to Delete',
              ),
            ],
          ),

          // The end action pane is the one at the right or the bottom side.
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                // An action can be bigger than the others.
                flex: 2,
                onPressed: (context) {
                  //print(2);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Doctor_Edit(
                              dm: Doctor_Model(
                                  id: _doctors![index].id,
                                  First_Name: _doctors![index].First_Name,
                                  Certification: _doctors![index].Certification,
                                  Gender: _doctors![index].Gender,
                                  Last_Name: _doctors![index].Last_Name,
                                  Experience: _doctors![index].Experience,
                                  Experties: _doctors![index].Experties,
                                  Contact: _doctors![index].Contact,
                                  InsuranceID: _doctors![index].InsuranceID,
                                  LiabilityID: _doctors![index].LiabilityID,
                                  LicenseNo: _doctors![index].LicenseNo,
                                  Publication: _doctors![index].Publication,
                                  Specialist: _doctors![index].Specialist,
                                  Email: _doctors![index].Email,
                                  isDeleted: _doctors![index].isDeleted,
                                  Clinic: _doctors![index].Clinic,
                                  Degree: _doctors![index].Degree,
                                  EducationTrainingID:
                                      _doctors![index].EducationTrainingID),
                              user: widget.user,
                            )),
                  );
                },
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue,
                icon: Icons.edit,
                label: 'Edit',
              ),
            ],
          ),
          child: SizedBox(
              width: 10000,
              height: 230,
              child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ViewDetails_Doctor(
                                user: widget.user,
                                detailsOf: 'Doctor',
                                Certification: _doctors![index].Certification,
                                Clinic: _doctors![index].Clinic,
                                Contact: _doctors![index].Contact,
                                Degree: _doctors![index].Degree,
                                EducationtrainingID:
                                    _doctors![index].EducationTrainingID,
                                Email: _doctors![index].Email,
                                Experience: _doctors![index].Experience,
                                Experties: _doctors![index].Experties,
                                First_Name: _doctors![index].First_Name,
                                Gender: _doctors![index].Gender,
                                InsuranceID: _doctors![index].InsuranceID,
                                Last_Name: _doctors![index].Last_Name,
                                LiabilityID: _doctors![index].LiabilityID,
                                LicenseNo: _doctors![index].LicenseNo,
                                Password: '',
                                Publication: _doctors![index].Publication,
                                Specialist: _doctors![index].Specialist,
                              )),
                    );
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
                                Icons.touch_app_outlined,
                                color: Colors.white,
                              ),
                              Text(
                                "Tap on Card to get full details.",
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
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                width: 200,
                                child: SingleChildScrollView(
                                  controller: scollBarController1,
                                  child: SizedBox(
                                    height: 140,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: RichText(
                                        //remove const when integrating DB
                                        text: TextSpan(
                                            style: const TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.black,
                                            ),
                                            children: <TextSpan>[
                                              const TextSpan(
                                                  text: 'Name \t: ',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.black)),
                                              TextSpan(
                                                  text:
                                                      "${_doctors![index].First_Name} ${_doctors![index].Last_Name}"),
                                              const TextSpan(
                                                  text: '\nDegree : ',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      color: Colors.black)),
                                              TextSpan(
                                                  text:
                                                      _doctors![index].Degree),
                                              const TextSpan(
                                                  text: '\nLicense No. : ',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      color: Colors.black)),
                                              TextSpan(
                                                  text: _doctors![index]
                                                      .LicenseNo),
                                              const TextSpan(
                                                  text: '\nSpecializations : ',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      color: Colors.black)),
                                              TextSpan(
                                                  text: _doctors![index]
                                                      .Specialist),
                                              const TextSpan(
                                                  text: '\nClinic : ',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      color: Colors.black)),
                                              TextSpan(
                                                  text:
                                                      _doctors![index].Clinic),
                                            ]),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 5.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.call,
                                          color: Colors.yellow,
                                        ),
                                        addHorizontalSpace(3),
                                        const Text(
                                          "Contact",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                    addVerticalSpace(10),
                                    Row(
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                              style: const TextStyle(
                                                fontSize: 14.0,
                                                color: Color.fromRGBO(
                                                    255, 251, 235, 3.0),
                                              ),
                                              children: <TextSpan>[
                                                TextSpan(
                                                    text: _doctors?[index]
                                                        .Contact),
                                              ]),
                                        )
                                      ],
                                    )
                                  ],
                                ),
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

  ListView reports() {
    return ListView.builder(
      //itemCount: appointment?.length,
      itemCount: 5,
      itemBuilder: (context, index) {
        const Text('Swipe right to Access Delete method');

        return Slidable(
          // Specify a key if the Slidable is dismissible.
          //key: Key(appointment![index].id),

          // The start action pane is the one at the left or the top side.
          startActionPane: ActionPane(
            // A motion is a widget used to control how the pane animates.
            motion: const ScrollMotion(),

            // A pane can dismiss the Slidable.
            dismissible: DismissiblePane(
              //key: Key(appointment![index].id),
              onDismissed: () {
                // Then show a snackbar.
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text('dismissed')));
              },
            ),

            // All actions are defined in the children parameter.
            children: const [
              // A SlidableAction can have an icon and/or a label.
              SlidableAction(
                onPressed: null,
                foregroundColor: Colors.blue,
                icon: Icons.delete,
                label: 'Delete',
              ),
            ],
          ),

          // The end action pane is the one at the right or the bottom side.
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                // An action can be bigger than the others.
                flex: 2,
                onPressed: (context) {
                  print(1);
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => const Admin_Edit()),
                  // );
                },
                foregroundColor: Colors.blue,
                icon: Icons.edit,
                label: 'Edit',
              ),
            ],
          ),
          child: SizedBox(
              width: 10000,
              height: 160,
              child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ViewDetails_Patient(
                                user: widget.user,
                                detailsOf: 'Report',
                                Address: '',
                                Allergies_Medication: '',
                                Contact: '',
                                DOB: '',
                                Email: '',
                                EmergencyContact: '',
                                First_Name: '',
                                Gender: '',
                                HealthInsuranceID: '',
                                Information: '',
                                Last_Name: '',
                                MedicalHistory: '',
                                Password: '',
                                Prefrence: '',
                                accessedFrom: 'Admin',
                                docID: '',
                              )),
                    );
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
                                Icons.touch_app_outlined,
                                color: Colors.white,
                              ),
                              Text(
                                "Tap on Card to get full details.",
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                          addVerticalSpace(10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 200,
                                child: RichText(
                                  //remove const when integrating DB
                                  text: const TextSpan(
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color:
                                            Color.fromRGBO(255, 251, 235, 3.0),
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: 'Patient Name : ',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black)),
                                        TextSpan(text: 'Test'),
                                        TextSpan(
                                            text: '\nContact : ',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w800,
                                                color: Colors.black)),
                                        TextSpan(text: '090078601'),
                                        TextSpan(
                                            text: '\nPrefrence : ',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w800,
                                                color: Colors.black)),
                                        TextSpan(text: 'none'),
                                        TextSpan(
                                            text: '\nMedical History : ',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w800,
                                                color: Colors.black)),
                                        TextSpan(text: '10:00:00'),
                                      ]),
                                ),
                              ),
                              Column(
                                children: [
                                  Row(
                                    children: const [
                                      CircleAvatar(
                                        backgroundColor: Colors.white,
                                        child: Icon(
                                          Icons.description_outlined,
                                          color: Colors.blue,
                                        ),
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

  ListView patient() {
    return ListView.builder(
      itemCount: patients?.length,
      itemBuilder: (context, index) {
        const Text('Swipe right to Access Delete method');

        return Slidable(
          // Specify a key if the Slidable is dismissible.
          key: Key(patients![index].id),

          // The start action pane is the one at the left or the top side.
          startActionPane: ActionPane(
            // A motion is a widget used to control how the pane animates.
            motion: const ScrollMotion(),

            // A pane can dismiss the Slidable.
            dismissible: DismissiblePane(
              key: Key(patients![index].id),
              onDismissed: () {
                remort_services().Delete(patients![index].id);
                // Then show a snackbar.
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text('dismissed')));
              },
            ),

            // All actions are defined in the children parameter.
            children: const [
              // A SlidableAction can have an icon and/or a label.
              SlidableAction(
                onPressed: null,
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue,
                icon: Icons.delete,
                label: 'Swipe Right to Delete',
              ),
            ],
          ),

          // The end action pane is the one at the right or the bottom side.
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                // An action can be bigger than the others.
                flex: 2,
                onPressed: (context) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Patient_Edit(
                              pm: Patient_Model(
                                Address: patients![index].Address,
                                Allergies_Medication:
                                    patients![index].Allergies_Medication,
                                Contact: patients![index].Contact,
                                DOB: patients![index].DOB,
                                Email: patients![index].Email,
                                EmergencyContact:
                                    patients![index].EmergencyContact,
                                First_Name: patients![index].First_Name,
                                Gender: patients![index].Gender,
                                HealthInsuranceID:
                                    patients![index].HealthInsuranceID,
                                Information: patients![index].Information,
                                Last_Name: patients![index].Last_Name,
                                MedicalHistory: patients![index].MedicalHistory,
                                Password: '',
                                Prefrence: patients![index].Prefrence,
                                id: '',
                                isDeleted: 0,
                              ),
                              ID: patients![index].id,
                              user: widget.user,
                              accessedFrom: 'Admin',
                              docID: '',
                            )),
                  );
                },
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue,
                icon: Icons.edit,
                label: 'Edit',
              ),
            ],
          ),
          child: SizedBox(
              width: 10000,
              height: 180,
              child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ViewDetails_Patient(
                                user: widget.user,
                                detailsOf: "Patient",
                                Address: patients![index].Address,
                                Allergies_Medication:
                                    patients![index].Allergies_Medication,
                                Contact: patients![index].Contact,
                                DOB: patients![index].DOB,
                                Email: patients![index].Email,
                                EmergencyContact:
                                    patients![index].EmergencyContact,
                                First_Name: patients![index].First_Name,
                                Gender: patients![index].Gender,
                                HealthInsuranceID:
                                    patients![index].HealthInsuranceID,
                                Information: patients![index].Information,
                                Last_Name: patients![index].Last_Name,
                                MedicalHistory: patients![index].MedicalHistory,
                                Password: '',
                                Prefrence: patients![index].Prefrence,
                                accessedFrom: 'Admin',
                                docID: '',
                              )),
                    );
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
                                Icons.touch_app_outlined,
                                color: Colors.white,
                              ),
                              Text(
                                "Tap on Card to get full details.",
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
                                width: 220,
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
                                            text: 'Name : ',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black)),
                                        TextSpan(
                                            text: patients?[index].First_Name),
                                        const TextSpan(text: " "),
                                        TextSpan(
                                            text: patients?[index].Last_Name),
                                        const TextSpan(
                                            text: '\nGender : ',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w800,
                                                color: Colors.black)),
                                        TextSpan(text: patients?[index].Gender),
                                        const TextSpan(
                                            text: '\nContact: ',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w800,
                                                color: Colors.black)),
                                        TextSpan(
                                            text: patients?[index].Contact),
                                        const TextSpan(
                                            text: '\nPreference : ',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w800,
                                                color: Colors.black)),
                                        TextSpan(
                                            text: patients?[index].Prefrence),
                                      ]),
                                ),
                              ),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.warning_amber_outlined,
                                        color: Colors.yellow,
                                      ),
                                      addHorizontalSpace(3),
                                      const Text(
                                        "Emergency\nContact",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                  addVerticalSpace(10),
                                  Row(
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                            style: const TextStyle(
                                              fontSize: 14.0,
                                              color: Color.fromRGBO(
                                                  255, 251, 235, 3.0),
                                            ),
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: patients?[index]
                                                      .EmergencyContact),
                                            ]),
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
