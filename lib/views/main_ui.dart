import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:kwiatuszki_dev/constants/main_ui_menu_enum.dart';
import 'package:kwiatuszki_dev/constants/routes.dart';
import 'package:kwiatuszki_dev/services/main_ui_service.dart';


class MainUI extends StatefulWidget {
  const MainUI({Key? key}) : super(key: key);

  @override
  State<MainUI> createState() => _MainUIState();
}

class _MainUIState extends State<MainUI> {
  MainUIService mainUIService = MainUIService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main UI'),
        actions: [
          PopupMenuButton(
            onSelected: (value) async {
              switch (value) {
                case MainUIPopupEnum.logout:
                  {
                    if (await mainUIService.showLogOutDialog(context)) {
                      await FirebaseAuth.instance.signOut();
                      if (!mounted) return;
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        loginRoute,
                        (route) => false,
                      );
                    }
                  }
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MainUIPopupEnum>(
                  value: MainUIPopupEnum.logout,
                  child: Text('Logout'),
                ),
              ];
            },
          )
        ],
      ),
    );
  }
}