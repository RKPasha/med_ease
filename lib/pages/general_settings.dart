import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:med_ease/pages/change_email_screen.dart';
import 'package:med_ease/pages/change_password_screen.dart';
import 'package:med_ease/services/firebase_auth_methods.dart';
import 'package:provider/provider.dart';

class GeneralSettings extends StatefulWidget {
  const GeneralSettings({super.key});

  @override
  State<GeneralSettings> createState() => _GeneralSettingsState();
}

class _GeneralSettingsState extends State<GeneralSettings> {
  final _storage = const FlutterSecureStorage();
  final password = TextEditingController();
  String old = '';

  @override
  void dispose() {
    password.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _storage.read(key: 'tempPassword').then((value) {
      old = value!;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Column(children: [
          Expanded(
              child: ListView(
            children: [
              ListTile(
                leading: const Icon(Icons.email),
                title: const Text('Change Email'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChangeEmail(),
                    ),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.lock),
                title: const Text('Change Password'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChangePassword(),
                    ),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.delete_forever),
                title: const Text('Delete Account'),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Confirm Account Deletion'),
                        content: TextFormField(
                          obscureText: true,
                          controller: password,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                          ),
                        ),
                        actions: [
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text(
                              'Delete Account',
                              style: TextStyle(color: Colors.red),
                            ),
                            onPressed: () async {
                              if (password.text == old) {
                                Navigator.of(context).pop();
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                                await context
                                    .read<FirebaseAuthMethods>()
                                    .deleteAccount(context)
                                    .then((value) {
                                  Navigator.of(context).pop();
                                });
                              } else {
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Incorrect Password')),
                                );
                              }
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              const Divider()
            ],
          ))
        ]),
      ),
    );
  }
}
