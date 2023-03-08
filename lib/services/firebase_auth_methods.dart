import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class FirebaseAuthMethods {
  final FirebaseAuth _auth;
  // final _auth = FirebaseAuth.instance;
  FirebaseAuthMethods(this._auth);

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
  Future<String> signUpWithEmail({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String role,
    required BuildContext context,
  }) async {
    String tempId = '123';
    // "C:\Users\zain\OneDrive\Desktop\Flutter\medease-1f1df-firebase-adminsdk-za2vw-77783a3e28.json"
    try {
      await _auth
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((value) {
        FirebaseFirestore.instance
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
        });
        tempId = value.user!.uid;
      });
      if (context.mounted) {
        await sendEmailVerification(context);
      }
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
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (!user.emailVerified) {
        if (context.mounted) {
          await sendEmailVerification(context);
        }
        await _auth.signOut();
        val = Future.value(false);
        // restrict access to certain things using provider
        // transition to another page instead of home screen
      } else {
        val = Future.value(true);
      }
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
  // Future<void> deleteAccount(BuildContext context) async {
  //   try {
  //     //Delete user data from firebase storage first
  //     final dbRef = FirebaseDatabase.instance.ref();
  //     final user = dbRef.child('users/${_auth.currentUser!.uid}');
  //     final snapshot = await user.get();
  //     if (snapshot.exists) {
  //       await user.remove();
  //     }
  //     final stRef = FirebaseStorage.instance.ref();
  //     if (_auth.currentUser!.photoURL == null) {
  //       final userSt =
  //           stRef.child('user_avatars/${_auth.currentUser!.uid}.jpeg');
  //       final snapshotSt = await userSt.getDownloadURL();
  //       if (snapshotSt.isNotEmpty) {
  //         await userSt.delete();
  //       }
  //     }
  //     await _auth.currentUser!.delete();
  //   } on FirebaseAuthException catch (e) {
  //     showTopSnackBar(
  //       Overlay.of(context),
  //       CustomSnackBar.error(
  //         message: e.message!,
  //       ),
  //     ); // Displaying the error message
  //     // if an error of requires-recent-login is thrown, make sure to log
  //     // in user again and then delete account.
  //   }
  // }
}
