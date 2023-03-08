import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:med_ease/services/firebase_auth_methods.dart';
import 'package:med_ease/utils/theme_provider.dart';
import 'package:provider/provider.dart';

class AdminSideNav extends StatefulWidget {
  final User user;
  // final UsersModel usersModel;
  const AdminSideNav({super.key, required this.user});

  @override
  State<AdminSideNav> createState() => _AdminSideNavState();
}

class _AdminSideNavState extends State<AdminSideNav> {
  ThemeProvider themeProvider = ThemeProvider();
  final _storage = const FlutterSecureStorage();
  _SupportState _supportState = _SupportState.unknown;
  final LocalAuthentication _auth = LocalAuthentication();
  bool _useBiometrics = true;

  @override
  void initState() {
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
                  accountName: const Text(
                    'Admin',
                    style: TextStyle(color: Colors.black),
                  ),
                  accountEmail: Text(
                    widget.user.email!,
                    style: const TextStyle(color: Colors.black),
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage('assets/images/sidenav_logo.png')),
                  ),
                ),
                ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('Doctors'),
                    onTap: () {}),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Patients'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.file_copy_rounded),
                  title: const Text('Reports'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.notifications),
                  title: const Text('Notifications'),
                  trailing: ClipOval(
                    child: Container(
                      color: Colors.red,
                      width: 20,
                      height: 20,
                      child: const Center(
                        child: Text(
                          '8',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  onTap: () async {
                    // await Navigator.of(context)
                    //     .push(
                    //   MaterialPageRoute(
                    //     builder: (context) => ProfilePage(
                    //         user: widget.user, usersModel: widget.usersModel),
                    //   ),
                    // )
                    //     .then((value) {
                    //   setState(() {
                    //     _fetchImageUrlFromDatabase();
                    //   });
                    // });
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.manage_accounts_rounded),
                  title: const Text('Manage Accounts'),
                  onTap: () {
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => const ManageAccounts(),
                    //   ),
                    // );
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
                ListTile(
                  leading: const Icon(Icons.delete_forever),
                  title: const Text('Delete Account'),
                  onTap: () {
                    //show alert dialog to confirm account deletion
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Row(
                          children: const [
                            Icon(
                              Icons.warning_amber_rounded,
                              color: Colors.red,
                            ),
                            Text('  Delete Account'),
                          ],
                        ),
                        content: const Text(
                            'Are you sure you want to delete your account?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.of(context).pop();
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                              // await context
                              //     .read<FirebaseAuthMethods>()
                              //     .deleteAccount(context);
                            },
                            child: const Text(
                              'Delete',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
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
