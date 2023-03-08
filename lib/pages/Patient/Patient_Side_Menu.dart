import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:med_ease/services/firebase_auth_methods.dart';
import 'package:provider/provider.dart';
import '../../utils/constants.dart';
import '../../utils/widgets_function.dart';

class Patient_Side_Menu extends StatefulWidget {
  final String User;
  const Patient_Side_Menu({super.key, required this.User});

  @override
  State<Patient_Side_Menu> createState() => _Patient_Side_Menu(User);
}

class _Patient_Side_Menu extends State<Patient_Side_Menu> {
  String recieved_user;
  _Patient_Side_Menu(this.recieved_user);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        height: double.infinity,
        width: 250,
        color: Colors.blue,
        child: SafeArea(
            child: Column(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            addVerticalSpace(20),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.white,
                radius: 30.0,
                child: Icon(
                  CupertinoIcons.person,
                  color: Colors.blue,
                  size: 40,
                ),
              ),
              title: Text(
                recieved_user,
                style: TEXT_THEME_DEFAULT.headline3,
              ),
            ),
            addVerticalSpace(70),
            Column(
              children: [
                Material(
                    color: Colors.transparent,
                    child: ListTile(
                      leading: const SizedBox(
                          height: 38,
                          width: 38,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(
                              CupertinoIcons.home,
                              color: Colors.blue,
                            ),
                          )),
                      title: const Text(
                        "Home",
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {},
                    )),
                Material(
                    color: Colors.transparent,
                    child: ListTile(
                      leading: const SizedBox(
                          height: 38,
                          width: 38,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(
                              CupertinoIcons.person,
                              color: Colors.blue,
                            ),
                          )),
                      title: const Text(
                        "Profile",
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {},
                    )),
                Material(
                    color: Colors.transparent,
                    child: ListTile(
                      leading: const SizedBox(
                          height: 38,
                          width: 38,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(
                              CupertinoIcons.question,
                              color: Colors.blue,
                            ),
                          )),
                      title: const Text(
                        "FAQ",
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {},
                    )),
                Material(
                    color: Colors.transparent,
                    child: ListTile(
                      leading: const SizedBox(
                          height: 38,
                          width: 38,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(
                              CupertinoIcons.settings,
                              color: Colors.blue,
                            ),
                          )),
                      title: const Text(
                        "Settings",
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {},
                    )),
              ],
            ),
            addVerticalSpace(50),
            Material(
                color: Colors.transparent,
                child: ListTile(
                  leading: const SizedBox(
                      height: 38,
                      width: 38,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.logout,
                          color: Colors.blue,
                        ),
                      )),
                  title: const Text(
                    "Log Out",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    context.read<FirebaseAuthMethods>().signOut(context);
                  },
                )),
            addVerticalSpace(20),
            const Divider(
              color: Colors.cyan,
              indent: 20,
              endIndent: 20,
              thickness: 1,
              height: 60,
            ),
            const Align(
              alignment: Alignment.bottomCenter,
              child: Image(
                image: AssetImage('assets/images/logo_white.png'),
                height: 130,
                width: 150,
              ),
            )
          ],
        )),
      ),
    );
  }
}
