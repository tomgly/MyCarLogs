import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
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
  bool isCapitalized = false;
  String version = '0.0';
  Color themeColor = Colors.green;
  Color pickerColor = Colors.green;

  @override
  void initState() {
    super.initState();
    getSetting();
    getInfo();
  }

  Future<void> getSetting() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isCapitalized = prefs.getBool('isCapitalized') ?? false;
      themeColor = Color(prefs.getInt('themeColor') ?? Color(0xFF4CAF50).value);
    });
  }

  Future<void> getInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
  }

  void showPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a theme color'),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: themeColor,
              onColorChanged: (newVal) {
                pickerColor = newVal;
              },
            ),
          ),
          actions: <Widget>[
            GestureDetector(
              child: Text('Got it'),
              onTap: () async {
                setState(() {
                  themeColor = pickerColor;
                });
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setInt('themeColor', pickerColor.value);
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    getSetting();
    return Scaffold(
      appBar: AppBar(
        title: Text('Setting', style: TextStyle(color: Colors.black, fontSize: 25)),
        backgroundColor: themeColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(64),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Theme Color', style: TextStyle(fontSize: 18)),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    showPicker(context);
                  },
                  child: Icon(Icons.color_lens, color: themeColor),
                ),
              ],
            ),
            SizedBox(height: 10),
            SwitchListTile.adaptive(
              title: Text(isCapitalized ? 'Capitalize the first letter' : 'capitalize the first letter', style: TextStyle(fontSize: 18)),
              value: isCapitalized,
              onChanged: (newVal) async {
                setState(() {
                  isCapitalized = newVal;
                });
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setBool('isCapitalized', isCapitalized);
              },
            ),
            SizedBox(height: 10),
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
              child: Text('Delete All Cars', style: TextStyle(color: Colors.red, fontSize: 18),
              ),
            ),
            SizedBox(height: 8),
            Text('Version: ' + version, style: TextStyle(fontSize: 15))
          ]
        ),
      ),
    );
  }
}