import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';
import 'package:med_ease/pages/Admin/Admin_Manage.dart';
import 'package:med_ease/services/remort_services.dart';

import '../../Models/Patient_Model.dart';
import '../../utils/constants.dart';
import '../../utils/widgets_function.dart';
import '../Patient/Patient_Home.dart';
import 'ViewDetails_Patient.dart';

class Patient_Edit extends StatefulWidget {
  final User user;
  final Patient_Model pm;
  final String ID;
  const Patient_Edit(
      {super.key, required this.user, required this.pm, required this.ID});

  @override
  State<Patient_Edit> createState() => _Patient_Edit();
}

class _Patient_Edit extends State<Patient_Edit> {
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
  ///
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

  getData() {
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
    Update(pm);
    //here you can use the object pm to perform CRUD
  }

  Update(Patient_Model pm) {
    remort_services().UpDate(pm, widget.ID);
    print('data updated');
  }

  /// ***************************************************************************************

  List<Step> stepList() => [
        Step(
          state: _activeStepIndex <= 0 ? StepState.editing : StepState.complete,
          isActive: _activeStepIndex >= 0,
          title: const Text('Basic Information',
              style: TextStyle(color: Colors.black, fontSize: 15)),
          content: Column(children: [
            TextField(
              controller: First_Name,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                prefixIcon:
                    const Icon(Icons.person_2_outlined, color: Colors.blue),
                fillColor: COLOR_GREY,
                filled: true,
                hintText: 'First Name',
                hintStyle: TextStyle(color: Colors.black),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            addVerticalSpace(8),
            TextField(
              controller: Last_Name,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                prefixIcon:
                    const Icon(Icons.person_2_outlined, color: Colors.blue),
                fillColor: COLOR_GREY,
                filled: true,
                hintText: 'Last Name',
                hintStyle: TextStyle(color: Colors.black),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            addVerticalSpace(8),
            TextField(
              controller: DOB,
              style: TextStyle(
                  color: Colors.black), //editing controller of this TextField
              decoration: InputDecoration(
                  prefixIcon:
                      const Icon(Icons.calendar_month, color: Colors.blue),
                  fillColor: COLOR_GREY,
                  filled: true,
                  hintText: 'Date Of Birth',
                  hintStyle: TextStyle(color: Colors.black),
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
                Text('Male', style: TextStyle(color: Colors.black)),
                SizedBox(
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
                Text('Female', style: TextStyle(color: Colors.black)),
              ],
            ),
            addVerticalSpace(8),
            TextField(
              controller: Contact,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.book_outlined, color: Colors.blue),
                fillColor: COLOR_GREY,
                filled: true,
                hintText: 'Contact',
                hintStyle: TextStyle(color: Colors.black),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            addVerticalSpace(8),
            TextField(
              controller: Address,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.location_on, color: Colors.blue),
                fillColor: COLOR_GREY,
                filled: true,
                hintText: 'Address',
                hintStyle: TextStyle(color: Colors.black),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ]),
        ),
        Step(
            state:
                _activeStepIndex <= 1 ? StepState.editing : StepState.complete,
            isActive: _activeStepIndex >= 1,
            title: const Text(
              'Health Information',
              style: TextStyle(color: Colors.black),
            ),
            content: Column(
              children: [
                TextField(
                  controller: HealthInsuranceInfo,
                  style: TextStyle(color: Colors.black),
                  maxLines: 3,
                  autocorrect: true,
                  decoration: InputDecoration(
                    prefixIcon:
                        const Icon(Icons.health_and_safety, color: Colors.blue),
                    fillColor: COLOR_GREY,
                    filled: true,
                    hintText: 'Health Insurance Information',
                    hintStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                addVerticalSpace(8),
                TextField(
                  controller: EmergencyContact,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    prefixIcon:
                        const Icon(Icons.contact_emergency, color: Colors.blue),
                    fillColor: COLOR_GREY,
                    filled: true,
                    hintText: 'Emergency Contact',
                    hintStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                addVerticalSpace(8),
                TextField(
                  controller: MedicalHistory,
                  style: TextStyle(color: Colors.black),
                  maxLines: 4,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.medical_information_outlined,
                        color: Colors.blue),
                    fillColor: COLOR_GREY,
                    filled: true,
                    hintText: 'Medical History',
                    hintStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                addVerticalSpace(8),
                TextField(
                  controller: Allergies_Medication,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    prefixIcon:
                        const Icon(Icons.medication, color: Colors.blue),
                    fillColor: COLOR_GREY,
                    filled: true,
                    hintText: 'Allergies & Medication',
                    hintStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                addVerticalSpace(8),
                TextField(
                  controller: Prefrence,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.medical_services_outlined,
                        color: Colors.blue),
                    fillColor: COLOR_GREY,
                    filled: true,
                    hintText: 'Preferred Healthcare',
                    hintStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
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
                            padding: EdgeInsets.all(0.0),
                            iconSize: 30,
                            icon: const Icon(
                              Icons.arrow_left_outlined,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Admin_Manage(
                                        manage: 'Patients', user: widget.user)),
                              );
                            },
                          );
                        }),
                      ),
                    ),
                    addHorizontalSpace(30),
                    Text(
                      'Edit : ' + DisplayName,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.w700),
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
                  getData();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Admin_Manage(
                            manage: 'Patients', user: widget.user)),
                  );
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
                return Row(
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
                        child: (isLastStep)
                            ? const Text('Update')
                            : const Text('Next'),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                );
              },
            ),
          ]),
        ),
      ),
    );
  }
}
