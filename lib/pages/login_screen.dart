import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';
import 'package:med_ease/pages/forgot_password_screen.dart';
import 'package:med_ease/utils/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:validators/validators.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/firebase_auth_methods.dart';

class LoginScreen extends StatefulWidget {
  static String routeName = '/login';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool rememberMe = false;
  bool isEmailCorrect = false;
  bool _hidePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  final _storage = const FlutterSecureStorage();
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
    super.initState();
  }

  ThemeProvider themeProvider = ThemeProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(5.0, 0, 5.0, 8.0),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: themeProvider.isDark
                      ? Image.asset(
                          'assets/images/logo_white.png',
                          width: MediaQuery.of(context).size.height * 0.4,
                          height: MediaQuery.of(context).size.height * 0.4,
                        )
                      : Image.asset(
                          'assets/images/logo.png',
                          width: MediaQuery.of(context).size.height * 0.4,
                          height: MediaQuery.of(context).size.height * 0.4,
                        ),
                ),
                Center(
                  child: Text(
                    'Login to Your Account',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.robotoSlab(
                      textStyle: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  height: 70,
                  margin: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: emailController,
                    onChanged: (val) {
                      setState(() {
                        isEmailCorrect = isEmail(val);
                      });
                    },
                    onTap: () {
                      showTopSnackBar(
                        Overlay.of(context),
                        const CustomSnackBar.info(
                          message:
                              'Info: Login button will appear when you enter a valid Email',
                        ),
                      );
                    },
                    decoration: InputDecoration(
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
                  height: 70,
                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Stack(
                    alignment: Alignment.centerRight,
                    children: <Widget>[
                      TextFormField(
                        obscureText: _hidePassword,
                        controller: passwordController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              // Based on passwordVisible state choose the icon
                              _hidePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              // Update the state i.e. toogle the state of passwordVisible variable
                              setState(() {
                                _hidePassword = !_hidePassword;
                              });
                            },
                          ),
                          labelText: "Password",
                          hintText: '***********',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Password is required";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: [
                        Checkbox(
                          value: rememberMe,
                          onChanged: (value) {
                            setState(() {
                              rememberMe = value!;
                            });
                          },
                        ),
                        const Text('Remember me'),
                      ],
                    ),
                    const SizedBox(width: 20),
                  ],
                ),
                isEmailCorrect
                    ? Container(
                        margin: const EdgeInsets.all(10.0),
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            _loginUser();
                          }, //loginUser
                          child: const Text('Login',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16)),
                        ),
                      )
                    : Container(),
                const SizedBox(height: 20),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Already logged in?',
                    style: TextStyle(
                        color:
                            themeProvider.isDark ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    OutlinedButton(
                      onPressed: () {
                        _loginSavedUser();
                      }, //loginSavedUser,
                      child: Padding(
                        padding: const EdgeInsets.all(8.1),
                        child: Row(
                          children: const [
                            Icon(
                              Icons.save_rounded,
                              size: 35,
                            ),
                            SizedBox(width: 10),
                            Icon(
                              Icons.fingerprint,
                              size: 35,
                            ),
                            SizedBox(width: 10),
                            Icon(
                              Icons.face_6,
                              size: 35,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                          context, ForgotPasswordScreen.routeName);
                    },
                    child: Text(
                      'Forgot the password?',
                      style: TextStyle(
                        color:
                            themeProvider.isDark ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _authenticateWithBiometrics() async {
    bool authenticated = false;
    late List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await _auth.getAvailableBiometrics();
      debugPrint(availableBiometrics.toString());
      if (availableBiometrics.contains(BiometricType.strong) ||
          availableBiometrics.contains(BiometricType.face) ||
          availableBiometrics.contains(BiometricType.fingerprint)) {
        authenticated = await _auth.authenticate(
          localizedReason: 'Scan your fingerprint (or face) to authenticate',
          options: const AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: true,
          ),
        );
      } else {
        if (mounted) {}
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.error(
            message:
                'Please enroll fingerprint/face authentication to access the app',
          ),
        );
      }
    } on PlatformException catch (e) {
      debugPrint(e.message);
    }
    if (!mounted) {
      return Future.value(authenticated);
    }
    return Future.value(authenticated);
  }

  _loginUser() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });
    bool val = await context.read<FirebaseAuthMethods>().loginWithEmail(
          email: emailController.text.trim(),
          password: passwordController.text,
          context: context,
        );
    if (!mounted) return;
    if (val) {
      await _storage.write(
          key: 'tempEmail', value: emailController.text.trim());
      await _storage.write(key: 'tempPassword', value: passwordController.text);
      if (rememberMe) {
        await _storage.write(key: 'email', value: emailController.text.trim());
        await _storage.write(key: 'password', value: passwordController.text);
      }
      if (_useBiometrics) {
        bool val2 = await _authenticateWithBiometrics();
        if (val2) {
          if (!mounted) return;
          Navigator.of(context).pop();
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
        } else {
          if (!mounted) return;
          Navigator.of(context).pop();
          if (!mounted) return;
          showTopSnackBar(
            Overlay.of(context),
            const CustomSnackBar.error(
              message: 'User not Authenticated',
            ),
          );
          context.read<FirebaseAuthMethods>().signOut(context);
        }
      } else {
        if (!mounted) return;
        Navigator.of(context).pop();
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
      }
    } else {
      if (!mounted) return;
      Navigator.of(context).pop();
    }
  }

  _loginSavedUser() async {
    String? savedEmail = await _storage.read(key: 'email');
    String? savedPassword = await _storage.read(key: 'password');
    if (savedEmail != null && savedPassword != null) {
      if (!mounted) return;
      showDialog(
          context: context,
          builder: (context) {
            return const Center(child: CircularProgressIndicator());
          });
      bool val = await context.read<FirebaseAuthMethods>().loginWithEmail(
            email: savedEmail,
            password: savedPassword,
            context: context,
          );
      if (!mounted) return;
      if (!val) {
        Navigator.of(context).pop();
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.error(
            message: 'Not Authenticated',
          ),
        );
      } else if (_useBiometrics) {
        bool val2 = await _authenticateWithBiometrics();
        if (val2) {
          if (!mounted) return;
          Navigator.of(context).pop();
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
        } else {
          if (!mounted) return;
          Navigator.of(context).pop();
          if (!mounted) return;
          context.read<FirebaseAuthMethods>().signOut(context);
        }
      } else {
        if (!mounted) return;
        Navigator.of(context).pop();
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
      }
    } else {
      if (!mounted) return;
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.error(
          message: 'No Saved User',
        ),
      );
    }
  }
}
