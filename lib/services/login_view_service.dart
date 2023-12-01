import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kwiatuszki_dev/constants/routes.dart';
import 'package:kwiatuszki_dev/services/error_handling.dart';

class LoginViewService extends ErrorHandler {
  Future logInWithFirebase(String email, String password, bool isMounted,
      BuildContext context) async {
    try {
      final userCredentials =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print(userCredentials);
      if (!isMounted) return;
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, mainUIRoute);
    } on FirebaseAuthException catch (e) {
      if(!context.mounted) return;
      showErrorDialog(context, e.code);
    }
  }
}