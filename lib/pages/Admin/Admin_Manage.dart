import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:med_ease/pages/Admin/Admin_Home.dart';
import 'package:med_ease/pages/Admin/ViewDetails_Patient.dart';
import 'package:med_ease/utils/widgets_function.dart';

import '../../Models/Patient_Model.dart';
import '../../services/remort_services.dart';
import 'Doctor_Edit.dart';
import 'Patient_Edit.dart';

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

  get_patient_data() async {
    patients = await remort_services().getPatients();
    //print(posts?.length);
    if (patients != null) {
      setState(() {
        //print("true");
        isLoaded = true;
      });
    }
  }

  String _user = '';

  @override
  void initState() {
    String? _user = widget.user.email;
    pressed = false;
    if (widget.manage == 'Doctors' || widget.manage == 'Doctor') {
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

  @override
  Widget build(BuildContext context) {
    ScrollController scollBarController = ScrollController();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_left_sharp,
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
                    this.cusIcon =
                        const Icon(Icons.cancel, color: Colors.white);
                    this.bar = TextField(
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
                        ));
                    pressed = true;
                  } else {
                    String manage = widget.manage;
                    this.cusIcon =
                        const Icon(Icons.search, color: Colors.white);
                    this.bar = Text("Manage $manage");
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
          replacement: const Center(
            child: CircularProgressIndicator(),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: display(),
          ),
        ),
      ),
    );
  }

  ListView doctors() {
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
                        builder: (context) => const Doctor_Edit()),
                  );
                },
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue,
                icon: Icons.edit,
                label: 'Edit',
              ),
            ],
          ),
          child: Container(
              width: 10000,
              height: 180,
              child: GestureDetector(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => ViewDetails(
                    //             user: widget.user,
                    //             detailsOf: 'Doctor',
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
                            children: [
                              const Icon(
                                Icons.touch_app_outlined,
                                color: Colors.white,
                              ),
                              const Text(
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
                                            text: 'Name \t: ',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black)),
                                        TextSpan(text: 'Dr.Muneeb'),
                                        TextSpan(
                                            text: '\nDegree : ',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w800,
                                                color: Colors.black)),
                                        TextSpan(text: 'Matric pass'),
                                        TextSpan(
                                            text: '\nCertification : ',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w800,
                                                color: Colors.black)),
                                        TextSpan(text: 'DukoSolutions'),
                                        TextSpan(
                                            text: '\nSpecializations : ',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w800,
                                                color: Colors.black)),
                                        TextSpan(text: 'None'),
                                        TextSpan(
                                            text: '\nClinic/Hospital : ',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w800,
                                                color: Colors.black)),
                                        TextSpan(text: 'None'),
                                      ]),
                                ),
                              ),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      RichText(
                                          //remove const when integrating DB
                                          text: const TextSpan(
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                color: Color.fromRGBO(
                                                    255, 251, 235, 3.0),
                                              ),
                                              children: <TextSpan>[
                                            TextSpan(
                                                text: 'Contact : ',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w800,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text:
                                                    '\ntest@mail.com\n090078601'),
                                          ]))
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
                  print(1);
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => const Admin_Edit()),
                  // );
                },
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue,
                icon: Icons.edit,
                label: 'Edit',
              ),
            ],
          ),
          child: Container(
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
                            children: [
                              const Icon(
                                Icons.touch_app_outlined,
                                color: Colors.white,
                              ),
                              const Text(
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
                                    children: [
                                      const CircleAvatar(
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
                                Prefrence: patients![index].Prefrence, id: '', isDeleted: 0,),ID: patients![index].id,
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
          child: Container(
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
                                        TextSpan(text: " "),
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
