import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class FirebaseAuthMethods {
  final FirebaseAuth _auth;
  // final _auth = FirebaseAuth.instance;
  FirebaseAuthMethods(this._auth);

  final _storage = const FlutterSecureStorage();
  // FOR EVERY FUNCTION HERE
  // POP THE ROUTE USING: Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);

  // GET USER DATA
  // using null check operator since this method should be called only
  // when the user is logged in
  User get user => _auth.currentUser!;

  // STATE PERSISTENCE STREAM
  Stream<User?> authStream() => _auth.authStateChanges();
  // OTHER WAYS (depends on use case):
  // Stream get authState => FirebaseAuth.instance.userChanges();
  // Stream get authState => FirebaseAuth.instance.idTokenChanges();
  // KNOW MORE ABOUT THEM HERE: https://firebase.flutter.dev/docs/auth/start#auth-state

  // EMAIL SIGN UP
  Future<String> signUpWithEmail_Patient({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String role,
    required BuildContext context,
  }) async {
    String tempId = '123';
    String? savedEmail = await _storage.read(key: 'tempEmail');
    String? savedPassword = await _storage.read(key: 'tempPassword');
    // "C:\Users\zain\OneDrive\Desktop\Flutter\medease-1f1df-firebase-adminsdk-za2vw-77783a3e28.json"
    try {
      await _auth
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((value) async {
        await sendEmailVerification(context);
        tempId = value.user!.uid;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(value.user!.uid)
            .set({
          'uid': value.user!.uid,
          'firstName': firstName,
          'lastName': lastName,
          'email': value.user!.email,
          'role': role.toLowerCase(),
          'createdOn': DateFormat.yMMMMd()
              .format(value.user!.metadata.creationTime!)
              .toString(),
          'Address': 'Not Yet Added',
          'AllergiesAndMedication': 'Not Yet Added',
          'DOB': 'Not Yet Added',
          'EmergencyContact': 'Not Yet Added',
          'Info': 'Not Yet Added',
          'InsuranceID': 'Not Yet Added',
          'Medical_ID': 'Not Yet Added',
          'PreferedHealthCare': 'Not Yet Added',
          'contactNo': 'Not Yet Added',
          'isDeleted': 0,
          'gender': 'Not Yet Added'
        });
        if (context.mounted) {}
        await loginWithEmail(
          email: savedEmail!,
          password: savedPassword!,
          context: context,
        );
      });

      return tempId;
    } on FirebaseAuthException catch (e) {
      // if you want to display your own custom error message
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: e.message!,
        ),
      ); // Displaying the usual firebase error message
      return tempId;
    }
  }

  Future<String> signUpWithEmail_Doctor({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String role,
    required BuildContext context,
  }) async {
    String tempId = '123';
    String? savedEmail = await _storage.read(key: 'tempEmail');
    String? savedPassword = await _storage.read(key: 'tempPassword');
    // "C:\Users\zain\OneDrive\Desktop\Flutter\medease-1f1df-firebase-adminsdk-za2vw-77783a3e28.json"
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        await sendEmailVerification(context);
        tempId = value.user!.uid;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(value.user!.uid)
            .set({
          'uid': value.user!.uid,
          'role': role.toLowerCase(),
          'createdOn': DateFormat.yMMMMd()
              .format(value.user!.metadata.creationTime!)
              .toString(),
          'certification': "Not Yet Added",
          "educationTrainingID": 0,
          "degree": "Not Yet Added",
          "gender": "Not Yet Added",
          "clinic": "Not Yet Added",
          "firstName": firstName,
          "lastName": lastName,
          "experience": 0,
          "experties": "Not Yet Added",
          "contactNo": "Not Yet Added",
          "insuranceID": 0,
          "liabilityID": 0,
          "LicenseNo": "0",
          "publication": "Not Yet Added",
          "specialist": "Not Yet Added",
          "email": value.user!.email,
          "isDeleted": 0
        });
        if (context.mounted) {}
        await loginWithEmail(
          email: savedEmail!,
          password: savedPassword!,
          context: context,
        );
      });

      return tempId;
    } on FirebaseAuthException catch (e) {
      // if you want to display your own custom error message
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: e.message!,
        ),
      ); // Displaying the usual firebase error message
      return tempId;
    }
  }

  // EMAIL LOGIN
  Future<bool> loginWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    Future<bool> val = Future.value(false);
    try {
      await _auth
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((value) async {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(value.user!.uid)
            .get()
            .then((value) async {
          if (value.data()!['isDeleted'] == 1) {
            showTopSnackBar(
              Overlay.of(context),
              const CustomSnackBar.error(
                message: 'This account has been deleted by the admin',
              ),
            );
            await _auth.signOut();
            val = Future.value(false);
          } else if (!user.emailVerified) {
            if (context.mounted) {
              await sendEmailVerification(context);
            }
            await _auth.signOut();
            val = Future.value(false);
          } else {
            val = Future.value(true);
          }
        });
      });
    } on FirebaseAuthException catch (e) {
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: e.message!,
        ),
      ); // Displaying the error message
    }
    return val;
  }

  // EMAIL VERIFICATION
  Future<void> sendEmailVerification(BuildContext context) async {
    try {
      _auth.currentUser!.sendEmailVerification();
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.info(
          message:
              'Email verification sent! Please login to your Email and verify your account to continue.',
        ),
      );
      return;
    } on FirebaseAuthException catch (e) {
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: e.message!,
        ),
      ); // Display error message
    }
  }

  // SIGN OUT
  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: e.message!,
        ),
      ); // Displaying the error message
    }
  }

  //Forgot password
  Future<bool> resetPassword({
    required String email,
    required BuildContext context,
  }) async {
    Future<bool> val = Future.value(false);
    try {
      await _auth.sendPasswordResetEmail(email: email).then((value) {
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.info(
            message: 'Password reset email sent!',
          ),
        );
        val = Future.value(true);
        Navigator.of(context).pop();
      });
    } on FirebaseAuthException catch (e) {
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: e.message!,
        ),
      );
      val = Future.value(false); // Displaying the error message
    }
    return val;
  }

  // DELETE ACCOUNT
  Future<void> deleteAccount(BuildContext context) async {
    try {
      //Delete user data from firebase firestore first
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .delete()
          .then((value) {
        //Delete user from firebase authentication
        _auth.currentUser!.delete();
      });
    } on FirebaseAuthException catch (e) {
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: e.message!,
        ),
      ); // Displaying the error message
      // if an error of requires-recent-login is thrown, make sure to log
      // in user again and then delete account.
    }
  }

  // UPDATE EMAIL
  Future<void> updateEmail({
    required String email,
    required BuildContext context,
  }) async {
    try {
      await _auth.currentUser!.updateEmail(email).then((value) {
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.success(
            message: 'Email updated successfully!',
          ),
        );
        _auth.currentUser!.sendEmailVerification();
        FirebaseFirestore.instance
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .update({'email': email}).then((value) {
          _auth.signOut();
        });
      });
    } on FirebaseAuthException catch (e) {
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: e.message!,
        ),
      ); // Displaying the error message
    }
  }

  // UPDATE PASSWORD
  Future<void> updatePassword({
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _auth.currentUser!.updatePassword(password).then((value) {
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.success(
            message:
                'Password updated successfully! Please login again to your account to continue.',
          ),
        );
        _auth.signOut();
      });
    } on FirebaseAuthException catch (e) {
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: e.message!,
        ),
      ); // Displaying the error message
    }
  }
}
