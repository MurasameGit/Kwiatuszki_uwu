import 'package:flutter/material.dart';
import 'package:kwiatuszki_dev/Views/login_view.dart';
import 'package:kwiatuszki_dev/Views/register_view.dart';
import 'package:kwiatuszki_dev/constants/routes.dart';
import 'package:kwiatuszki_dev/services/auth/auth_service.dart';
import 'Views/main_ui.dart';
import 'Views/verify_email_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Smart Plant',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const HomePage(),
    routes: {
      loginRoute: (context) => const LoginView(),
      registerRoute: (context) => const RegisterView(),
      mainUIRoute: (context) => const MainUI(),
      verifyEmailRoute:(context) => const VerifyEmailView(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (!user.isEmailVerified) {
                return const VerifyEmailView();
              } else {
                return const MainUI();
              }
            }
            return const LoginView();
          default:
            return const Scaffold(body: CircularProgressIndicator());
        }
      },
    );
  }
}
