//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kwiatuszki_dev/constants/routes.dart';
import 'package:kwiatuszki_dev/Views/login_view.dart';
import 'package:kwiatuszki_dev/services/login_view_service.dart';

class LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  final LoginViewService loginViewService = LoginViewService();

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Column(children: [
        TextField(
          autocorrect: false,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(hintText: 'email'),
          controller: _email,
        ),
        TextField(
          obscureText: true,
          enableSuggestions: false,
          autocorrect: false,
          decoration: const InputDecoration(hintText: 'password'),
          controller: _password,
        ),
        // Text(
        //   _errorMessage.text,
        //   style: const TextStyle(color: Colors.red),
        // ),
        TextButton(
          onPressed: () {
            loginViewService.logInWithFirebase(
              _email.text,
              _password.text,
              mounted,
              context,
            );
          },
          child: const Text('Login'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
              registerRoute,
              (route) => false,
            );
          },
          child: const Text('Not registered yet? Create an account'),
        )
      ]),
    );
  }
}