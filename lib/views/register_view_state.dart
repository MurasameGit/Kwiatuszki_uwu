import 'package:flutter/material.dart';
import 'package:kwiatuszki_dev/Views/register_view.dart';
import 'package:kwiatuszki_dev/constants/routes.dart';
import 'package:kwiatuszki_dev/constants/strings.dart';
import 'package:kwiatuszki_dev/services/auth/auth_exceptions.dart';
import 'package:kwiatuszki_dev/services/auth/auth_service.dart';
import 'package:kwiatuszki_dev/utilities/error_handling.dart';

class RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _passwordRepeated;

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
            registerUser(_email.text, _password.text, _passwordRepeated.text);
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


  registerUser(String email, String password, String passwordRepeated) async {
    if (password == passwordRepeated) {
              try {
                await AuthService.firebase().createUser(
                  email: email,
                  password: password,
                );
              } on InvalidEmailAuthException {
                if (!context.mounted) return;
                showErrorDialog(context, invalidEmailErrorMessage);
              } on WeakPasswordAuthException {
                if (!context.mounted) return;
                showErrorDialog(context, weakPasswordErrorMessage);
              } catch (_) {
                if (!context.mounted) return;
                showErrorDialog(context, genericAuthExceptionMessage);
              }
            } else {
              showErrorDialog(context, 'Passwords are different');
            }}
}
