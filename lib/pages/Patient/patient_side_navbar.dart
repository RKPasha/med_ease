import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:med_ease/models/Appointments_Model.dart';
import 'package:med_ease/models/Patient_Model.dart';
import 'package:med_ease/models/Report_Model.dart';
import 'package:med_ease/pages/Doctor/Manage_Reports.dart';
import 'package:med_ease/pages/Patient/Appointments.dart';
import 'package:med_ease/pages/Patient/Manage_Info.dart';
import 'package:med_ease/pages/Patient/Patient_Reports.dart';
import 'package:med_ease/pages/general_settings.dart';
import 'package:med_ease/services/firebase_auth_methods.dart';
import 'package:med_ease/services/remort_services.dart';
import 'package:med_ease/utils/theme_provider.dart';
import 'package:provider/provider.dart';

class PatientSideNav extends StatefulWidget {
  final User user;
  final String name;
  final String id;
  final Patient_Model pm;
  final List<Appointments_Model>? approvedappointments;
  const PatientSideNav(
      {super.key,
      required this.user,
      required this.name,
      this.approvedappointments,
      required this.id,
      required this.pm});

  @override
  State<PatientSideNav> createState() => _PatientSideNavState();
}

class _PatientSideNavState extends State<PatientSideNav> {
  ThemeProvider themeProvider = ThemeProvider();
  final _storage = const FlutterSecureStorage();
  _SupportState _supportState = _SupportState.unknown;
  final LocalAuthentication _auth = LocalAuthentication();
  bool _useBiometrics = true;
  List<Report_Model>? allReports;

  getData() async {
    allReports = await remort_services().getAllReports();
  }

  @override
  void initState() {
    getData();
    _storage.read(key: 'useBiometrics').then((value) {
      if (value == 'true') {
        setState(() {
          _useBiometrics = true;
        });
      } else {
        setState(() {
          _useBiometrics = false;
        });
      }
    });
    _auth.isDeviceSupported().then(
          (bool isSupported) => setState(() => _supportState = isSupported
              ? _SupportState.supported
              : _SupportState.unsupported),
        );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    themeProvider = Provider.of<ThemeProvider>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              // Remove padding
              padding: EdgeInsets.zero,
              children: [
                UserAccountsDrawerHeader(
                  // accountName: Text(widget.usersModel.name ?? ''),
                  accountName: Text(
                    widget.name,
                    style: const TextStyle(color: Colors.black),
                  ),
                  accountEmail: Text(
                    widget.user.email!,
                    style: const TextStyle(color: Colors.black),
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage('assets/images/playstore1.png')),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Profile'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Manage_Info(
                          user: widget.user,
                          pm: widget.pm,
                          ID: widget.id,
                        ),
                      ),
                    );
                  },
                ),
                ListTile(
                    leading: const Icon(Icons.calendar_month),
                    title: const Text('Appointments'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Appointments(
                            user: widget.user,
                            patient_ID: widget.id,
                          ),
                        ),
                      );
                    }),
                ListTile(
                    leading: const Icon(Icons.file_copy_rounded),
                    title: const Text('Reports'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Patient_Reports(
                            user: widget.user,
                            patientId: widget.id,
                          ),
                        ),
                      );
                    }),
                // ListTile(
                //   leading: const Icon(Icons.notifications),
                //   title: const Text('Notifications'),
                //   trailing: ClipOval(
                //     child: Container(
                //       color: Colors.red,
                //       width: 20,
                //       height: 20,
                //       child: const Center(
                //         child: Text(
                //           '8',
                //           style: TextStyle(
                //             color: Colors.white,
                //             fontSize: 12,
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GeneralSettings(),
                      ),
                    );
                  },
                ),
                ListTile(
                    title: const Text('Use Biometric'),
                    leading: const Icon(Icons.fingerprint),
                    trailing: Switch(
                      value: _useBiometrics,
                      onChanged: (value) {
                        if (_supportState == _SupportState.unknown ||
                            _supportState == _SupportState.unsupported) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Sorry! You cant use this feature because your device is not supported for Authentication ⚠️'),
                            ),
                          );
                        } else if (_supportState == _SupportState.supported) {
                          setState(() {
                            _useBiometrics = value;
                            if (_useBiometrics) {
                              _storage.write(
                                  key: 'useBiometrics', value: 'true');
                            } else {
                              _storage.write(
                                  key: 'useBiometrics', value: 'false');
                            }
                          });
                        }
                      },
                    )),
                const Divider(),
                ListTile(
                  title: const Text('Sign Out'),
                  leading: const Icon(Icons.logout_rounded),
                  onTap: () {
                    context.read<FirebaseAuthMethods>().signOut(context);
                  },
                ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
              title: const Text('Dark Mode'),
              leading: const Icon(Icons.dark_mode),
              trailing: Switch(
                value: themeProvider.isDark,
                onChanged: (value) {
                  setState(() {
                    themeProvider.toggleTheme();
                  });
                },
              )),
        ],
      ),
    );
  }
}

enum _SupportState {
  unknown,
  supported,
  unsupported,
}
