import 'package:flutter/material.dart';
import 'package:kwiatuszki_dev/constants/strings.dart';

class MainUIService {
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