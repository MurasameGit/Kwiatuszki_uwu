//import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:kwiatuszki_dev/constants/main_ui_menu_enum.dart';
import 'package:kwiatuszki_dev/constants/routes.dart';
import 'package:kwiatuszki_dev/constants/strings.dart';
import 'package:kwiatuszki_dev/services/auth/auth_service.dart';
import 'package:kwiatuszki_dev/services/database/firebase_realtime_db_provider.dart';
import 'package:numberpicker/numberpicker.dart';

class MainUI extends StatefulWidget {
  const MainUI({super.key});

  @override
  State<MainUI> createState() => _MainUIState();
}

class _MainUIState extends State<MainUI> {
  // currently not using mainUIService
  //MainUIService mainUIService = MainUIService();

  //TODO all things with firestore
  final db = FirebaseDatabase.instance.ref("/Devices");

  FirebaseRealtimeDBProvider dbProvider = FirebaseRealtimeDBProvider();

  Query dbRef = FirebaseDatabase.instance.ref().child("/Devices");
  int _currentIntValue = 1000;
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
      body: SizedBox(
        height: double.infinity,
        child: FirebaseAnimatedList(
          query: dbRef,
          itemBuilder: (
            BuildContext context,
            DataSnapshot snapshot,
            Animation<double> animation,
            int index,
          ) {
            Map device = snapshot.value as Map;
            device['key'] = snapshot.key;
            return listItem(device: device);
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
        onPressed: () async {
          //TODO bottom-right button on pressed function
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

  //TODO force pump on
  // void forcePumpOn() {
  //   db.collection("Doniczki").doc('TeRwTiGBF3P7sv0Ihgr1').update(data);
  // }

  Widget listItem({required Map device}) {
    return Container(
      margin: const EdgeInsets.all(5.0),
      padding: const EdgeInsets.all(5.0),
      height: 160,
      color: Colors.amberAccent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Device:           ${device['mac']}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              )),
          const SizedBox(
            height: 5,
          ),
          Text("Current humidity:      ${device['wilgotnosc']}"),
          const SizedBox(
            height: 5,
          ),
          Text("Humidity threshold:  ${device['humidity_threshold']}"),
          const SizedBox(
            height: 5,
          ),
          Text("Is pump forced on? : ${device['force']}"),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () async {
                  await showDevicePanel(context, device);
                },
                icon: const Icon(Icons.edit),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future showDevicePanel(BuildContext context, Map device) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: const Text("Update Humidity Threshold"),
              content: StatefulBuilder(builder: (context, SBsetState) {
                return NumberPicker(
                    value: _currentIntValue,
                    minValue: 0,
                    maxValue: 5000,
                    step: 10,
                    haptics: true,
                    onChanged: (value) => {
                          setState(() => _currentIntValue = value),
                          SBsetState(() => _currentIntValue = value)
                        });
              }),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Discard')),
                TextButton(
                    onPressed: () async {
                      device['humidity_threshold'] = _currentIntValue;
                      String mac = device['mac'];
                      await db
                          .child("/$mac/humidity_threshold")
                          .set(_currentIntValue);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Update')),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Current int value: $_currentIntValue'),
                  ],
                )
              ]);
        });
  }
}
