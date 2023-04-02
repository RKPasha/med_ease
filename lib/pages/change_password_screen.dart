import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:med_ease/services/firebase_auth_methods.dart';
import 'package:provider/provider.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _storage = const FlutterSecureStorage();
  final oldPassword = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String old = '';

  @override
  void dispose() {
    oldPassword.dispose();
    password.dispose();
    confirmPassword.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _storage.read(key: 'tempPassword').then((value) {
      old = value!;
    });
    super.initState();
  }

  String? passwordValidator(String? value) {
    if (value!.length < 8) {
      return 'Password must be at least 8 characters';
    } else if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain a lowercase letter';
    } else if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain a number';
    } else if (!value.contains(RegExp(r'[!@#\$%\^&\*?_~|]'))) {
      return 'Password must contain a special character';
    } else if (value == old) {
      return 'Password cannot be same as old password';
    }
    return null;
  }

  String? oldPasswordChecker(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your old password';
    } else if (value != old) {
      return 'Old password is incorrect';
    }

    return null;
  }

  _changePassword() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });
    await context
        .read<FirebaseAuthMethods>()
        .updatePassword(password: password.text, context: context)
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
        title: const Text('Change Password'),
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
                        controller: oldPassword,
                        obscureText: true,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(5),
                          labelText: 'Old Password',
                          prefixIcon: const Icon(
                            Icons.password_outlined,
                            color: Colors.blue,
                            size: 20,
                          ),
                          hintStyle: const TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        validator: oldPasswordChecker,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: password,
                        obscureText: true,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(5),
                          labelText: 'New Password',
                          prefixIcon: const Icon(
                            Icons.password_outlined,
                            color: Colors.blue,
                            size: 20,
                          ),
                          hintStyle: const TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        validator: passwordValidator,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(5),
                          labelText: 'Confirm Password',
                          prefixIcon: const Icon(
                            Icons.password_outlined,
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
                              value != password.text) {
                            return 'Password does not match';
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
                            _changePassword();
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
                          'Change Password',
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
