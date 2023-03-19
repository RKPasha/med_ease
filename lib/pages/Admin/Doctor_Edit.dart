import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';

import '../../Models/Patient_Model.dart';
import '../../utils/constants.dart';
import '../../utils/widgets_function.dart';
import '../Patient/Patient_Home.dart';

class Doctor_Edit extends StatefulWidget {
  const Doctor_Edit({super.key});

  @override
  State<Doctor_Edit> createState() => _Doctor_Edit();
}

class _Doctor_Edit extends State<Doctor_Edit> {
  int _activeStepIndex = 0;
  int _selectedOption = 0;
  TextEditingController First_Name = TextEditingController();
  TextEditingController Last_Name = TextEditingController();
  TextEditingController DOB = TextEditingController();
  TextEditingController Gender = TextEditingController();
  TextEditingController Contact = TextEditingController();
  TextEditingController Address = TextEditingController();
  TextEditingController HealthInsuranceID = TextEditingController();
  TextEditingController EmergencyContact = TextEditingController();
  TextEditingController MedicalHistory = TextEditingController();
  TextEditingController Allergies_Medication = TextEditingController();
  TextEditingController Prefrence = TextEditingController();
  TextEditingController Email = TextEditingController();
  TextEditingController Password = TextEditingController();
  TextEditingController ConfirmPassword = TextEditingController();

  ///******************************Data Fetching code here********************************

  getGender() {
    if (_selectedOption == 1) {
      return 'Male';
    } else {
      return 'Female';
    }
  }

  populate() {
    First_Name.text = '';
    Last_Name.text = '';
    DOB.text = '';
    Gender.text = '';
    Contact.text = '';
    Address.text = '';
    HealthInsuranceID.text = '';
    EmergencyContact.text = '';
    MedicalHistory.text = '';
    Allergies_Medication.text = '';
    Prefrence.text = '';
    Email.text = '';
    Password.text = '';    
  }

  // getData() {
  //   Patient_Model pm = Patient_Model(
  //       First_Name: First_Name.text,
  //       Last_Name: Last_Name.text,
  //       DOB: DOB.text,
  //       Gender: getGender(),
  //       Contact: Contact.text,
  //       Address: Address.text,
  //       HealthInsuranceID: HealthInsuranceID.text,
  //       EmergencyContact: EmergencyContact.text,
  //       MedicalHistory: MedicalHistory.text,
  //       Allergies_Medication: Allergies_Medication.text,
  //       Prefrence: Prefrence.text,
  //       Email: Email.text,
  //       Information: Password.text,
  //       id: '',
  //       Password: Password.text);

  //   //here you can use the object pm to perform CRUD
  // }

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
                  controller: HealthInsuranceID,
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
                  style: TextStyle(color: Colors.blue),
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
        Step(
            state:
                _activeStepIndex <= 2 ? StepState.editing : StepState.complete,
            isActive: _activeStepIndex >= 2,
            title: const Text(
              'Account Setup',
              style: TextStyle(color: Colors.black),
            ),
            content: Column(
              children: [
                Material(
                  color: Color.fromRGBO(236, 242, 255, 1.0),
                  child: Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(100))),
                    child: ListTile(
                      leading: Icon(
                        Icons.fingerprint,
                        color: Colors.blue,
                        size: 30,
                      ),
                      title: Text(
                        "Add Finger Print",
                        style: TextStyle(color: Colors.black),
                      ),
                      onTap: () {},
                    ),
                  ),
                ),
                Container(
                  height: 20,
                ),
                Material(
                  color: Color.fromRGBO(236, 242, 255, 1.0),
                  child: Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(100))),
                    child: ListTile(
                      leading: Icon(
                        Icons.face,
                        color: Colors.blue,
                        size: 30,
                      ),
                      title: Text(
                        "Add Facial Authentication",
                        style: TextStyle(color: Colors.black),
                      ),
                      onTap: () {},
                    ),
                  ),
                ),
                addVerticalSpace(10),
              ],
            ))
      ];

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
                  Text(
                    'Edit',
                    style: TextStyle(color: Colors.black, fontSize: 25),
                  )
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
                  print('Submited');                  
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
                            ? const Text('Submit')
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
