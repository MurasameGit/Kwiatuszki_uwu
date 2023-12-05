import 'package:kwiatuszki_dev/services/auth/auth_user.dart';

//interface

abstract class AuthProvider {

  Future<void> initialize();
  AuthUser? get currentUser;
  Future<AuthUser> logIn({
      required String email,
      required String password,
    });

  Future<AuthUser> createUser({
      required String email,
      required String password,
    });

  Future<void> logOut(); 
  Future<void> sendEmailVerification();  
}