import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:med_ease/models/Appointments_Model.dart';
import 'package:med_ease/pages/Admin/ViewDetails_Patient.dart';
import 'package:med_ease/pages/Doctor/Doctor_Home.dart';
import 'package:med_ease/utils/widgets_function.dart';
import '../../models/Patient_Model.dart';
import '../../services/remort_services.dart';
import '../Admin/Patient_Edit.dart';

class Manage_Patients extends StatefulWidget {
  final String docId;
  final User user;
  const Manage_Patients({super.key, required this.docId, required this.user});

  @override
  State<Manage_Patients> createState() => _Manage_PatientsState();
}

class _Manage_PatientsState extends State<Manage_Patients> {
  bool isLoaded = false;

  Icon cusIcon = const Icon(
    Icons.search,
    color: Colors.white,
  );
  late Widget bar =
      Text('Manage Patients', style: const TextStyle(color: Colors.white));
  bool pressed = false;
  List<Patient_Model>? patients = [
    Patient_Model(
        id: "1",
        First_Name: "",
        Last_Name: "",
        DOB: "",
        Gender: "",
        Contact: "",
        Address: "",
        HealthInsuranceID: "",
        EmergencyContact: "",
        MedicalHistory: "",
        Allergies_Medication: "",
        Prefrence: "",
        Email: "",
        Information: "",
        Password: "",
        isDeleted: 0)
  ];
  List<Patient_Model>? allpatients = [
    Patient_Model(
        id: "1",
        First_Name: "",
        Last_Name: "",
        DOB: "",
        Gender: "",
        Contact: "",
        Address: "",
        HealthInsuranceID: "",
        EmergencyContact: "",
        MedicalHistory: "",
        Allergies_Medication: "",
        Prefrence: "",
        Email: "",
        Information: "",
        Password: "",
        isDeleted: 0)
  ];
  List<Appointments_Model>? appointments;
  List<Patient_Model>? all_patients;

  get_data() async {
    all_patients = await remort_services().getPatients();
    appointments =
        await remort_services().getApprovedAppointments_byDoctor(widget.docId);
    if (all_patients != null &&
        appointments != null &&
        appointments!.length != 0) {
      get_PatientData_byDoctor();
      setState(() {
        isLoaded = true;
      });
    } else {
      setState(() {
        isLoaded = false;
      });
    }
  }

  List<String> ids = [];

  SearchPatientByID(String Query) {
    for (int i = 0; i < all_patients!.length; i++) {
      if (all_patients![i].id == Query) {
        Patient_Model pm = Patient_Model(
            id: all_patients![i].id,
            First_Name: all_patients![i].First_Name,
            Last_Name: all_patients![i].Last_Name,
            DOB: all_patients![i].DOB,
            Gender: all_patients![i].Gender,
            Contact: all_patients![i].Contact,
            Address: all_patients![i].Address,
            HealthInsuranceID: all_patients![i].HealthInsuranceID,
            EmergencyContact: all_patients![i].EmergencyContact,
            MedicalHistory: all_patients![i].MedicalHistory,
            Allergies_Medication: all_patients![i].Allergies_Medication,
            Prefrence: all_patients![i].Prefrence,
            Email: all_patients![i].Email,
            Information: all_patients![i].Information,
            Password: all_patients![i].Password,
            isDeleted: all_patients![i].isDeleted);

        if (!ids.contains(pm.id)) {
          ids.add(all_patients![i].id);
          patients!.add(pm);
          allpatients!.add(pm);
        }

        patients!.removeWhere((element) => element.id == "1");
        allpatients!.removeWhere((element) => element.id == "1");
      }
    }
  }

  get_PatientData_byDoctor() {
    for (int i = 0; i < appointments!.length; i++) {
      SearchPatientByID(appointments![i].patient_id);
    }
  }

  SearchResults_Patients(String Query) {
    final Suggestions = allpatients!.where((patient) {
      final contact = patient.Contact;
      return contact.contains(Query);
    }).toList();
    setState(() {
      patients = Suggestions;
    });
  }

  TextEditingController query = TextEditingController();
  String _user = '';

  @override
  void initState() {
    String? _user = widget.user.email;
    pressed = false;
    get_data();
  }

  Future<bool?> _onBackPressed() async {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Doctor_Home(
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
                    builder: (context) => Doctor_Home(
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
                                SearchResults_Patients(query.text);
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
                      SearchResults_Patients('0');
                      query.text = '';
                      this.cusIcon =
                          const Icon(Icons.search, color: Colors.white);
                      this.bar = Text("Manage Patients");
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
              child: patient(),
            ),
          ),
        ),
      ),
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
                              accessedFrom: 'Doctor',
                              docID: widget.docId,
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
                                accessedFrom: 'Doctor',
                                docID: widget.docId,
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
