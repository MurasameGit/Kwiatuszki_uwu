import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kwiatuszki_dev/Views/login_view.dart';
import 'package:kwiatuszki_dev/Views/register_view.dart';
import 'package:kwiatuszki_dev/constants/routes.dart';
import 'Views/main_ui.dart';
import 'Views/verify_email_view.dart';
import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'SharedCalendar',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const HomePage(),
    routes: {
      loginRoute: (context) => const LoginView(),
      registerRoute: (context) => const RegisterView(),
      mainUIRoute: (context) => const MainUI(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initializeFirebaseApp(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            print(user);
            if (user != null) {
              if (!user.emailVerified) {
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

  initializeFirebaseApp() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    await FirebaseAuth.instance.currentUser?.reload();
  }
}
