import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:med_ease/Models/Appointments_Model.dart';
import 'package:med_ease/pages/Patient/Make_Appointment.dart';
import 'package:med_ease/pages/Patient/Patient_Home.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Appointments extends StatefulWidget {
  const Appointments({super.key});

  @override
  State<Appointments> createState() => _AppointmentsState();
}

class _AppointmentsState extends State<Appointments> {
  bool IsLoaded = true;
  List<Appointments_Model>? appointment;

  @override
  Widget build(BuildContext context) {
    ScrollController scollBarController = ScrollController();
    return Scaffold(
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
              MaterialPageRoute(
                  builder: (context) =>
                      Patient_Home(user: FirebaseAuth.instance.currentUser)),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Make_Appointment()),
          );
        },
        tooltip: 'Make Appointment',
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.add,
          color: Colors.blue,
        ),
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
              //itemCount: appointment?.length,
              itemCount: 5,
              itemBuilder: (context, index) {
                const Text('Swipe right to Access Delete method');

                return Slidable(
                  // Specify a key if the Slidable is dismissible.
                  //key: Key(appointment![index].id),

                  // The start action pane is the one at the left or the top side.
                  startActionPane: ActionPane(
                    // A motion is a widget used to control how the pane animates.
                    motion: const ScrollMotion(),

                    // A pane can dismiss the Slidable.
                    dismissible: DismissiblePane(
                      //key: Key(appointment![index].id),
                      onDismissed: () {
                        // Then show a snackbar.
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('dismissed')));
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
                        onPressed: (context) {},
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.blue,
                        icon: Icons.edit,
                        label: 'Edit',
                      ),
                    ],
                  ),
                  child: Container(
                      width: 10000,
                      height: 150,
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
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: 200,
                                        child: RichText(
                                          //remove const when integrating DB
                                          text: const TextSpan(
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                color: Color.fromRGBO(
                                                    255, 251, 235, 3.0),
                                              ),
                                              children: <TextSpan>[
                                                TextSpan(
                                                    text: 'Appointment Date : ',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: Colors.black)),
                                                TextSpan(text: '22-22-22'),
                                                TextSpan(
                                                    text:
                                                        '\nAppointment Time : ',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        color: Colors.black)),
                                                TextSpan(text: '10:00:00'),
                                                TextSpan(
                                                    text: '\n\nDoctor : ',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        color: Colors.black)),
                                                TextSpan(text: '10:00:00'),
                                                TextSpan(
                                                    text: '\nClinic : ',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        color: Colors.black)),
                                                TextSpan(text: '10:00:00'),
                                              ]),
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Row(
                                            children: const [
                                              CircleAvatar(
                                                backgroundColor: Colors.white,
                                                child: Icon(
                                                  Icons
                                                      .pending_actions_outlined,
                                                  color: Colors.blue,
                                                ),
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
    );
  }
}
