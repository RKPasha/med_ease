import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:med_ease/services/firebase_auth_methods.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';

class ChangeEmail extends StatefulWidget {
  const ChangeEmail({super.key});

  @override
  State<ChangeEmail> createState() => _ChangeEmailState();
}

class _ChangeEmailState extends State<ChangeEmail> {
  final _storage = const FlutterSecureStorage();
  final oldEmail = TextEditingController();
  final email = TextEditingController();
  final confirmEmail = TextEditingController();
  final password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String old = '';
  String oldPass = '';

  @override
  void dispose() {
    oldEmail.dispose();
    email.dispose();
    confirmEmail.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _storage.read(key: 'tempEmail').then((value) {
      oldEmail.text = value!;
      old = value;
    });
    _storage.read(key: 'tempPassword').then((value) {
      oldPass = value!;
    });
    super.initState();
  }

  String? emailValidaror(String? value) {
    if (value == null || value.isEmpty || !isEmail(value.trim())) {
      return 'Please enter valid email';
    } else if (value == old) {
      return 'New Email cannot be same as old Email';
    }
    return null;
  }

  _changeEmail() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });
    await context
        .read<FirebaseAuthMethods>()
        .updateEmail(email: email.text, context: context)
        .then((value) {
      Navigator.of(context).pop();
    });
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
        title: const Text('Change Email'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Form(
          key: _formKey,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width,
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Column(children: [
              Expanded(
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: oldEmail,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(5),
                          labelText: 'Old Email',
                          prefixIcon: const Icon(
                            Icons.email_outlined,
                            color: Colors.blue,
                            size: 20,
                          ),
                          hintStyle: const TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        enabled: false,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: email,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(5),
                          labelText: 'Email',
                          prefixIcon: const Icon(
                            Icons.email_outlined,
                            color: Colors.blue,
                            size: 20,
                          ),
                          hintStyle: const TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        validator: emailValidaror,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: confirmEmail,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(5),
                          labelText: 'Confirm Email',
                          prefixIcon: const Icon(
                            Icons.email_outlined,
                            color: Colors.blue,
                            size: 20,
                          ),
                          hintStyle: const TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value != email.text) {
                            return 'Email does not match';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Processing Data'),
                              ),
                            );
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Confirm Email Changing'),
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
                                        'Change Email',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      onPressed: () {
                                        if (password.text == oldPass) {
                                          Navigator.of(context).pop();
                                          showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (context) => const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          );
                                          _changeEmail();
                                          Navigator.of(context).pop();
                                        } else {
                                          Navigator.of(context).pop();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content:
                                                    Text('Incorrect Password')),
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text(
                          'Change Email',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
