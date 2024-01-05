import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/material.dart';

@immutable
class AuthUser {
  final String? uid;
  final String? email;
  final bool isEmailVerified;
  
  const AuthUser(this.isEmailVerified, this.email, this.uid);

  factory AuthUser.fromFirebase(User user) => AuthUser(
        user.emailVerified,
        user.email,
        user.uid,
      );
}
