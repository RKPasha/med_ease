import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:med_ease/pages/Doctor/Doctor_Home.dart';
import 'package:med_ease/services/remort_services.dart';

import '../../models/Doctors_Model.dart';
import '../../models/ProfessionalInformation_Model.dart';
import '../../utils/widgets_function.dart';

class Doctor_SignUp extends StatefulWidget {
  final User user;
  final Doctor_Model dm;
  const Doctor_SignUp({super.key, required this.dm, required this.user});

  @override
  State<Doctor_SignUp> createState() => _Doctor_SignUp();
}

class _Doctor_SignUp extends State<Doctor_SignUp> {
  int _activeStepIndex = 0;
  int _selectedOption = 0;
  String id = '';
  int maxId = 0;
  bool isLoaded = false;
  List<ProfessionalInformation_Model>? allinfo;
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
  TextEditingController InsuranceID = TextEditingController();
  TextEditingController LiabilityID = TextEditingController();
  TextEditingController LicenseNo = TextEditingController();
  TextEditingController Publication = TextEditingController();
  TextEditingController Specialist = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  ///******************************Data Fetching code here********************************
  bool isValidName(String value) {
    return RegExp(r'^[a-zA-Z ]+$').hasMatch(value);
  }

  bool isValidContact(String value) {
    return RegExp(r'^[0-9]+$').hasMatch(value);
  }

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

  populate() {
    fetchID();
    getall();
    print(maxId);
    getProfessionalInfo();
    id = widget.dm.id;
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
    //LiabilityID.text = widget.dm.LiabilityID.toString();
    // EducationtrainingID.text = widget.dm.EducationTrainingID.toString();
    //InsuranceID.text = widget.dm.InsuranceID.toString();
    isLoaded = true;
  }

  loading() {
    return Container(
      color: Colors.white,
      child: const Center(child: CircularProgressIndicator()),
    );
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
        InsuranceID: maxId,
        LiabilityID: maxId,
        LicenseNo: LicenseNo.text,
        Publication: Publication.text,
        Specialist: Specialist.text,
        Email: Email.text,
        isDeleted: 0,
        Clinic: Clinic.text,
        Degree: Degree.text,
        EducationTrainingID: maxId);
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

