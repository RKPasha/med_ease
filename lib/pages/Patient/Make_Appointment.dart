import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:med_ease/pages/Patient/Appointments.dart';
import 'package:med_ease/pages/Patient/Patient_Home.dart';
import 'package:med_ease/services/remort_services.dart';

import '../../models/Appointments_Model.dart';
import '../../models/Doctors_Model.dart';
import '../../utils/constants.dart';
import '../../utils/widgets_function.dart';

//import 'Posts.dart';

class Make_Appointment extends StatefulWidget {
  final User user;
  final String patient_ID;
  final String appointment;
  final String appointment_ID;
  const Make_Appointment(
      {super.key,
      required this.user,
      required this.appointment,
      required this.patient_ID,
      required this.appointment_ID});

  @override
  State<Make_Appointment> createState() => _Make_Appointment();
}

class _Make_Appointment extends State<Make_Appointment> {
  final Doctor = TextEditingController();
  final Clinic = TextEditingController();
  final DateInput = TextEditingController();
  final TimeInput = TextEditingController();
  String _dropDownValue = 'Chose Clinic';
  String _dropDownValue1 = 'Chose Doctor';
  String selected_Clinic = '';
  bool inserted = false;
  List<Doctor_Model>? allData;
  List<Appointments_Model>? allappointment;
  List<String> Clinics = [];
  List<String> Doctors = [];
  List<String> Date = [];
  List<String> Time = [];

  display_() {
    if (widget.appointment == 'New') {
      return New_Appointment(context);
    } else {
      return Update_Appointment(context);
    }
  }

  populate_Form() {
    if (allappointment != null) {
      for (int i = 0; i < allappointment!.length; i++) {
        if (allappointment![i].patient_id == widget.patient_ID &&
            allappointment![i].id == widget.appointment_ID) {
          setState(() {
            DateInput.text = allappointment![i].date;
            TimeInput.text = allappointment![i].time;
            _dropDownValue = allappointment![i].clinic;
            _dropDownValue1 = allappointment![i].doctor;
            populate_Clinic();
          });
        }
      }
    }
  }

