import 'package:flutter/material.dart';
import 'package:kwiatuszki_dev/constants/routes.dart';
import 'package:kwiatuszki_dev/services/auth/auth_exceptions.dart';
import 'package:kwiatuszki_dev/services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify your Email'),
      ),
      body: Center(
        child: Column(
          children: [
            const Text(
                'Please verify your email and then restart application to continue'),
            TextButton(
                onPressed: () async {
                  try {
                    await AuthService.firebase().sendEmailVerification();
                  } on UserNotLoggedInAuthException {
                    if (!context.mounted) return;
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                      (route) => false,
                    );
                  }
                },
                child: const Text('Send verification email'))
          ],
        ),
      ),
    );
  }
}