  List<ProfessionalInformation_Model>? info;
  getProfessionalInfo() async {
    info = await remort_services().getProfessionalInfoByDoc(widget.dm.id);
    if (info != null) {
      for (var i in info!) {
        EducationtrainingID.text = i.EducationTrainingDetails;
        InsuranceID.text = i.InsuranceInformation;
        LiabilityID.text = i.LiabilityInsuranceInformation;
      }
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
    if (_formKey.currentState!.validate() &&
        _formKey2.currentState!.validate()) {
      updateprofesionalInformation();
      await remort_services().Update_Doctor(getdata(), id);
      return true;
    } else {
      return false;
    }
  }

  fetchID() async {
    allinfo = await remort_services().getAllProfessionalInfo();
    if (allinfo == null) {
      setState(() {
        maxId = 1;
      });
    } else {
      List<int> Ids = [];
      for (var i in allinfo!) {
        Ids.add(i.ID);
      }
      maxId = Ids.reduce((curr, next) => curr > next ? curr : next);
      setState(() {
        maxId += 1;
      });
    }
  }

  profesionalInformation() async {
    await remort_services().Add_ProffeessionalInformation(
        EducationtrainingID.text,
        InsuranceID.text,
        LiabilityID.text,
        id,
        maxId);
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
          content: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Form(
              key: _formKey,
              child: Column(children: [
                addVerticalSpace(8),
                TextFormField(
                  onTap: () {
                    if (First_Name.text == "Not Yet Added") {
                      Last_Name.text = "";
                    }
                  },
                  controller: First_Name,
                  decoration: InputDecoration(
                    prefixIcon:
                        const Icon(Icons.person_2_outlined, color: Colors.blue),
                    labelText: 'First Name',
                    hintText: 'First Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value == 'Not Yet Added' ||
                        value.isEmpty ||
                        !isValidName(value.trim())) {
                      return 'Please enter valid first name';
                    } else if (value.length < 3 || value.length > 15) {
                      return 'Name must be 3-15 characters long';
                    }
                    return null;
                  },
                ),
                addVerticalSpace(8),
                TextFormField(
                  onTap: () {
                    if (Last_Name.text == "Not Yet Added") {
                      Last_Name.text = "";
                    }
                  },
                  controller: Last_Name,
                  decoration: InputDecoration(
                    prefixIcon:
                        const Icon(Icons.person_2_outlined, color: Colors.blue),
                    labelText: 'Last Name',
                    hintText: 'Last Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value == 'Not Yet Added' ||
                        value.isEmpty ||
                        !isValidName(value.trim())) {
                      return 'Please enter valid last name';
                    } else if (value.length < 3 || value.length > 15) {
                      return 'Name must be 3-15 characters long';
                    }
                    return null;
                  },
                ),
                addVerticalSpace(8),
                TextFormField(
                  onTap: () {
                    if (Contact.text == "Not Yet Added") {
                      Contact.text = "";
                    }
                  },
                  controller: Contact,
                  decoration: InputDecoration(
                    prefixIcon:
                        const Icon(Icons.book_outlined, color: Colors.blue),
                    labelText: 'Contact',
                    hintText: 'Contact',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value == 'Not Yet Added' ||
                        value.isEmpty ||
                        !isValidContact(value.trim())) {
                      return 'Please enter valid contact';
                    } else if (value.length < 11 || value.length > 15) {
                      return 'Contact must be 11-15 digits long';
                    }
                    return null;
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
                    const Text('Male', style: TextStyle()),
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
                    const Text('Female', style: TextStyle()),
                  ],
                ),
                addVerticalSpace(8),
                TextFormField(
                  onTap: () {
                    if (Email.text == "Not Yet Added") {
                      Email.text = "";
                    }
                  },
                  controller: Email,
                  enabled: false,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email, color: Colors.blue),
                    labelText: 'Email',
                    hintText: 'Email',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ]),
            ),
          ),
        ),
        Step(
            state:
                _activeStepIndex <= 1 ? StepState.editing : StepState.complete,
            isActive: _activeStepIndex >= 1,
            title: const Text(
              'Professional Information',
              style: TextStyle(),
            ),
            content: Form(
              key: _formKey2,
              child: Column(
                children: [
                  addVerticalSpace(8),
                  TextFormField(
                    onTap: () {
                      if (Degree.text == "Not Yet Added") {
                        Degree.text = "";
                      }
                    },
                    controller: Degree,
                    autocorrect: true,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.contact_page_outlined,
                          color: Colors.blue),
                      labelText: 'Degree',
                      hintText: 'Degree',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value == 'Not Yet Added' ||
                          value.isEmpty ||
                          !isValidName(value.trim())) {
                        return 'Please enter valid degree';
                      } else if (value.length < 3 || value.length > 20) {
                        return 'Degree name must be 3-20 characters long';
                      }
                      return null;
                    },
                  ),
                  addVerticalSpace(8),
                  TextFormField(
                    onTap: () {
                      if (Certification.text == "Not Yet Added") {
                        Certification.text = "";
                      }
                    },
                    controller: Certification,
                    autocorrect: true,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.contact_page_outlined,
                          color: Colors.blue),
                      labelText: 'Certification',
                      hintText: 'Certification',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value == 'Not Yet Added' ||
                          value.isEmpty ||
                          !isValidName(value.trim())) {
                        return 'Please enter valid certification';
                      } else if (value.length < 3 || value.length > 20) {
                        return 'Certification name must be 3-20 characters long';
                      }
                      return null;
                    },
                  ),
                  addVerticalSpace(8),
                  TextFormField(
                    onTap: () {
                      if (Clinic.text == "Not Yet Added") {
                        Clinic.text = "";
                      }
                    },
                    controller: Clinic,
                    autocorrect: true,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.contact_page_outlined,
                          color: Colors.blue),
                      labelText: 'Clinic',
                      hintText: 'Clinic',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value == 'Not Yet Added' ||
                          value.isEmpty ||
                          !isValidName(value.trim())) {
                        return 'Please enter valid clinic';
                      } else if (value.length < 3 || value.length > 20) {
                        return 'Clinic name must be 3-20 characters long';
                      }
                      return null;
                    },
                  ),
                  addVerticalSpace(8),
                  TextFormField(
                    onTap: () {
                      if (EducationtrainingID.text == "Not Yet Added") {
                        EducationtrainingID.text = "";
                      }
                    },
                    controller: EducationtrainingID,
                    decoration: InputDecoration(
                      prefixIcon:
                          const Icon(Icons.perm_identity, color: Colors.blue),
                      labelText: 'Education Training',
                      hintText: 'Education Training',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value == 'Not Yet Added' ||
                          value.isEmpty ||
                          !isValidName(value.trim())) {
                        return 'Please enter valid education training';
                      } else if (value.length < 3 || value.length > 20) {
                        return 'Education training name must be 3-20 characters long';
                      }
                      return null;
                    },
                  ),
                  addVerticalSpace(8),
                  TextFormField(
                    onTap: () {
                      if (Experience.text == "0") {
                        Experience.text = "";
                      }
                    },
                    controller: Experience,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.timelapse_outlined,
                          color: Colors.blue),
                      labelText: 'Experience (In years)',
                      hintText: 'Experience',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value == '0' ||
                          value.isEmpty ||
                          !isValidContact(value.trim())) {
                        return 'Please enter valid experience';
                      } else if (value.length < 1 || value.length > 2) {
                        return 'Experience must be 1-2 digits long';
                      }
                      return null;
                    },
                  ),
                  addVerticalSpace(8),
                  TextFormField(
                    onTap: () {
                      if (Experties.text == "Not Yet Added") {
                        Experties.text = "";
                      }
                    },
                    controller: Experties,
                    decoration: InputDecoration(
                      prefixIcon:
                          const Icon(Icons.medication, color: Colors.blue),
                      hintText: 'Experties',
                      labelText: 'Experties',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value == 'Not Yet Added' ||
                          value.isEmpty ||
                          !isValidName(value.trim())) {
                        return 'Please enter valid experties';
                      } else if (value.length < 3 || value.length > 20) {
                        return 'Experties name must be 3-20 characters long';
                      }
                      return null;
                    },
                  ),
                  addVerticalSpace(10),
                  TextFormField(
                    onTap: () {
                      if (InsuranceID.text == "Not Yet Added") {
                        InsuranceID.text = "";
                      }
                    },
                    controller: InsuranceID,
                    decoration: InputDecoration(
                      prefixIcon:
                          const Icon(Icons.perm_identity, color: Colors.blue),
                      hintText: 'Insurance',
                      labelText: 'Insurance',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value == 'Not Yet Added' ||
                          value.isEmpty ||
                          !isValidName(value.trim())) {
                        return 'Please enter valid insurance';
                      } else if (value.length < 3 || value.length > 20) {
                        return 'Insurance name must be 3-20 characters long';
                      }
                      return null;
                    },
                  ),
                  addVerticalSpace(8),
                  TextFormField(
                    onTap: () {
                      if (LiabilityID.text == "Not Yet Added") {
                        LiabilityID.text = "";
                      }
                    },
                    controller: LiabilityID,
                    decoration: InputDecoration(
                      prefixIcon:
                          const Icon(Icons.perm_identity, color: Colors.blue),
                      labelText: 'Liability',
                      hintText: 'Liability',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value == 'Not Yet Added' ||
                          value.isEmpty ||
                          !isValidName(value.trim())) {
                        return 'Please enter valid liability';
                      } else if (value.length < 3 || value.length > 20) {
                        return 'Liability name must be 3-20 characters long';
                      }
                      return null;
                    },
                  ),
                  addVerticalSpace(8),
                  TextFormField(
                    onTap: () {
                      if (LicenseNo.text == "Not Yet Added") {
                        LicenseNo.text = "";
                      }
                    },
                    controller: LicenseNo,
                    decoration: InputDecoration(
                      prefixIcon:
                          const Icon(Icons.perm_identity, color: Colors.blue),
                      labelText: 'LicenseNo',
                      hintText: 'LicenseNo',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value == 'Not Yet Added' ||
                          value.isEmpty ||
                          !isValidContact(value.trim())) {
                        return 'Please enter valid license no (only digits)';
                      } else if (value.length < 3 || value.length > 20) {
                        return 'License no. must be 3-20 digits long';
                      }
                      return null;
                    },
                  ),
                  addVerticalSpace(8),
                  TextFormField(
                    onTap: () {
                      if (Publication.text == "Not Yet Added") {
                        Publication.text = "";
                      }
                    },
                    controller: Publication,
                    decoration: InputDecoration(
                      prefixIcon:
                          const Icon(Icons.book_rounded, color: Colors.blue),
                      labelText: 'Publications',
                      hintText: 'Publications',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value == 'Not Yet Added' ||
                          value.isEmpty ||
                          !isValidName(value.trim())) {
                        return 'Please enter valid publication';
                      } else if (value.length < 3 || value.length > 20) {
                        return 'Publication name must be 3-20 characters long';
                      }
                      return null;
                    },
                  ),
                  addVerticalSpace(8),
                  TextFormField(
                    onTap: () {
                      if (Specialist.text == "Not Yet Added") {
                        Specialist.text = "";
                      }
                    },
                    controller: Specialist,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_outline_outlined,
                          color: Colors.blue),
                      labelText: 'Specialist',
                      hintText: 'Specialist',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value == 'Not Yet Added' ||
                          value.isEmpty ||
                          !isValidName(value.trim())) {
                        return 'Please enter valid specialist';
                      } else if (value.length < 3 || value.length > 20) {
                        return 'Specialist name must be 3-20 characters long';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            )),
      ];

  Future<bool?> _onBackPressed() async {
    if (_formKey.currentState!.validate() &&
        _formKey2.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Doctor_Home(user: widget.user)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(' Input Missing or Not yet Filled!')));
    }
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
                                      if (_formKey.currentState!.validate() &&
                                          _formKey2.currentState!.validate()) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Doctor_Home(
                                                  user: widget.user)),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    ' Input Missing or Not yet Filled!')));
                                      }
                                    },
                                  );
                                }),
                              ),
                            ),
                            addHorizontalSpace(30),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                (widget.dm.First_Name.length +
                                            widget.dm.Last_Name.length <=
                                        15)
                                    ? 'Edit: ${widget.dm.First_Name} ${widget.dm.Last_Name}'
                                    : 'Edit: ${widget.dm.First_Name}\n${widget.dm.Last_Name}',
                                style: const TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.w700),
                                softWrap: false,
                                overflow: TextOverflow.ellipsis,
                              ),
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
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _activeStepIndex += 1;
                            });
                          }
                        } else {
                          try {
                            if (_formKey.currentState!.validate() &&
                                _formKey2.currentState!.validate()) {
                              if (await Update()) {
                                if (mounted) {}
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text(' Successfully Updated!')));
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Doctor_Home(
                                            user: widget.user,
                                          )),
                                );
                              } else {
                                if (mounted) {}
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Input missing or Not yet Filled!')));
                              }
                            }
                          } catch (e) {
                            if (mounted) {}
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())));
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
