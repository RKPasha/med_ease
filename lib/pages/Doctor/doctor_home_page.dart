import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:med_ease/utils/side_navbar.dart';

class DoctorHomePage extends StatefulWidget {
  final User user;
  const DoctorHomePage({super.key, required this.user});

  @override
  State<DoctorHomePage> createState() => _DoctorHomePage();
}

class _DoctorHomePage extends State<DoctorHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Home Page'),
        backgroundColor: Colors.blue,
      ),
      drawer: SideNav(user: widget.user),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('Welcome ${widget.user.email}')],
        ),
      ),
    );
  }
}
