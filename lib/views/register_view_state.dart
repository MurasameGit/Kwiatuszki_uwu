import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kwiatuszki_dev/Views/register_view.dart';
import 'package:kwiatuszki_dev/constants/routes.dart';
import 'package:kwiatuszki_dev/constants/strings.dart';
import 'package:kwiatuszki_dev/services/error_handling.dart';

class RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _passwordRepeated;
  final ErrorHandler _errorHandler = ErrorHandler();

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _passwordRepeated = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _passwordRepeated.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(registerText)),
      body: Column(children: [
        TextField(
          autocorrect: false,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(hintText: emailText),
          controller: _email,
        ),
        TextField(
          obscureText: true,
          enableSuggestions: false,
          autocorrect: false,
          decoration: const InputDecoration(hintText: passwordHintText),
          controller: _password,
        ),
        TextField(
          obscureText: true,
          enableSuggestions: false,
          autocorrect: false,
          decoration: const InputDecoration(hintText: repeatYourPasswordHint),
          controller: _passwordRepeated,
        ),
        TextButton(
          onPressed: () async {
            if (_password == _passwordRepeated) {
              try {
                await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: _email.text,
                  password: _password.text,
                );
              } on FirebaseAuthException catch (e) {
                if(!context.mounted) return;
                _errorHandler.showErrorDialog(context, e.code);
              }
            } else {
              _errorHandler.showErrorDialog(context, 'Passwords are different');
            }
          },
          child: const Text(registerText),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
              loginRoute,
              (route) => false,
            );
          },
          child: const Text(logInInsteadText),
        )
      ]),
    );
  }

  registrationMethod(String email, String password, String passwordRepeated) {}
}