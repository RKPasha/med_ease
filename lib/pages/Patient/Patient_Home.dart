import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:med_ease/pages/Patient/Appointments.dart';
import 'package:med_ease/pages/Patient/Patient_Side_Menu.dart';
import 'package:med_ease/utils/widgets_function.dart';

class Patient_Home extends StatefulWidget {
  final User? user;
  const Patient_Home({super.key, required this.user});

  @override
  State<Patient_Home> createState() => _Patient_HomeState();
}

class _Patient_HomeState extends State<Patient_Home> {
  @override
  Widget build(BuildContext context) {
    String? User = widget.user!.email;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      drawer: Patient_Side_Menu(
        User: User!,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            addVerticalSpace(30),
            Row(
              children: [
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
                          Icons.menu_outlined,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                      );
                    }),
                  ),
                ),
                addHorizontalSpace(30),
                const Text(
                  'Patient Home',
                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.w700),
                )
              ],
            ),
            addVerticalSpace(20),
            Text(
              'Welcome back $User !',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w300,
              ),
            ),
            Container(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 100,
                    width: 170,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.blue[200]),
                    child: const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text(
                        "Info Here!",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Container(
                    height: 100,
                    width: 170,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.blue[200]),
                    child: const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text(
                        "Info Here!",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Appointments()),
                      );
                    },
                    child: Container(
                      width: width * 0.87,
                      padding: const EdgeInsets.only(right: 0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.blue[200]),
                      child: const Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text(
                          "Make Appointments With Doctor.",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            addVerticalSpace(25),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                      height: 30,
                      width: 60,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.blue),
                      child: IconButton(
                          padding: const EdgeInsets.all(0.0),
                          onPressed: () {},
                          icon: const Icon(
                            Icons.book_outlined,
                            color: Colors.white,
                          )))
                ],
              ),
            ),
            addVerticalSpace(10),
            Container(
              width: width * 0.9,
              height: height * 0.4,
              padding: const EdgeInsets.only(right: 20),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.blue[200]),
              child: const Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  "Info Here!",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}