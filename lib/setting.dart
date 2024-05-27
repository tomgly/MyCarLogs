import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'main.dart';
import '../collections/car.dart';
import '../collections/input.dart';

class SettingPage extends StatefulWidget {
  final Isar isar;
  final ValueChanged<String> onLanguageChanged;

  SettingPage({required this.isar, required this.onLanguageChanged});

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool _isCapitalized = false;
  String _version = '0.0';
  Color _themeColor = Colors.green;
  Color _pickerColor = Colors.green;

  @override
  void initState() {
    super.initState();
    _getSetting();
  }

  Future<void> _getSetting() async {
    final getCapitalize = await UserPreferences.getCapitalize();
    final getThemeColor = await UserPreferences.getThemeColor();
    final getVersion = await UserPreferences.getVersion();
    setState(() {
      _isCapitalized = getCapitalize;
      _themeColor = getThemeColor;
      _version = getVersion;
    });
  }

  void _showPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a theme color'),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: _themeColor,
              onColorChanged: (newVal) {
                _pickerColor = newVal;
              },
            ),
          ),
          actions: <Widget>[
            GestureDetector(
              child: Text('Got it'),
              onTap: () async {
                setState(() {
                  _themeColor = _pickerColor;
                });
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setInt('themeColor', _pickerColor.value);
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
    _getSetting();
    return Scaffold(
      appBar: AppBar(
        title: Text('Setting', style: TextStyle(color: Colors.black, fontSize: 25)),
        backgroundColor: _themeColor,
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
                    _showPicker(context);
                  },
                  child: Icon(Icons.color_lens, color: _themeColor),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(AppLocalizations.of(context)!.lang, style: TextStyle(fontSize: 18)),
                SizedBox(width: 20),
                DropdownButton<String>(
                  value: UserPreferences.getLanguage(),
                  items: [
                    DropdownMenuItem(value: 'en', child: Text('English')),
                    DropdownMenuItem(value: 'ja', child: Text('日本語')),
                  ],
                  onChanged: (value) {
                    widget.onLanguageChanged(value!);
                  },
                ),
              ],
            ),
            SizedBox(height: 10),
            SwitchListTile.adaptive(
              title: Text(_isCapitalized ? 'Capitalize the first letter' : 'capitalize the first letter', style: TextStyle(fontSize: 18)),
              value: _isCapitalized,
              onChanged: (newVal) async {
                setState(() {
                  _isCapitalized = newVal;
                });
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setBool('isCapitalized', _isCapitalized);
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
                              MaterialPageRoute(builder: (context) => MyApp(isar: widget.isar)), (_) => false
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
            Text('Version: ' + _version, style: TextStyle(fontSize: 15))
          ]
        ),
      ),
    );
  }
}

class UserPreferences {
  static late SharedPreferences _prefs;
  static const _keyLanguage = 'language';

  static Future init() async =>
      _prefs = await SharedPreferences.getInstance();

  static bool getCapitalize() =>
      _prefs.getBool('isCapitalized') ?? false;

  static Color getThemeColor() =>
      Color(_prefs.getInt('themeColor') ?? Color(0xFF4CAF50).value);

  static Future<String> getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  static Future setLanguage(String languageCode) async =>
      await _prefs.setString(_keyLanguage, languageCode);

  static String? getLanguage() =>
      _prefs.getString(_keyLanguage);
}