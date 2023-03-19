import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:med_ease/pages/Patient/Appointments.dart';

import '../../utils/constants.dart';
import '../../utils/widgets_function.dart';

//import 'Posts.dart';

class Make_Appointment extends StatefulWidget {
  final User user;
  const Make_Appointment({super.key, required this.user});

  @override
  State<Make_Appointment> createState() => _Make_Appointment();
}

class _Make_Appointment extends State<Make_Appointment> {
  final Doctor = TextEditingController();
  final Clinic = TextEditingController();
  final DateInput = TextEditingController();
  final TimeInput = TextEditingController();
  bool inserted = false;

  @override
  void initState() {
    super.initState();
  }

  process() {
    try {
      insertData();
      return;
    } catch (e) {
      // inserted = false;
      return;
    }
  }

  insertData() async {
    if (Doctor.text != '' &&
        Clinic.text != '' &&
        DateInput != '' &&
        TimeInput != '') {
      inserted = true;
      return;
    } else {
      inserted = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Appointments(user: widget.user,)),
            );
          },
        ),
        centerTitle: true,
        title: const Text(
          "Appointments",
          style: TextStyle(color: Color.fromRGBO(255, 254, 251, 0.992)),
        ),
      ),
      body: SingleChildScrollView(
        //physics: const NeverScrollableScrollPhysics(),
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
                                    color: Colors.blue,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w700),
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
                            style: const TextStyle(
                                color: Colors
                                    .black), //editing controller of this TextField
                            decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.calendar_month,
                                    color: Colors.blue),
                                fillColor: COLOR_GREY,
                                filled: true,
                                hintText: 'Appointment Date',
                                hintStyle: const TextStyle(color: Colors.black),
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
                            style: const TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              prefixIcon:
                                  const Icon(Icons.title, color: Colors.blue),
                              fillColor: COLOR_GREY,
                              filled: true,
                              hintText: 'Time',
                              hintStyle: const TextStyle(color: Colors.black),
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
                          TextField(
                            controller: Clinic,
                            keyboardType: TextInputType.multiline,
                            style: const TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.description,
                                  color: Colors.blue),
                              fillColor: COLOR_GREY,
                              filled: true,
                              hintText: 'Clinic',
                              hintStyle: const TextStyle(color: Colors.black),
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
                          TextField(
                            controller: Doctor,
                            style: const TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              prefixIcon:
                                  const Icon(Icons.title, color: Colors.blue),
                              fillColor: COLOR_GREY,
                              filled: true,
                              hintText: 'Doctor',
                              hintStyle: const TextStyle(color: Colors.black),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
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
                                process();
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
                                      content: const Text(
                                          'Data inserted with no problems :) !'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, 'OK'),
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
                                Icons.save,
                                color: Colors.white,
                              ),
                              label: Text(
                                'Save',
                                style: TEXT_THEME_DEFAULT.bodyText1,
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
