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

  SettingPage({required this.isar});

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  late bool isCapitalized;
  late String version;
  late Color themeColor;
  Color pickerColor = Colors.green;
  String lang = 'en';
  String distUnit = 'mi';
  String capUnit = 'gal';
  String currencySymbol = '\$';

  @override
  void initState() {
    super.initState();
    isCapitalized = UserPreferences.getCapitalize();
    themeColor = UserPreferences.getThemeColor();
    version = UserPreferences.getVersion();
    lang = UserPreferences.getLangCode();
  }

  void _showPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.pick_themeColor),
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
              child: Text(AppLocalizations.of(context)!.submit),
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

  void _changeLang(BuildContext context, String langCode) async {
    Locale newLocale = Locale(langCode);

    await UserPreferences.setLangCode(langCode);
    MyApp.setLocale(context, newLocale);

    setState(() {
      lang = langCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.setting, style: TextStyle(color: Colors.black, fontSize: 25)),
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
                Text(AppLocalizations.of(context)!.themeColor, style: TextStyle(fontSize: 18)),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    _showPicker(context);
                  },
                  child: Icon(Icons.color_lens, color: themeColor),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(AppLocalizations.of(context)!.lang, style: TextStyle(fontSize: 18)),
                const SizedBox(width: 20),
                DropdownButton<String>(
                  value: lang,
                  items: [
                    DropdownMenuItem(value: 'en', child: Text('English')),
                    DropdownMenuItem(value: 'ja', child: Text('日本語')),
                    DropdownMenuItem(value: 'es', child: Text('Español')),
                    DropdownMenuItem(value: 'pt', child: Text('Português')),
                  ],
                  onChanged: (newVal) {
                    _changeLang(context, newVal!);
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(AppLocalizations.of(context)!.distUnit, style: TextStyle(fontSize: 18)),
                const SizedBox(width: 20),
                DropdownButton<String>(
                  value: distUnit,
                  items: [
                    DropdownMenuItem(value: 'mi', child: Text(AppLocalizations.of(context)!.miles)),
                    DropdownMenuItem(value: 'km', child: Text(AppLocalizations.of(context)!.kilometer)),
                  ],
                  onChanged: (newVal) {
                    setState(() {
                      distUnit = newVal!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(AppLocalizations.of(context)!.capUnit, style: TextStyle(fontSize: 18)),
                const SizedBox(width: 20),
                DropdownButton<String>(
                  value: capUnit,
                  items: [
                    DropdownMenuItem(value: 'gal', child: Text(AppLocalizations.of(context)!.gallon)),
                    DropdownMenuItem(value: 'L', child: Text(AppLocalizations.of(context)!.litter)),
                  ],
                  onChanged: (newVal) {
                    setState(() {
                      capUnit = newVal!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(AppLocalizations.of(context)!.currencySymbol, style: TextStyle(fontSize: 18)),
                const SizedBox(width: 20),
                DropdownButton<String>(
                  value: currencySymbol,
                  items: [
                    DropdownMenuItem(value: '\$', child: Text('\$')),
                    DropdownMenuItem(value: '\¥', child: Text('\¥')),
                  ],
                  onChanged: (newVal) {
                    setState(() {
                      currencySymbol = newVal!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            SwitchListTile.adaptive(
              title: Text(AppLocalizations.of(context)!.capitalize, style: TextStyle(fontSize: 18)),
              value: isCapitalized,
              onChanged: (newVal) async {
                setState(() {
                  isCapitalized = newVal;
                });
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setBool('isCapitalized', isCapitalized);
              },
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                showDialog(context: context, builder: (context) {
                  return AlertDialog(
                    title: Text(AppLocalizations.of(context)!.delete_all_alert),
                    actions: <Widget>[
                      GestureDetector(
                        child: Text(AppLocalizations.of(context)!.delete, style: TextStyle(color: Colors.red)),
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
                      const SizedBox(width: 8),
                      GestureDetector(
                        child: Text(AppLocalizations.of(context)!.cancel),
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  );
                });
              },
              child: Text(AppLocalizations.of(context)!.delete_all, style: TextStyle(color: Colors.red, fontSize: 18),
              ),
            ),
            const SizedBox(height: 8),
            Text(AppLocalizations.of(context)!.version + ': ' + version, style: TextStyle(fontSize: 15))
          ]
        ),
      ),
    );
  }
}

class UserPreferences {
  static late SharedPreferences _prefs;
  static late PackageInfo _packageInfo;

  static Future init() async => (
    _prefs = await SharedPreferences.getInstance(),
    _packageInfo = await PackageInfo.fromPlatform(),
  );

  static bool getCapitalize() =>
    _prefs.getBool('isCapitalized') ?? false;

  static Color getThemeColor() =>
    Color(_prefs.getInt('themeColor') ?? Color(0xFF4CAF50).value);

  static String getVersion() =>
    _packageInfo.version;

  static Future setLangCode(String langCode) async =>
      await _prefs.setString('langCode', langCode);

  static String getLangCode() =>
    _prefs.getString('langCode') ?? 'en';

  static String capitalize(text) {
    if (getCapitalize()) {
      return "${text[0].toUpperCase()}${text.substring(1).toLowerCase()}";
    } else {
      return text;
    }
  }

  static Future setUnitDist(String value) async =>
    await _prefs.setString('unitDist', value);

}