import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:med_ease/services/remort_services.dart';
import '../../models/Patient_Model.dart';
import '../../utils/widgets_function.dart';
import '../Patient/Patient_Home.dart';

class Manage_Info extends StatefulWidget {
  final User user;
  final Patient_Model pm;
  final String ID;
  const Manage_Info(
      {super.key, required this.user, required this.pm, required this.ID});

  @override
  State<Manage_Info> createState() => _Manage_Info();
}

class _Manage_Info extends State<Manage_Info> {
  int _activeStepIndex = 0;
  int _selectedOption = 0;
  TextEditingController First_Name = TextEditingController();
  TextEditingController Last_Name = TextEditingController();
  TextEditingController DOB = TextEditingController();
  TextEditingController Gender = TextEditingController();
  TextEditingController Contact = TextEditingController();
  TextEditingController Address = TextEditingController();
  TextEditingController HealthInsuranceInfo = TextEditingController();
  TextEditingController EmergencyContact = TextEditingController();
  TextEditingController MedicalHistory = TextEditingController();
  TextEditingController Allergies_Medication = TextEditingController();
  TextEditingController Prefrence = TextEditingController();
  TextEditingController Email = TextEditingController();
  TextEditingController Password = TextEditingController();
  TextEditingController ConfirmPassword = TextEditingController();

  ///******************************Data Fetching code here********************************
  ///