  Future<bool> getDoctors() async {
    allData = await remort_services().getDoctors();
    if (allData != null) {
      populate_Clinic();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> getAppointments() async {
    allappointment = await remort_services().getAppointments();

    if (allappointment != null) {
      populate_Form();
      return true;
    } else {
      return false;
    }
  }

  bool Validate(String date, String newtime) {
    for (int i = 0; i < allappointment!.length; i++) {
      if (allappointment![i].date == date) {
        Time.add(allappointment![i].time);
      }
    }
    if (!Time.contains(newtime)) {
      return true;
    }
    return false;
  }

  populate_Clinic() {
    Clinics.clear();
    setState(() {
      for (int i = 0; i < allData!.length; i++) {
        if (!Clinics.contains(allData![i].Clinic) &&
            allData![i].Clinic != "Not Yet Added") {
          Clinics.add(allData![i].Clinic);
        }
      }
    });
    print(Clinics);
  }

  populate_Doctor() {
    Doctors.clear();
    for (int i = 0; i < allData!.length; i++) {
      if (allData![i].Clinic == selected_Clinic) {
        Doctors.add(allData![i].First_Name + ' ' + allData![i].Last_Name);
      }
    }
    print(Doctor);
  }

  getDocID(String clinic, String name) {
    print(name);
    for (int i = 0; i < allData!.length; i++) {
      if (allData![i].Clinic == clinic &&
          allData![i].First_Name + ' ' + allData![i].Last_Name == name) {
        print(allData![i].id);
        return allData![i].id;
      }
    }
  }

  @override
  initState() {
    getDoctors();
    getAppointments();
  }

  insertData() async {
    if (_dropDownValue != '' &&
        _dropDownValue != 'Select Clinic' &&
        _dropDownValue1 != '' &&
        _dropDownValue1 != 'Select Doctor' &&
        DateInput.text != '' &&
        DateInput.text != "Appointment Date" &&
        TimeInput.text != '' &&
        TimeInput.text != "Time") {
      if (Validate(DateInput.text, TimeInput.text) == true) {
        try {
          Appointments_Model am = Appointments_Model(
              id: '',
              patient_id: widget.patient_ID,
              time: TimeInput.text,
              isapproved: 0,
              doctor: _dropDownValue1,
              clinic: _dropDownValue,
              date: DateInput.text,
              isdeleted: 0,
              doctor_id: getDocID(_dropDownValue, _dropDownValue1));
          remort_services().MakeAppointment(am);
          inserted = true;
        } catch (e) {
          print(e);
        }
      } else {
        print("Time Already Exists");
      }
    } else {
      inserted = false;
    }
  }

  updateData() {
    if (_dropDownValue != '' &&
        _dropDownValue1 != '' &&
        DateInput != '' &&
        TimeInput != '') {
      try {
        Appointments_Model am = Appointments_Model(
            id: '',
            patient_id: widget.patient_ID,
            time: TimeInput.text,
            isapproved: 0,
            doctor: _dropDownValue1,
            clinic: _dropDownValue,
            date: DateInput.text,
            isdeleted: 0,
            doctor_id: getDocID(_dropDownValue, _dropDownValue1));
        remort_services().UpDate_Appointment(am, widget.appointment_ID);
        inserted = true;
      } catch (e) {
        print(e);
      }
    } else {
      inserted = false;
    }
  }

  Future<bool?> _onBackPressed() async {
    if (widget.appointment == "New") {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Patient_Home(
                  user: widget.user,
                )),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Appointments(
                  user: widget.user,
                  patient_ID: widget.patient_ID,
                )),
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
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Colors.blue,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                if (widget.appointment == "New") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Patient_Home(
                              user: widget.user,
                            )),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Appointments(
                              user: widget.user,
                              patient_ID: widget.patient_ID,
                            )),
                  );
                }
              },
            ),
            centerTitle: true,
            title: const Text(
              "Appointment",
              style: TextStyle(color: Color.fromRGBO(255, 254, 251, 0.992)),
            ),
          ),
          body: display_()),
    );
  }

  SingleChildScrollView New_Appointment(BuildContext context) {
    return SingleChildScrollView(
      //physics: const NeverScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width,
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: IntrinsicHeight(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Padding(
                            padding: EdgeInsets.all(20),
                            child: SizedBox(
                              height: 70,
                              width: 250,
                              child: AutoSizeText(
                                'Make an Appointment',
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.w700),
                                minFontSize: 10,
                                stepGranularity: 5.0,
                              ),
                            ),
                          )
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextField(
                            controller: DateInput,
                            //editing controller of this TextField
                            decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.calendar_month,
                                    color: Colors.blue),
                                hintText: 'Appointment Date',
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
                                  DateInput.text =
                                      formattedDate; //set output date to TextField value.
                                });
                              } else {
                                print("Date is not selected");
                              }
                            },
                          )
                        ],
                      ),
                      addVerticalSpace(30),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextField(
                            controller: TimeInput,
                            onTap: () async {
                              TimeOfDay? pickedTime = await showTimePicker(
                                initialTime: TimeOfDay.now(),
                                context: context,
                              );
                              if (pickedTime != null) {
                                setState(() {
                                  TimeInput.text = pickedTime.format(
                                      context); //set the value of text field.
                                });
                              } else {
                                print("Time is not selected");
                              }
                            },
                            readOnly: true,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.timer_outlined,
                                  color: Colors.blue),
                              hintText: 'Time',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ],
                      ),
                      addVerticalSpace(30),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: DropdownButton(
                                hint: Text(
                                  _dropDownValue,
                                ),
                                isExpanded: true,
                                iconSize: 30.0,
                                style: const TextStyle(fontSize: 16),
                                items: Clinics.map((val) => DropdownMenuItem(
                                      value: val,
                                      child: Text(
                                        val,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    )).toList(),
                                onChanged: (val) {
                                  setState(
                                    () {
                                      _dropDownValue = val!;
                                      selected_Clinic = val;
                                      populate_Doctor();
                                    },
                                  );
                                },
                                onTap: () {
                                  _dropDownValue1 = "Select Doctor";
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                      addVerticalSpace(30),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: DropdownButton(
                                hint: Text(
                                  _dropDownValue1,
                                ),
                                isExpanded: true,
                                iconSize: 30.0,
                                style: const TextStyle(fontSize: 16),
                                items: Doctors.map(
                                  (val) {
                                    return DropdownMenuItem<String>(
                                      value: val,
                                      child: Text(
                                        val,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    );
                                  },
                                ).toList(),
                                onChanged: (val) {
                                  setState(
                                    () {
                                      _dropDownValue1 = val!;
                                    },
                                  );
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                      addVerticalSpace(30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                fixedSize: const Size(120, 50),
                                backgroundColor: Colors.blue,
                              ),
                              onPressed: () {
                                insertData();
                                if (inserted == true) {
                                  //ID.text = '';
                                  _dropDownValue = 'Select Clinic';
                                  _dropDownValue1 = 'Select Doctor';
                                  DateInput.text = '';
                                  TimeInput.text = '';
                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      title: const Text('Successfull!'),
                                      content: const Text(
                                          'Please wait for the approval of your appointment!'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Patient_Home(
                                                          user: widget.user)),
                                            );
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      title: const Text('Error'),
                                      content: const Text(
                                          'Input Missing! or A Possible Time Clash!'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, 'Cancel'),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, 'OK'),
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                              icon: const Icon(
                                Icons.send,
                                color: Colors.white,
                              ),
                              label: const Text(
                                'Submit',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              )),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  SingleChildScrollView Update_Appointment(BuildContext context) {
    return SingleChildScrollView(
      //physics: const NeverScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width,
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: IntrinsicHeight(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Padding(
                            padding: EdgeInsets.all(20),
                            child: SizedBox(
                              height: 70,
                              width: 250,
                              child: AutoSizeText(
                                'Update Appointment',
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.w700),
                                minFontSize: 10,
                                stepGranularity: 5.0,
                              ),
                            ),
                          )
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextField(
                            controller: DateInput,
                            //editing controller of this TextField
                            decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.calendar_month,
                                    color: Colors.blue),
                                hintText: 'Appointment Date',
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
                                  DateInput.text =
                                      formattedDate; //set output date to TextField value.
                                });
                              } else {
                                print("Date is not selected");
                              }
                            },
                          )
                        ],
                      ),
                      addVerticalSpace(30),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextField(
                            controller: TimeInput,
                            onTap: () async {
                              TimeOfDay? pickedTime = await showTimePicker(
                                initialTime: TimeOfDay.now(),
                                context: context,
                              );
                              if (pickedTime != null) {
                                setState(() {
                                  TimeInput.text = pickedTime.format(
                                      context); //set the value of text field.
                                });
                              } else {
                                print("Time is not selected");
                              }
                            },
                            readOnly: true,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.timer_outlined,
                                  color: Colors.blue),
                              hintText: 'Time',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ],
                      ),
                      addVerticalSpace(30),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: DropdownButton(
                                hint: Text(
                                  _dropDownValue,
                                ),
                                isExpanded: true,
                                iconSize: 30.0,
                                style: const TextStyle(fontSize: 16),
                                items: Clinics.map(
                                  (val) {
                                    return DropdownMenuItem<String>(
                                      value: val,
                                      child: Text(val),
                                    );
                                  },
                                ).toList(),
                                onChanged: (val) {
                                  setState(
                                    () {
                                      _dropDownValue = val!;
                                      selected_Clinic = val;
                                      populate_Doctor();
                                    },
                                  );
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                      addVerticalSpace(30),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: DropdownButton(
                                hint: Text(
                                  _dropDownValue1,
                                ),
                                isExpanded: true,
                                iconSize: 30.0,
                                style: const TextStyle(fontSize: 16),
                                items: Doctors.map(
                                  (val) {
                                    return DropdownMenuItem<String>(
                                      value: val,
                                      child: Text(val),
                                    );
                                  },
                                ).toList(),
                                onChanged: (val) {
                                  setState(
                                    () {
                                      _dropDownValue1 = val!;
                                    },
                                  );
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                      addVerticalSpace(30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                fixedSize: const Size(120, 50),
                                backgroundColor: Colors.blue,
                              ),
                              onPressed: () {
                                updateData();
                                if (inserted == true) {
                                  //ID.text = '';
                                  Doctor.text = '';
                                  Clinic.text = '';
                                  DateInput.text = '';
                                  TimeInput.text = '';
                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      title: const Text('Successfull!'),
                                      content:
                                          const Text('Appointment Updated!'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Appointments(
                                                        user: widget.user,
                                                        patient_ID:
                                                            widget.patient_ID,
                                                      )),
                                            );
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      title: const Text('Error'),
                                      content: const Text(
                                          'Input Missing! Please fill all the input boxes'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, 'Cancel'),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, 'OK'),
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                              icon: const Icon(
                                Icons.send,
                                color: Colors.white,
                              ),
                              label: const Text(
                                'Submit',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              )),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
