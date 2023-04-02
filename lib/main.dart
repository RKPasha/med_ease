import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:med_ease/firebase_options.dart';
import 'package:med_ease/pages/Admin/Admin_Home.dart';
import 'package:med_ease/pages/Doctor/Doctor_Home.dart';
import 'package:med_ease/pages/Patient/Patient_Home.dart';
import 'package:med_ease/pages/forgot_password_screen.dart';
import 'package:med_ease/pages/login_screen.dart';
import 'package:med_ease/pages/splash_screen.dart';
import 'package:med_ease/services/firebase_auth_methods.dart';
import 'package:med_ease/utils/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // final ThemeProvider themeProvider = ThemeProvider();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MultiProvider(
            providers: [
              Provider<FirebaseAuthMethods>(
                create: (_) => FirebaseAuthMethods(FirebaseAuth.instance),
              ),
              StreamProvider(
                create: (context) =>
                    context.read<FirebaseAuthMethods>().authStream(),
                initialData: null,
              ),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              home: const AuthWrapper(),
              theme: ThemeData(
                // colorScheme: ThemeData().colorScheme.copyWith(primary: Colors.blue),
                brightness:
                    themeProvider.isDark ? Brightness.dark : Brightness.light,
              ),
              routes: {
                LoginScreen.routeName: (context) => const LoginScreen(),
                ForgotPasswordScreen.routeName: (context) =>
                    const ForgotPasswordScreen(),
                SplashScreen.routeName: (context) => const SplashScreen(),
              },
            ),
          );
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: context.read<FirebaseAuthMethods>().authStream(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            User? user = snapshot.data;
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user!.uid)
                  .get(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> documentSnapshot) {
                if (documentSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!documentSnapshot.hasData ||
                    !documentSnapshot.data!.exists) {
                  return const Center(child: CircularProgressIndicator());
                }
                String role = documentSnapshot.data!.get('role');
                if (role == "admin") {
                  return Admin_Home(user: user);
                } else if (role == "doctor") {
                  return Doctor_Home(user: user);
                } else if (role == "patient") {
                  return Patient_Home(user: user);
                } else {
                  return const SplashScreen();
                }
              },
            );
          } else {
            // user is not authenticated, navigate to login screen
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacementNamed(context, '/splash');
            });
            return const SizedBox.shrink();
          }
        }),
      ),
    );
  }
}
