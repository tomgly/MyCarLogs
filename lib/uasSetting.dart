import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:settings_ui/settings_ui.dart';
import 'setting.dart';

class uasSettingPage extends StatefulWidget {
  final Isar isar;

  uasSettingPage({required this.isar});

  @override
  _uasSettingPageState createState() => _uasSettingPageState();
}

class _uasSettingPageState extends State<uasSettingPage> {
  late Color themeColor;
  bool isMiles = true;
  bool isGallon = true;
  bool isDollar = true;

  @override
  void initState() {
    super.initState();
    themeColor = UserPreferences.getThemeColor();
    if (UserPreferences.getDistUnit() != 'mi') {
      isMiles = false;
    }
    if (UserPreferences.getCapUnit() != 'gal') {
      isGallon = false;
    }
    if (UserPreferences.getCurrencySymbol() != '\$') {
      isDollar = false;
    }
  }

  _showCheck(bool isCheck) {
    if (isCheck) {
      return Icon(Icons.check_rounded, color: Colors.blue);
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.uas_setting,
          style: TextStyle(color: Colors.black, fontSize: 25)),
        backgroundColor: themeColor,
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: Text(AppLocalizations.of(context)!.distUnit),
            tiles: <SettingsTile>[
              SettingsTile(
                title: Text(AppLocalizations.of(context)!.miles),
                value: _showCheck(isMiles),
                onPressed: (context) async {
                  setState(() {
                    isMiles = true;
                  });
                  await UserPreferences.setDistUnit(isMiles);
                },
              ),
              SettingsTile(
                title: Text(AppLocalizations.of(context)!.kilometer),
                value: _showCheck(!isMiles),
                onPressed: (context) async {
                  setState(() {
                    isMiles = false;
                  });
                  await UserPreferences.setDistUnit(isMiles);
                },
              ),
            ]
          ),
          SettingsSection(
            title: Text(AppLocalizations.of(context)!.capUnit),
            tiles: <SettingsTile>[
              SettingsTile(
                title: Text(AppLocalizations.of(context)!.gallon),
                value: _showCheck(isGallon),
                onPressed: (context) async {
                  setState(() {
                    isGallon = true;
                  });
                  await UserPreferences.setCapUnit(isGallon);
                },
              ),
              SettingsTile(
                title: Text(AppLocalizations.of(context)!.litter),
                value: _showCheck(!isGallon),
                onPressed: (context) async {
                  setState(() {
                    isGallon = false;
                  });
                  await UserPreferences.setCapUnit(isGallon);
                },
              ),
            ]
          ),
          SettingsSection(
            title: Text(AppLocalizations.of(context)!.currencySymbol),
            tiles: <SettingsTile>[
              SettingsTile(
                title: Text('\$'),
                value: _showCheck(isDollar),
                onPressed: (context) async {
                  setState(() {
                    isDollar = true;
                  });
                  await UserPreferences.setCurrencySymbol(isDollar);
                },
              ),
              SettingsTile(
                title: Text('\¥'),
                value: _showCheck(!isDollar),
                onPressed: (context) async {
                  setState(() {
                    isDollar = false;
                  });
                  await UserPreferences.setCurrencySymbol(isDollar);
                },
              ),
            ]
          ),
        ],
      ),
    );
  }
}