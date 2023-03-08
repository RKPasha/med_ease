import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../utils/constants.dart';
import '../../utils/widgets_function.dart';

class Admin_Drawer extends StatefulWidget {
  final String User;
  const Admin_Drawer({super.key, required this.User});

  @override
  State<Admin_Drawer> createState() => _Admin_DrawerState(User);
}

class _Admin_DrawerState extends State<Admin_Drawer> {
  String recieved_user;
  _Admin_DrawerState(this.recieved_user);
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
            const Divider(
              color: Colors.white,
              indent: 0,
              endIndent: 0,
              thickness: 1.5,
              height: 40,
            ),
            addVerticalSpace(40),
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
                const Divider(
                  color: Colors.cyan,
                  indent: 20,
                  endIndent: 20,
                  thickness: 1,
                  height: 5,
                ),
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
                const Divider(
                  color: Colors.cyan,
                  indent: 20,
                  endIndent: 20,
                  thickness: 1,
                  height: 5,
                ),
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
                const Divider(
                  color: Colors.cyan,
                  indent: 20,
                  endIndent: 20,
                  thickness: 1,
                  height: 5,
                ),
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
                  onTap: () {},
                )),
            addVerticalSpace(20),
            const Divider(
              color: Colors.white,
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
