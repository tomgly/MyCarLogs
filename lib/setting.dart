import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:settings_ui/settings_ui.dart';
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
  int returnNum = 0;
  List<String> langList = ['English', '日本語', 'Español', 'Português'];
  List<String> langCode = ['en', 'ja', 'es', 'pt'];
  bool isMiles = true;
  List<String> distUnit = ['mi', 'km'];
  bool isGallon = true;
  List<String> capUnit = ['gal', 'L'];
  List<String> currencySymbol = ['\$', '\¥'];

  @override
  void initState() {
    super.initState();
    isCapitalized = UserPreferences.getCapitalize();
    themeColor = UserPreferences.getThemeColor();
    version = UserPreferences.getVersion();
    if (UserPreferences.getDistUnit() != 'mi') {
      isMiles = false;
    }
    if (UserPreferences.getCapUnit() != 'gal') {
      isGallon = false;
    }
  }

  void _changeLang(BuildContext context, String langCode) async {
    Locale newLocale = Locale(langCode);

    await UserPreferences.setLangCode(langCode);
    MyApp.setLocale(context, newLocale);
  }

  _showDialog(List<String> list) async => showDialog(context: context, builder: (context) =>
    AlertDialog(
      title: Text(AppLocalizations.of(context)!.lang),
      content: Container(
        width: 100,
        height: 240,
        child: ListView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: list.length,
          itemBuilder: (BuildContext contest, int index) => ListTile (
            title: Text(list[index]),
            onTap: () {
              returnNum = index;
              Navigator.of(context).pop();
            },
          )
        ),
      )
    )
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.setting,
          style: TextStyle(color: Colors.black, fontSize: 25)),
        backgroundColor: themeColor,
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: Text('Common'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: const Icon(Icons.language),
                title: Text(AppLocalizations.of(context)!.lang),
                value: Text(AppLocalizations.of(context)!.lang_name),
                onPressed: (context) async {
                  await _showDialog(langList);
                  _changeLang(context, langCode[returnNum]);
                  returnNum = 0;
                }
              ),
              SettingsTile(
                leading: Icon(Icons.color_lens, color: themeColor),
                title: Text(AppLocalizations.of(context)!.themeColor),
                onPressed: (context) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(AppLocalizations.of(context)!.pick_themeColor),
                        content: SingleChildScrollView(
                          child: BlockPicker(
                            availableColors: [Colors.red,Colors.redAccent,Colors.purpleAccent,Colors.purple,
                              Colors.deepPurple,Colors.indigo,Colors.blue,Colors.blueAccent,
                              Colors.cyan,Colors.teal,Colors.green,Colors.lightGreen,
                              Colors.greenAccent,Colors.yellow,Colors.orangeAccent,Colors.orange,
                              Colors.deepOrange,Colors.brown,Colors.grey,Colors.blueGrey
                            ],
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
                },
              ),
            ]
          ),
          SettingsSection(
            title: Text('Unit and Symbol'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: Icon(Icons.location_pin),
                title: Text(AppLocalizations.of(context)!.distUnit),
                value: Text(isMiles ? AppLocalizations.of(context)!.miles : AppLocalizations.of(context)!.kilometer),
                onPressed: (context) async {
                  await _showDialog([AppLocalizations.of(context)!.miles, AppLocalizations.of(context)!.kilometer]);
                  await UserPreferences.setDistUnit(distUnit[returnNum]);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => super.widget)
                  );
                }
              ),
              SettingsTile.navigation(
                leading: Icon(Icons.local_gas_station),
                title: Text(AppLocalizations.of(context)!.capUnit),
                value: Text(isGallon ? AppLocalizations.of(context)!.gallon : AppLocalizations.of(context)!.litter),
                onPressed: (context) async {
                  await _showDialog([AppLocalizations.of(context)!.gallon, AppLocalizations.of(context)!.litter]);
                  await UserPreferences.setCapUnit(capUnit[returnNum]);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => super.widget)
                  );
                }
              ),
              SettingsTile.navigation(
                leading: Icon(Icons.currency_exchange),//c
                title: Text(AppLocalizations.of(context)!.currencySymbol),
                value: Text(UserPreferences.getCurrencySymbol()),
                onPressed: (context) async {
                  await _showDialog(['\$', '\¥']);
                  await UserPreferences.setCurrencySymbol(currencySymbol[returnNum]);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => super.widget)
                  );
                }
              )
            ]
          ),
          SettingsSection(
            title: Text('Other'),
            tiles: <SettingsTile>[
              SettingsTile(
                title: Text(AppLocalizations.of(context)!.delete_all, style: TextStyle(color: Colors.red)),
                onPressed: (context) {
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
              ),
              SettingsTile(
                leading: const Icon(Icons.info_outline),
                title: Text(AppLocalizations.of(context)!.version),
                value: Text(version)
              ),
            ],
          ),
        ],
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

  static Future setDistUnit(String value) async =>
    await _prefs.setString('distUnit', value);

  static String getDistUnit() =>
    _prefs.getString('distUnit') ?? 'mi';

  static Future setCapUnit(String value) async =>
    await _prefs.setString('capUnit', value);

  static String getCapUnit() =>
    _prefs.getString('capUnit') ?? 'gal';

  static String getAveFuel() {
    if (getDistUnit() == 'mi') {
      return getDistUnit().substring(0,1) + 'p' + getCapUnit().substring(0,1);;
    } else {
      return getDistUnit() + 'p' + getCapUnit().substring(0,1);
    }
  }

  static Future setCurrencySymbol(String value) async =>
    await _prefs.setString('currencySymbol', value);

  static String getCurrencySymbol() =>
    _prefs.getString('currencySymbol') ?? '\$';
}