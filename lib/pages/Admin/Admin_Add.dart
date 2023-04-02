import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:med_ease/pages/Admin/Admin_Home.dart';
import 'package:med_ease/services/firebase_auth_methods.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';

import '../../utils/constants.dart';
import '../../utils/widgets_function.dart';

class Admin_Add extends StatefulWidget {
  final String add;
  final User user;
  const Admin_Add({super.key, required this.add, required this.user});

  @override
  State<Admin_Add> createState() => _Admin_AddState();
}

class _Admin_AddState extends State<Admin_Add> {
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  //User? user = FirebaseAuth.instance.currentUser;

  late bool inserted;

  @override
  void dispose() {
    firstName.dispose();
    lastName.dispose();
    email.dispose();
    password.dispose();
    confirmPassword.dispose();
    super.dispose();
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
    }
    return null;
  }

  bool isValidName(String value) {
    return RegExp(r'^[a-zA-Z ]+$').hasMatch(value);
  }

  Future<void> addPatient() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });
    if (widget.add == 'Patient') {
      await context
          .read<FirebaseAuthMethods>()
          .signUpWithEmail_Patient(
            email: email.text.trim(),
            password: password.text,
            firstName: firstName.text.trim(),
            lastName: lastName.text.trim(),
            role: widget.add,
            context: context,
          )
          .then((value) {
        if (value != '123') {
          inserted = true;
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${widget.add} Added Successfully!')));
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Admin_Home(user: widget.user)),
          );
        } else {
          inserted = false;
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${widget.add} failed to add!')));
        }
      });
    }
  }

  Future<void> addDoctor() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });

    await context
        .read<FirebaseAuthMethods>()
        .signUpWithEmail_Doctor(
          email: email.text.trim(),
          password: password.text,
          firstName: firstName.text.trim(),
          lastName: lastName.text.trim(),
          role: widget.add,
          context: context,
        )
        .then((value) {
      if (value != '123') {
        inserted = true;
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${widget.add} Added Successfully!')));
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  Admin_Home(user: FirebaseAuth.instance.currentUser!)),
        );
      } else {
        inserted = false;
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${widget.add} failed to add!')));
      }
    });
  }

  Future<bool?> _onBackPressed() async {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Admin_Home(
                user: widget.user,
              )),
    );
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool? result = await _onBackPressed();
        result ??= false;
        return result;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            backgroundColor: Colors.blue,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Admin_Home(
                            user: widget.user,
                          )),
                );
              },
            ),
            centerTitle: true,
            title: const SizedBox(
                height: 100,
                width: 120,
                child: Image(
                  image: AssetImage('assets/images/logo_white.png'),
                  fit: BoxFit.contain,
                ))),
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Form(
            key: _formKey,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width,
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: Column(
                children: <Widget>[
                  addVerticalSpace(30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Add ${widget.add}',
                        style: const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  addVerticalSpace(50),
                  Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Fill the following feilds.',
                          style: TextStyle(fontSize: 16),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            firstName.text = '';
                            lastName.text = '';
                            email.text = '';
                            password.text = '';
                            confirmPassword.text = '';
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Form Cleared!')));
                          },
                          icon: const Icon(
                            Icons.clear,
                            size: 15,
                          ),
                          label: const Text(
                            'Clear',
                            style: TextStyle(fontSize: 12),
                          ),
                        )
                      ],
                    ),
                  ),
                  addVerticalSpace(20),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TextFormField(
                              controller: firstName,
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    !isValidName(value.trim())) {
                                  return 'Please enter valid first name';
                                }
                                return null;
                              },
                              style: const TextStyle(fontSize: 14),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(5),
                                labelText: 'First Name',
                                prefixIcon: const Icon(
                                  Icons.person,
                                  color: Colors.blue,
                                  size: 20,
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ],
                        ),
                        addVerticalSpace(10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TextFormField(
                              controller: lastName,
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    !isValidName(value.trim())) {
                                  return 'Please enter valid second name';
                                }
                                return null;
                              },
                              style: const TextStyle(fontSize: 14),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(5),
                                labelText: 'Last Name',
                                prefixIcon: const Icon(
                                  Icons.person,
                                  color: Colors.blue,
                                  size: 20,
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ],
                        ),
                        addVerticalSpace(10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TextFormField(
                              controller: email,
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    !isEmail(value.trim())) {
                                  return 'Please enter valid email';
                                }
                                return null;
                              },
                              style: const TextStyle(fontSize: 14),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(5),
                                labelText: 'Email',
                                prefixIcon: const Icon(
                                  Icons.email_outlined,
                                  color: Colors.blue,
                                  size: 20,
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ],
                        ),
                        addVerticalSpace(10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TextFormField(
                              controller: password,
                              validator: passwordValidator,
                              obscureText: true,
                              style: const TextStyle(fontSize: 14),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(5),
                                labelText: 'Password',
                                prefixIcon: const Icon(
                                  Icons.password_outlined,
                                  color: Colors.blue,
                                  size: 20,
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ],
                        ),
                        addVerticalSpace(10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TextFormField(
                              obscureText: true,
                              controller: confirmPassword,
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value != password.text) {
                                  return 'Password does not match';
                                }
                                return null;
                              },
                              style: const TextStyle(fontSize: 14),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(5),
                                labelText: 'Confirm Password',
                                prefixIcon: const Icon(
                                  Icons.password_outlined,
                                  color: Colors.blue,
                                  size: 20,
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ],
                        ),
                        addVerticalSpace(20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  fixedSize: const Size(100, 30),
                                  backgroundColor: Colors.blue,
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text('Processing Data')));
                                    if (widget.add == "Doctor") {
                                      await addDoctor();
                                    } else {
                                      await addPatient();
                                    }
                                  }
                                },
                                icon: const Icon(
                                  Icons.save,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                label: Text(
                                  'Save',
                                  style: TEXT_THEME_DEFAULT.bodyLarge,
                                )),
                            addHorizontalSpace(20),
                            OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  fixedSize: const Size(100, 30),
                                  backgroundColor: Colors.blue,
                                ),
                                onPressed: () {
                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      title: const Text('Go Back?'),
                                      content: const Text(
                                          'Are Your sure you want to go back?'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, 'Cancel'),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Admin_Home(
                                                user: widget.user,
                                              ),
                                            ),
                                          ),
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.exit_to_app_outlined,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                label: Text(
                                  'Back',
                                  style: TEXT_THEME_DEFAULT.bodyText1,
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
