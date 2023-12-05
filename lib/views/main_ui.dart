import 'package:flutter/material.dart';
import 'package:kwiatuszki_dev/constants/main_ui_menu_enum.dart';
import 'package:kwiatuszki_dev/constants/routes.dart';
import 'package:kwiatuszki_dev/constants/strings.dart';
import 'package:kwiatuszki_dev/services/auth/auth_service.dart';

class MainUI extends StatefulWidget {
  const MainUI({super.key});

  @override
  State<MainUI> createState() => _MainUIState();
}

class _MainUIState extends State<MainUI> {
  // currently not using mainUIService
  //MainUIService mainUIService = MainUIService();

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
                    if (await showLogOutDialog(context)) {
                      await AuthService.firebase().logOut();
                      // ignore: use_build_context_synchronously
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
      body: Container(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
        onPressed: (){
          
        },
      ),
    );
  }

  Future<bool> showLogOutDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('Yes')),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('No')),
          ],
          title: const Text(logOutText),
          content: const Text(areYouSureYouWantToLogOutText),
        );
      },
    ).then((value) => value ?? false);
  }
}
