import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../models/Appointments_Model.dart';
import '../../services/remort_services.dart';
import 'Make_Appointment.dart';
import 'Patient_Home.dart';

class Appointments extends StatefulWidget {
  final User user;
  final String patient_ID;
  const Appointments({super.key, required this.user, required this.patient_ID});

  @override
  State<Appointments> createState() => _AppointmentsState();
}

class _AppointmentsState extends State<Appointments> {
  bool IsLoaded = false;
  List<Appointments_Model>? appointment;

  Widget Pending_Icon = const Icon(
    Icons.pending_actions_outlined,
    color: Colors.blue,
  );

  Widget Approved_Icon = const Icon(
    Icons.check_circle,
    color: Colors.blue,
  );

  getIcon(int num) {
    if (num == 0) {
      return Pending_Icon;
    } else {
      return Approved_Icon;
    }
  }

  Future<bool> getAppointments() async {
    appointment =
        await remort_services().getAppointmentsbyPatient(widget.patient_ID);
    if (appointment != null) {
      setState(() {
        IsLoaded = true;
      });
      return true;
    } else {
      setState(() {
        IsLoaded = false;
      });
      return false;
    }
  }

  deleteAppointment(String id) {
    try {
      remort_services().DeleteAppointment(id);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  void initState() {
    getAppointments();
  }

  Future<bool?> _onBackPressed() async {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Patient_Home(
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
                    builder: (context) => Patient_Home(
                          user: widget.user,
                        )),
              );
            },
          ),
          centerTitle: true,
          title: const Text(
            "Appointments",
            style: TextStyle(color: Color.fromRGBO(255, 254, 251, 0.992)),
          ),
          //backgroundColor: Color.fromRGBO(68, 60, 104, 1.0),
        ),
        body: Scrollbar(
          controller: scollBarController,
          child: Visibility(
            visible: IsLoaded,
            replacement: const Center(
              child: CircularProgressIndicator(),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: ListView.builder(
                itemCount: appointment?.length,
                itemBuilder: (context, index) {
                  const Text('Swipe right to Access Delete method');

                  return Slidable(
                    key: Key(appointment![index].id),
                    // The start action pane is the one at the left or the top side.
                    startActionPane: ActionPane(
                      // A motion is a widget used to control how the pane animates.
                      motion: const ScrollMotion(),

                      // A pane can dismiss the Slidable.
                      dismissible: DismissiblePane(
                        key: Key(appointment![index].id),
                        onDismissed: () {
                          if (deleteAppointment(appointment![index].id) ==
                              true) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('dismissed')));
                          }
                        },
                      ),

                      // All actions are defined in the children parameter.
                      children: const [
                        // A SlidableAction can have an icon and/or a label.
                        SlidableAction(
                          onPressed: null,
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
                            if (appointment![index].isapproved == 0) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Make_Appointment(
                                          user: widget.user,
                                          appointment: 'Update',
                                          patient_ID: widget.patient_ID,
                                          appointment_ID:
                                              appointment![index].id,
                                        )),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Cannot Edit! Appointment Approved!')));
                            }
                          },
                          foregroundColor: Colors.blue,
                          icon: Icons.edit,
                          label: 'Edit',
                        ),
                      ],
                    ),
                    child: SizedBox(
                        width: 10000,
                        height: 160,
                        child: GestureDetector(
                            onTap: () {},
                            child: Card(
                              margin: const EdgeInsets.all(5),
                              color: Colors.blue,
                              shadowColor: Colors.white,
                              elevation: 10,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          width: 250,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: RichText(
                                              //remove const when integrating DB
                                              text: TextSpan(
                                                  style: const TextStyle(
                                                      fontSize: 14.0,
                                                      color: Colors.black),
                                                  children: <TextSpan>[
                                                    const TextSpan(
                                                        text:
                                                            'Appointment Date : ',
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color:
                                                                Colors.black)),
                                                    TextSpan(
                                                        text:
                                                            appointment![index]
                                                                .date),
                                                    const TextSpan(
                                                        text:
                                                            '\nAppointment Time : ',
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            color:
                                                                Colors.black)),
                                                    TextSpan(
                                                        text:
                                                            appointment![index]
                                                                .time),
                                                    const TextSpan(
                                                        text: '\n\nDoctor : ',
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            color:
                                                                Colors.black)),
                                                    TextSpan(
                                                        text:
                                                            appointment![index]
                                                                .doctor),
                                                    const TextSpan(
                                                        text: '\nClinic : ',
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            color:
                                                                Colors.black)),
                                                    TextSpan(
                                                        text:
                                                            appointment![index]
                                                                .clinic),
                                                  ]),
                                            ),
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                CircleAvatar(
                                                  backgroundColor: Colors.white,
                                                  child: getIcon(
                                                      appointment![index]
                                                          .isapproved),
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}
