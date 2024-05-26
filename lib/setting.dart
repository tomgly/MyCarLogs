import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'main.dart';
import '../collections/car.dart';
import '../collections/input.dart';

class SettingPage extends StatefulWidget {
  final Isar isar;

  SettingPage({required this.isar});

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  late bool isCapitalized;
  late String version;

  @override
  void initState() {
    super.initState();
    getSetting();
    getInfo();
  }

  Future<void> getInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
  }

  Future<void> getSetting() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isCapitalized = prefs.getBool('isCapitalized') ?? false;
    });
  }

  void saveSetting() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isCapitalized', isCapitalized);
  }

  @override
  Widget build(BuildContext context) {
    getSetting();
    return Scaffold(
      appBar: AppBar(
        title: Text('Setting', style: TextStyle(color: Colors.black, fontSize: 25)),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(64),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SwitchListTile.adaptive(
              title: Text(isCapitalized ? 'Capitalize the first letter' : 'capitalize the first letter'),
              value: isCapitalized,
              onChanged: (newVal) async {
                setState(() {
                  isCapitalized = newVal;
                  saveSetting();
                });
              },
            ),
            TextButton(
              onPressed: () {
                showDialog(context: context, builder: (context) {
                  return AlertDialog(
                    title: Text('Are you sure to delete ALL CARS?'),
                    actions: <Widget>[
                      GestureDetector(
                        child: Text('DELETE', style: TextStyle(color: Colors.red)),
                        onTap: () async {
                          await widget.isar.writeTxn(() async {
                            await widget.isar.cars.where().deleteAll();
                            await widget.isar.fuelings.where().deleteAll();
                            await widget.isar.maintenances.where().deleteAll();
                            await widget.isar.repairs.where().deleteAll();
                          });
                          Navigator.pushAndRemoveUntil( context,
                              MaterialPageRoute(builder: (context) => MyApp(isar: widget.isar)),
                                  (_) => false
                          );
                        },
                      ),
                      GestureDetector(
                        child: Text('Cancel'),
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  );
                });
              },
              child: Text('Delete All Cars', style: TextStyle(color: Colors.red),
              ),
            ),
            Text('Version: ' + version )
          ]
        ),
      ),
    );
  }
}