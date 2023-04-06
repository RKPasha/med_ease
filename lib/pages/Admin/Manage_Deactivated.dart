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

class Manage_Deactivated extends StatefulWidget {
  final String manage;
  final User user;
  const Manage_Deactivated(
      {super.key, required this.manage, required this.user});

  @override
  State<Manage_Deactivated> createState() => _Manage_DeactivatedState();
}

class _Manage_DeactivatedState extends State<Manage_Deactivated> {
  bool isLoaded = false;

  Icon cusIcon = const Icon(
    Icons.search,
    color: Colors.white,
  );
  late Widget bar = Text('De-Activated Accounts',
      style: const TextStyle(color: Colors.white));
  bool pressed = false;
  int _selectedoption = 0;
  List<Patient_Model>? patients;
  List<Patient_Model>? all_patients;
  List<Doctor_Model>? _doctors;
  List<Doctor_Model>? all_doctors;

  get_doctor_data() async {
    _doctors = await remort_services().getDeactivatedDoctors();
    all_doctors = await remort_services().getDeactivatedDoctors();
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
    patients = await remort_services().getDeactivatedPatients();
    all_patients = await remort_services().getDeactivatedPatients();
    //print(posts?.length);
    if (patients != null) {
      setState(() {
        //print("true");
        _selectedoption = 1;
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
    get_patient_data();
    get_doctor_data();
  }

  display(int isselected) {
    if (isselected == 2) {
      if (_doctors!.length != 0) {
        return doctors();
      } else {
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: const Text('No data Found!'),
        );
      }
    } else {
      if (patients != null) {
        if (patients!.length != 0) {
          return patient();
        } else {
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: const Text('No data Found!'),
          );
        }
      }
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
        ),
        body: Scrollbar(
          controller: scollBarController,
          scrollbarOrientation: ScrollbarOrientation.right,
          child: Visibility(
            visible: true,
            replacement: const Center(
              child: CircularProgressIndicator(),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10, bottom: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Radio(
                                    activeColor: Colors.white,
                                    value: 1,
                                    groupValue: _selectedoption,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedoption = 1;
                                        get_patient_data();
                                      });
                                    },
                                  ),
                                  const Text(
                                    'Patient',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                  const SizedBox(
                                    width: 50,
                                  ),
                                ],
                              ),
                              addHorizontalSpace(10),
                              Row(
                                children: [
                                  Radio(
                                    activeColor: Colors.white,
                                    value: 2,
                                    groupValue: _selectedoption,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedoption = 2;
                                        get_doctor_data();
                                      });
                                    },
                                  ),
                                  const Text(
                                    'Doctor',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                  const SizedBox(
                                    width: 50,
                                  ),
                                ],
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Search Account',
                                style: TextStyle(color: Colors.white),
                              ),
                              addHorizontalSpace(10),
                              TextField(
                                  onChanged: (value) {
                                    if (_selectedoption == 1) {
                                      SearchResults_Patients(query.text);
                                    } else if (_selectedoption == 2) {
                                      SearchResults_Doctor(query.text);
                                    }
                                  },
                                  controller: query,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.only(left: 8, right: 8),
                                    constraints:
                                        BoxConstraints.tight(Size(180, 30)),
                                    hintText: "Search by Contact",
                                    fillColor: Colors.white,
                                    filled: true,
                                    hintStyle:
                                        const TextStyle(color: Colors.black),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                  ))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 100,
                      child: Visibility(
                        visible: isLoaded,
                        replacement: const Center(
                          child: CircularProgressIndicator(),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: display(_selectedoption),
                        ),
                      ),
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

  ListView doctors() {
    final scollBarController1 = ScrollController();
    return ListView.builder(
      itemCount: _doctors?.length,
      itemBuilder: (context, index) {
        const Text('Swipe right to Access Delete method');

        return Slidable(
          // Specify a key if the Slidable is dismissible.
          key: Key(_doctors![index].id),
          child: SizedBox(
              width: 10000,
              height: 210,
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
                                    height: 120,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8, right: 8, bottom: 8, left: 8),
                                      child: FittedBox(
                                        fit: BoxFit.contain,
                                        alignment: Alignment.centerLeft,
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
                                                    text: _doctors![index]
                                                        .Degree),
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
                                                    text:
                                                        '\nSpecializations : ',
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
                                                    text: _doctors![index]
                                                        .Clinic),
                                              ]),
                                        ),
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
                                        SizedBox(
                                          height: 30,
                                          width: 105,
                                          child: ElevatedButton.icon(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.cyan),
                                            ),
                                            onPressed: () async {
                                              await remort_services()
                                                  .ActivateDoctor(
                                                      _doctors![index].id);
                                              get_doctor_data();
                                              Future.delayed(
                                                  const Duration(
                                                      milliseconds: 500), () {
                                                display(2);
                                              });
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          'Account Activated!')));
                                            },
                                            icon: Icon(Icons
                                                .settings_applications_sharp),
                                            label: Text(
                                              'Activate',
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
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

  ListView patient() {
    return ListView.builder(
      itemCount: patients?.length,
      itemBuilder: (context, index) {
        const Text('Swipe right to Access Delete method');

        return Slidable(
          key: Key(patients![index].id),
          child: SizedBox(
              width: 10000,
              height: 190,
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
                                width: 200,
                                height: 100,
                                // padding: const EdgeInsets.all(8),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8, bottom: 8, left: 8, right: 8),
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                    alignment: Alignment.centerLeft,
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
                                                text: patients?[index]
                                                    .First_Name),
                                            const TextSpan(text: " "),
                                            TextSpan(
                                                text:
                                                    patients?[index].Last_Name),
                                            const TextSpan(
                                                text: '\nGender : ',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w800,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: patients?[index].Gender),
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
                                                text:
                                                    patients?[index].Prefrence),
                                          ]),
                                    ),
                                  ),
                                ),
                              ),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        height: 30,
                                        width: 105,
                                        child: ElevatedButton.icon(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.cyan),
                                          ),
                                          onPressed: () async {
                                            await remort_services()
                                                .ActivatePatient(
                                                    patients![index].id);
                                            get_patient_data();
                                            Future.delayed(
                                                const Duration(
                                                    milliseconds: 500), () {
                                              display(1);
                                            });
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        'Account Activated!')));
                                          },
                                          icon: Icon(Icons
                                              .settings_applications_sharp),
                                          label: Text(
                                            'Activate',
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
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
