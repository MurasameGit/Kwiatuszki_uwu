import 'package:flutter/material.dart';
import 'package:kwiatuszki_dev/constants/routes.dart';
import 'package:kwiatuszki_dev/Views/login_view.dart';
import 'package:kwiatuszki_dev/constants/strings.dart';
import 'package:kwiatuszki_dev/services/auth/auth_exceptions.dart';
import 'package:kwiatuszki_dev/services/auth/auth_service.dart';
import 'package:kwiatuszki_dev/utilities/error_handling.dart';
//import 'package:kwiatuszki_dev/services/login_view_service.dart';

class LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

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
          onPressed: () async {
            final email = _email.text;
            final password = _password.text;
            try {
              await AuthService.firebase().logIn(
                email: email,
                password: password,
              );
            } on WrongPasswordAuthException {
              await showErrorDialog(context, wrongPasswordErrorMessage);
            } on UserNotFoundAuthException {
              await showErrorDialog(context, userNotFoundErrorMessage);
            } on GenericAuthException {
              await showErrorDialog(context, genericAuthExceptionMessage);
            } catch (_) {
              await showErrorDialog(context, genericAuthExceptionMessage);
            }

            final user = AuthService.firebase().currentUser;
            if (user?.isEmailVerified ?? false) {
              if (!context.mounted) return;
              Navigator.of(context).pushNamedAndRemoveUntil(
                mainUIRoute,
                (route) => false,
              );
            } else {
              if (!context.mounted) return;
              Navigator.of(context).pushNamedAndRemoveUntil(
                verifyEmailRoute,
                (route) => false,
              );
            }
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