  bool Validate_() {
    if (First_Name.text != 'Not Yet Added' && First_Name.text != '') {
      if (Last_Name.text != 'Not Yet Added' && Last_Name.text != '') {
        if (DOB.text != 'Not Yet Added' && DOB.text != '') {
          if (Gender.text != 'Not Yet Added') {
            if (Address.text != 'Not Yet Added' && Address.text != '') {
              if (HealthInsuranceInfo.text != 'Not Yet Added' &&
                  HealthInsuranceInfo.text != '') {
                if (EmergencyContact.text != 'Not Yet Added' &&
                    EmergencyContact.text != '') {
                  if (MedicalHistory.text != 'Not Yet Added' &&
                      MedicalHistory.text != '') {
                    if (Allergies_Medication.text != 'Not Yet Added' &&
                        Allergies_Medication.text != '') {
                      if (Prefrence.text != 'Not Yet Added' &&
                          Prefrence.text != '') {
                        if (Contact.text != 'Not Yet Added' &&
                            Contact.text != '') {
                          return true;
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Enter Contact')));
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Enter your preference')));
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Enter Allergies_Medication')));
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Enter MedicalHistory')));
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Enter EmergencyContact')));
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Enter HealthInsuranceInfo')));
              }
            } else {
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('Enter Address')));
            }
          } else {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('Enter Gender')));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Enter Date of Birth')));
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Enter Last Name')));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Enter First Name')));
    }
    return false;
  }

  String DisplayName = '';
  populateData(Patient_Model pm) {
    DisplayName = pm.First_Name + " " + pm.Last_Name;
    First_Name.text = pm.First_Name;
    Last_Name.text = pm.Last_Name;
    DOB.text = pm.DOB;
    _selectedOption = setGender(pm.Gender);
    Contact.text = pm.Contact;
    Address.text = pm.Address;
    HealthInsuranceInfo.text = pm.HealthInsuranceID;
    EmergencyContact.text = pm.EmergencyContact;
    MedicalHistory.text = pm.MedicalHistory;
    Allergies_Medication.text = pm.Allergies_Medication;
    Prefrence.text = pm.Prefrence;
    Email.text = pm.Email;
  }

  getGender() {
    if (_selectedOption == 1) {
      return 'Male';
    } else {
      return 'Female';
    }
  }

  setGender(String gender) {
    if (gender == 'Male') {
      return 1;
    } else {
      return 2;
    }
  }

  bool getData() {
    print(Contact.text);
    Patient_Model pm = Patient_Model(
      First_Name: First_Name.text,
      Last_Name: Last_Name.text,
      DOB: DOB.text,
      Gender: getGender(),
      Contact: Contact.text,
      Address: Address.text,
      HealthInsuranceID: HealthInsuranceInfo.text,
      EmergencyContact: EmergencyContact.text,
      MedicalHistory: MedicalHistory.text,
      Allergies_Medication: Allergies_Medication.text,
      Prefrence: Prefrence.text,
      Email: Email.text,
      Information: Password.text,
      id: "",
      Password: Password.text,
      isDeleted: 0,
    );
    if (Validate_() == true) {
      Update(pm);
      return true;
    }
    return false;
    //here you can use the object pm to perform CRUD
  }

  Update(Patient_Model pm) {
    print(widget.ID);
    remort_services().UpDate(pm, widget.ID);
    print('data updated');
  }

  /// ***************************************************************************************

  List<Step> stepList() => [
        Step(
          state: _activeStepIndex <= 0 ? StepState.editing : StepState.complete,
          isActive: _activeStepIndex >= 0,
          title:
              const Text('Basic Information', style: TextStyle(fontSize: 15)),
          content: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Column(children: [
              TextField(
                controller: First_Name,
                onTap: () {
                  if (First_Name.text == 'Not Yet Added') {
                    First_Name.text = '';
                  }
                },
                decoration: InputDecoration(
                  prefixIcon:
                      const Icon(Icons.person_2_outlined, color: Colors.blue),
                  labelText: "Fist Name",
                  hintText: 'First Name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              addVerticalSpace(8),
              TextField(
                controller: Last_Name,
                onTap: () {
                  if (Last_Name.text == 'Not Yet Added') {
                    Last_Name.text = '';
                  }
                },
                decoration: InputDecoration(
                  prefixIcon:
                      const Icon(Icons.person_2_outlined, color: Colors.blue),
                  labelText: "Last Name",
                  hintText: 'Last Name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              addVerticalSpace(8),
              TextField(
                controller: DOB,
                decoration: InputDecoration(
                    prefixIcon:
                        const Icon(Icons.calendar_month, color: Colors.blue),
                    labelText: "Date Of Birth",
                    hintText: 'Date Of Birth',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
                readOnly:
                    true, //set it true, so that user will not able to edit text
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(
                          2000), //DateTime.now() - not to allow to choose before today.
                      lastDate: DateTime(2101));

                  if (pickedDate != null) {
                    print(
                        pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                    print(
                        formattedDate); //formatted date output using intl package =>  2021-03-16
                    //you can implement different kind of Date Format here according to your requirement

                    setState(() {
                      DOB.text =
                          formattedDate; //set output date to TextField value.
                    });
                  } else {
                    print("Date is not selected");
                  }
                },
              ),
              addVerticalSpace(8),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Radio(
                    value: 1,
                    groupValue: _selectedOption,
                    onChanged: (value) {
                      setState(() {
                        _selectedOption = 1;
                      });
                    },
                  ),
                  const Text('Male'),
                  const SizedBox(
                    width: 50,
                  ),
                  Radio(
                    value: 2,
                    groupValue: _selectedOption,
                    onChanged: (value) {
                      setState(() {
                        _selectedOption = 2;
                      });
                    }, // Make the radio button inactive
                  ),
                  const Text('Female'),
                ],
              ),
              addVerticalSpace(8),
              TextField(
                controller: Contact,
                onTap: () {
                  if (Contact.text == 'Not Yet Added') {
                    Contact.text = '';
                  }
                },
                decoration: InputDecoration(
                  prefixIcon:
                      const Icon(Icons.book_outlined, color: Colors.blue),
                  labelText: "Contact",
                  hintText: 'Contact',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              addVerticalSpace(8),
              TextField(
                controller: Address,
                onTap: () {
                  if (Address.text == 'Not Yet Added') {
                    Address.text = '';
                  }
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.location_on, color: Colors.blue),
                  labelText: "Address",
                  hintText: 'Address',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ]),
          ),
        ),
        Step(
            state:
                _activeStepIndex <= 1 ? StepState.editing : StepState.complete,
            isActive: _activeStepIndex >= 1,
            title: const Text(
              'Health Information',
            ),
            content: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Column(
                children: [
                  TextField(
                    controller: HealthInsuranceInfo,
                    onTap: () {
                      if (HealthInsuranceInfo.text == 'Not Yet Added') {
                        HealthInsuranceInfo.text = '';
                      }
                    },
                    maxLines: 3,
                    autocorrect: true,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.health_and_safety,
                          color: Colors.blue),
                      labelText: "Health Insurance Information",
                      hintText: 'Health Insurance Information',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  addVerticalSpace(8),
                  TextField(
                    controller: EmergencyContact,
                    onTap: () {
                      if (EmergencyContact.text == 'Not Yet Added') {
                        EmergencyContact.text = '';
                      }
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.contact_emergency,
                          color: Colors.blue),
                      labelText: "Emergency Contact",
                      hintText: 'Emergency Contact',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  addVerticalSpace(8),
                  TextField(
                    controller: MedicalHistory,
                    onTap: () {
                      if (MedicalHistory.text == 'Not Yet Added') {
                        MedicalHistory.text = '';
                      }
                    },
                    maxLines: 4,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.medical_information_outlined,
                          color: Colors.blue),
                      labelText: "Medical History",
                      hintText: 'Medical History',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  addVerticalSpace(8),
                  TextField(
                    controller: Allergies_Medication,
                    onTap: () {
                      if (Allergies_Medication.text == 'Not Yet Added') {
                        Allergies_Medication.text = '';
                      }
                    },
                    decoration: InputDecoration(
                      prefixIcon:
                          const Icon(Icons.medication, color: Colors.blue),
                      labelText: "Allergies & Medication",
                      hintText: 'Allergies & Medication',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  addVerticalSpace(8),
                  TextField(
                    controller: Prefrence,
                    onTap: () {
                      if (Prefrence.text == 'Not Yet Added') {
                        Prefrence.text = '';
                      }
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.medical_services_outlined,
                          color: Colors.blue),
                      labelText: "Preferred Healthcare",
                      hintText: 'Preferred Healthcare',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              ),
            )),
        // Step(
        //     state:
        //         _activeStepIndex <= 2 ? StepState.editing : StepState.complete,
        //     isActive: _activeStepIndex >= 2,
        //     title: const Text(
        //       'Account Setup',
        //       style: TextStyle(color: Colors.black),
        //     ),
        //     content: Column(
        //       children: [
        //         Material(
        //           color: Color.fromRGBO(236, 242, 255, 1.0),
        //           child: Container(
        //             decoration: const BoxDecoration(
        //                 borderRadius: BorderRadius.all(Radius.circular(100))),
        //             child: ListTile(
        //               leading: Icon(
        //                 Icons.fingerprint,
        //                 color: Colors.blue,
        //                 size: 30,
        //               ),
        //               title: Text(
        //                 "Add Finger Print",
        //                 style: TextStyle(color: Colors.black),
        //               ),
        //               onTap: () {},
        //             ),
        //           ),
        //         ),
        //         Container(
        //           height: 20,
        //         ),
        //         Material(
        //           color: Color.fromRGBO(236, 242, 255, 1.0),
        //           child: Container(
        //             decoration: const BoxDecoration(
        //                 borderRadius: BorderRadius.all(Radius.circular(100))),
        //             child: ListTile(
        //               leading: Icon(
        //                 Icons.face,
        //                 color: Colors.blue,
        //                 size: 30,
        //               ),
        //               title: Text(
        //                 "Add Facial Authentication",
        //                 style: TextStyle(color: Colors.black),
        //               ),
        //               onTap: () {},
        //             ),
        //           ),
        //         ),
        //         addVerticalSpace(10),
        //       ],
        //     ))
      ];

  @override
  void initState() {
    populateData(widget.pm);
  }

  Future<bool?> _onBackPressed() async {
    if (Validate_() == true) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Patient_Home(user: widget.user)),
      );
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
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width,
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Column(children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 45, left: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
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
                                if (Validate_() == true) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            Patient_Home(user: widget.user)),
                                  );
                                }
                              },
                            );
                          }),
                        ),
                      ),
                      addHorizontalSpace(30),
                      Text(
                        'Update : $DisplayName',
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w700),
                      )
                    ]),
                  ],
                ),
              ),
              Stepper(
                type: StepperType.vertical,
                physics: const PageScrollPhysics(),
                currentStep: _activeStepIndex,
                steps: stepList(),
                onStepContinue: () {
                  if (_activeStepIndex < (stepList().length - 1)) {
                    setState(() {
                      _activeStepIndex += 1;
                    });
                  } else {
                    if (getData() == true) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Patient_Home(user: widget.user)),
                      );
                    }
                    //print('Submited');
                  }
                },
                onStepCancel: () {
                  if (_activeStepIndex == 0) {
                    return;
                  }
                  setState(() {
                    _activeStepIndex -= 1;
                  });
                },
                onStepTapped: (int index) {
                  setState(() {
                    _activeStepIndex = index;
                  });
                },
                controlsBuilder:
                    (BuildContext context, ControlsDetails controls) {
                  final isLastStep = _activeStepIndex == stepList().length - 1;
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        if (_activeStepIndex > 0)
                          Expanded(
                            child: ElevatedButton(
                              onPressed: controls.onStepCancel,
                              child: const Text('Back'),
                            ),
                          ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: controls.onStepContinue,
                            style: ElevatedButton.styleFrom(
                              fixedSize:
                                  const Size(double.infinity, double.infinity),
                            ),
                            child: (isLastStep)
                                ? const Text('Update')
                                : const Text('Next'),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
