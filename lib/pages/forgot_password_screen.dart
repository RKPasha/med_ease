import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:med_ease/pages/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';

import '../services/firebase_auth_methods.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static String routeName = '/forgot_password';
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();

  Future<bool> resetPassword() async {
    bool val = await context.read<FirebaseAuthMethods>().resetPassword(
          email: emailController.text,
          context: context,
        );
    debugPrint('val: ${val.toString()}');
    return val;
  }

  final _formKey = GlobalKey<FormState>();
  bool showLoader = false;

  @override
  void dispose() {
    emailController.clear();
    super.dispose();
  }

  String? emailValidator(String? value) {
    if (!isEmail(value!)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Scaffold(
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                // const SizedBox(height: 20),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      // alignment: Alignment.topLeft,
                      margin: const EdgeInsets.only(top: 35, left: 10),
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.circular(100)
                          //more than 50% of width makes circle
                          ),
                      child: const Icon(
                        Icons.lock,
                        color: Colors.blue,
                        size: 20,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 35, left: 10),
                      child: Text(
                        'Forgot Password?',
                        style: GoogleFonts.robotoSlab(
                          textStyle: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      margin: const EdgeInsets.only(top: 35),
                      child: IconButton(
                        onPressed: () {
                          // Navigator.of(context).pop();
                          // Navigator.of(context).pushNamedAndRemoveUntil(
                          //     '/', (Route<dynamic> route) => false);
                          // navigate back to login screen and also change the url
                          Navigator.of(context)
                              .popAndPushNamed(LoginScreen.routeName);
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(left: 10, right: 50),
                    child: const Text(
                      'Enter your email that you used to register your account, so we can send you a link to reset your password',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    )),
                const SizedBox(height: 15),
                Container(
                  height: 70,
                  margin: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: emailController,
                    validator: emailValidator,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      prefixIcon: const Icon(Icons.email),
                      labelText: 'Email',
                      hintText: "your-email@domain.com",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)
                          //more than 50% of width makes circle
                          ),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    // ignore: sort_child_properties_last
                    child: showLoader
                        ? const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : const Text('Send Link',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            )),
                    onPressed: showLoader
                        ? null
                        : () {
                            debugPrint('Send Link button pressed');
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              setState(() {
                                showLoader = true;
                              });
                              resetPassword().then((value) {
                                if (value) {
                                  setState(() {
                                    showLoader = true;
                                  });
                                } else {
                                  setState(() {
                                    showLoader = false;
                                  });
                                }
                              });
                              // use the email provided here
                            }
                          },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
