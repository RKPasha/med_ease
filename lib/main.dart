import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:med_ease/firebase_options.dart';
import 'package:med_ease/pages/home_page.dart';
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
                // SignupOptions.routeName: (context) => const SignupOptions(),
                // SignupScreen.routeName: (context) => const SignupScreen(),
                // LoginScreen.routeName: (context) => const LoginScreen(),
                // ForgotPasswordScreen.routeName: (context) =>
                //     const ForgotPasswordScreen(),
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
          if (snapshot.hasData) {
            return HomePage(user: snapshot.data as User);
          } else {
            return const SplashScreen();
          }
        }),
      ),
    );
  }
}
