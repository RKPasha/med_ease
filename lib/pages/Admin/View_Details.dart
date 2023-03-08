import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:med_ease/pages/Admin/Admin_Manage.dart';
import 'package:med_ease/pages/Admin/admin_side_navbar.dart';

import '../../utils/widgets_function.dart';
import 'Admin_Drawer.dart';

class ViewDetails extends StatefulWidget {
  final User user;
  final String detailsOf;
  ViewDetails({super.key, required this.user, required this.detailsOf});

  @override
  State<ViewDetails> createState() => _ViewDetailsState();
}

class _ViewDetailsState extends State<ViewDetails> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    ScrollController scollBarController = ScrollController();

    return Scaffold(
        drawer: AdminSideNav(
          user: widget.user,
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            controller: scollBarController,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(children: <Widget>[
                addVerticalSpace(30),
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
                            Icons.arrow_left_outlined,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Admin_Manage(
                                      manage: widget.detailsOf,
                                      user: widget.user)),
                            );
                          },
                        );
                      }),
                    ),
                  ),
                  addHorizontalSpace(30),
                  Text(
                    'View Details (${widget.detailsOf})',
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 27,
                        fontWeight: FontWeight.w700),
                  )
                ]),
                addVerticalSpace(50),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: height * 0.8,
                      width: width * 0.9,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: const [
                                      Text(
                                        "Full Name",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(15),
                                        width: width * 0.8,
                                        height: height * 0.07,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: const [
                                            Text(
                                              "Dr.Muneeb 123",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            Icon(
                                              Icons.copy_outlined,
                                              color: Colors.blue,
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ]),
            )));
  }
}
