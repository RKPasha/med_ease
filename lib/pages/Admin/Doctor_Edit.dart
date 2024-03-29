import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:med_ease/models/ProfessionalInformation_Model.dart';
import 'package:med_ease/services/remort_services.dart';

import '../../models/Doctors_Model.dart';
import '../../utils/widgets_function.dart';
import 'Admin_Manage.dart';

class Doctor_Edit extends StatefulWidget {
  final User user;
  final Doctor_Model dm;
  const Doctor_Edit({super.key, required this.dm, required this.user});

  @override
  State<Doctor_Edit> createState() => _Doctor_Edit();
}

class _Doctor_Edit extends State<Doctor_Edit> {
  int _activeStepIndex = 0;
  int _selectedOption = 0;
  String id = '';
  bool isLoaded = false;
  TextEditingController First_Name = TextEditingController();
  TextEditingController Last_Name = TextEditingController();
  TextEditingController Certification = TextEditingController();
  TextEditingController Clinic = TextEditingController();
  TextEditingController Contact = TextEditingController();
  TextEditingController Degree = TextEditingController();
  TextEditingController EducationtrainingID = TextEditingController();
  TextEditingController Email = TextEditingController();
  TextEditingController Experience = TextEditingController();
  TextEditingController Experties = TextEditingController();
  TextEditingController Gender = TextEditingController();
  TextEditingController InsuranceID = TextEditingController();
  TextEditingController LiabilityID = TextEditingController();
  TextEditingController LicenseNo = TextEditingController();
  TextEditingController Publication = TextEditingController();
  TextEditingController Specialist = TextEditingController();

  ///******************************Data Fetching code here********************************

  SetGender() {
    if (widget.dm.Gender == 'Male') {
      return 1;
    } else {
      return 2;
    }
  }

  GetGender() {
    if (_selectedOption == 1) {
      return "Male";
    } else {
      return "Female";
    }
  }

  loading() {
    return Container(
      color: Colors.white,
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  List<ProfessionalInformation_Model>? info;
  getProfessionalInfo() async {
    info = await remort_services().getProfessionalInfoByDoc(id);
    if (info != null) {
      for (var i in info!) {
        EducationtrainingID.text = i.EducationTrainingDetails;
        InsuranceID.text = i.InsuranceInformation;
        LiabilityID.text = i.LiabilityInsuranceInformation;
      }
    }
  }

  populate() {
    id = widget.dm.id;
    getProfessionalInfo();
    First_Name.text = widget.dm.First_Name;
    Last_Name.text = widget.dm.Last_Name;
    Certification.text = widget.dm.Certification;
    Clinic.text = widget.dm.Clinic;
    Contact.text = widget.dm.Contact;
    Degree.text = widget.dm.Degree;
    Email.text = widget.dm.Email;
    Experience.text = widget.dm.Experience.toString();
    Experties.text = widget.dm.Experties;
    _selectedOption = SetGender();
    LicenseNo.text = widget.dm.LicenseNo;
    Publication.text = widget.dm.Publication;
    Specialist.text = widget.dm.Specialist;
    setState(() {
      isLoaded = true;
      getall();
    });
    
  }

  getdata() {
    return Doctor_Model(
        id: '',
        First_Name: First_Name.text,
        Certification: Certification.text,
        Gender: GetGender(),
        Last_Name: Last_Name.text,
        Experience: int.parse(Experience.text),
        Experties: Experties.text,
        Contact: Contact.text,
        InsuranceID: 0,
        LiabilityID: 0,
        LicenseNo: LicenseNo.text,
        Publication: Publication.text,
        Specialist: Specialist.text,
        Email: Email.text,
        isDeleted: 0,
        Clinic: Clinic.text,
        Degree: Degree.text,
        EducationTrainingID: 0);
  }

  bool validate() {
    if (First_Name.text != '' &&
        Last_Name.text != '' &&
        Certification.text != '' &&
        Clinic.text != '' &&
        Contact.text != '' &&
        Degree.text != '' &&
        EducationtrainingID.text != '' &&
        Email.text != '' &&
        Experience.text != '' &&
        Experties.text != '' &&
        _selectedOption != 0 &&
        InsuranceID.text != '' &&
        LiabilityID.text != '' &&
        LicenseNo.text != '' &&
        Publication.text != '' &&
        Specialist.text != '') {
      return true;
    } else {
      return false;
    }
  }

  String documentID = '';
  List<ProfessionalInformation_Model>? list;
  List<ProfessionalInformation_Model>? list1;

  updateprofesionalInformation() async {
    await remort_services().update_ProffeessionalInformation(
        EducationtrainingID.text,
        InsuranceID.text,
        LiabilityID.text,
        id,
        widget.dm.InsuranceID,
        documentID);
  }

  getID() async {
    list = await remort_services().getProfessionalInfoByDoc(widget.dm.id);
    if (list != null) {
      documentID = list![0].DocumentId;
    }
  }

  getall() async {
    list1 = await remort_services().getAllProfessionalInfo();
    if (list1 != null) {
      List<String> ids = [];
      for (var i in list1!) {
        ids.add(i.DoctorID);
      }
      if (!ids.contains(widget.dm.id)) {
        ids.add(widget.dm.id);
        Add();
      } else {
        Update();
      }
    }
  }

  Add() async {
    await remort_services().Add_ProffeessionalInformation(
      "Not Yet Added",
      "Not Yet Added",
      "Not Yet Added",
      widget.dm.id,
      0,
    );
  }

  Future<bool> Update() async {
    getID();
    if (validate()) {
      updateprofesionalInformation();
      await remort_services().Update_Doctor(getdata(), id);
      return true;
    } else {
      return false;
    }
  }

  /// ***************************************************************************************
  ///
  @override
  void initState() {
    populate();
  }

  List<Step> stepList() => [
        Step(
          state: _activeStepIndex <= 0 ? StepState.editing : StepState.complete,
          isActive: _activeStepIndex >= 0,
          title:
              const Text('Basic Information', style: TextStyle(fontSize: 15)),
          content: Column(children: [
            addVerticalSpace(8),
            TextField(
              controller: First_Name,
              decoration: InputDecoration(
                prefixIcon:
                    const Icon(Icons.person_2_outlined, color: Colors.blue),
                labelText: 'First Name',
                filled: true,
                hintText: 'First Name',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            addVerticalSpace(8),
            TextField(
              controller: Last_Name,
              decoration: InputDecoration(
                prefixIcon:
                    const Icon(Icons.person_2_outlined, color: Colors.blue),
                labelText: 'Last Name',
                filled: true,
                hintText: 'Last Name',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            addVerticalSpace(8),
            TextField(
              controller: Contact,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.book_outlined, color: Colors.blue),
                labelText: 'Contact',
                filled: true,
                hintText: 'Contact',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
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
              enabled: false,
              controller: Email,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.email, color: Colors.blue),
                labelText: 'Email',
                filled: true,
                hintText: 'Email',
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
              'Professional Information',
            ),
            content: Column(
              children: [
                addVerticalSpace(8),
                TextField(
                  controller: Degree,
                  autocorrect: true,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.contact_page_outlined,
                        color: Colors.blue),
                    labelText: 'Degree',
                    filled: true,
                    hintText: 'Degree',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                addVerticalSpace(8),
                TextField(
                  controller: EducationtrainingID,
                  decoration: InputDecoration(
                    prefixIcon:
                        const Icon(Icons.perm_identity, color: Colors.blue),
                    labelText: 'Educationtraining',
                    filled: true,
                    hintText: 'Education Training',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                addVerticalSpace(8),
                TextField(
                  controller: Experience,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.timelapse_outlined,
                        color: Colors.blue),
                    labelText: 'Experience',
                    filled: true,
                    hintText: 'Experience',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                addVerticalSpace(8),
                TextField(
                  controller: Experties,
                  decoration: InputDecoration(
                    prefixIcon:
                        const Icon(Icons.medication, color: Colors.blue),
                    filled: true,
                    hintText: 'Experties',
                    labelText: 'Experties',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                addVerticalSpace(10),
                TextFormField(
                  controller: InsuranceID,
                  decoration: InputDecoration(
                    prefixIcon:
                        const Icon(Icons.perm_identity, color: Colors.blue),
                    filled: true,
                    hintText: 'Insurance',
                    labelText: 'Insurance',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                addVerticalSpace(8),
                TextField(
                  controller: LiabilityID,
                  decoration: InputDecoration(
                    prefixIcon:
                        const Icon(Icons.perm_identity, color: Colors.blue),
                    labelText: 'Liability',
                    filled: true,
                    hintText: 'Liability',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                addVerticalSpace(8),
                TextField(
                  controller: LicenseNo,
                  decoration: InputDecoration(
                    prefixIcon:
                        const Icon(Icons.perm_identity, color: Colors.blue),
                    labelText: 'LicenseNo',
                    filled: true,
                    hintText: 'LicenseNo',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                addVerticalSpace(8),
                TextField(
                  controller: Publication,
                  decoration: InputDecoration(
                    prefixIcon:
                        const Icon(Icons.book_rounded, color: Colors.blue),
                    labelText: 'Publications',
                    filled: true,
                    hintText: 'Publications',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                addVerticalSpace(8),
                TextField(
                  controller: Specialist,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person_outline_outlined,
                        color: Colors.blue),
                    labelText: 'Specialist',
                    filled: true,
                    hintText: 'Specialist',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            )),
      ];

  Future<bool?> _onBackPressed() async {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              Admin_Manage(manage: 'Doctor', user: widget.user)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoaded != true
        ? loading()
        : WillPopScope(
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
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Admin_Manage(
                                                manage: 'Doctor',
                                                user: widget.user)),
                                      );

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Update Un-Successful!')));
                                    },
                                  );
                                }),
                              ),
                            ),
                            addHorizontalSpace(30),
                            Text(
                              'Edit : ' +
                                  widget.dm.First_Name +
                                  " " +
                                  widget.dm.Last_Name,
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
                      onStepContinue: () async {
                        if (_activeStepIndex < (stepList().length - 1)) {
                          setState(() {
                            _activeStepIndex += 1;
                          });
                        } else {
                          try {
                            if (await Update()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(' Successfully Updated!')));
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Admin_Manage(
                                          user: widget.user,
                                          manage: 'Doctor',
                                        )),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Input Missing!')));
                            }
                          } catch (e) {
                            print(e);
                          }
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
                        final isLastStep =
                            _activeStepIndex == stepList().length - 1;
                        return Padding(
                          padding: const EdgeInsets.only(top: 10.0),
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
                                  style: ElevatedButton.styleFrom(
                                      fixedSize: const Size(
                                          double.infinity, double.infinity)),
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
