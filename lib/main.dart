import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'collections/car.dart';
import 'collections/input.dart';
import 'carList.dart';
import 'setting.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [CarSchema, FuelingSchema, MaintenanceSchema, RepairSchema],
    directory: dir.path,
  );
  await UserPreferences.init();

  runApp(MyApp(isar: isar));
}

class MyApp extends StatefulWidget {
  final Isar isar;

  MyApp({required this.isar});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  @override
  void initState() {
    super.initState();
    _fetchLocale().then((locale) {
      setState(() {
        _locale = locale;
      });
    });
  }

  Future<Locale> _fetchLocale() async {
    var languageCode = UserPreferences.getLanguage();
    return Locale(languageCode ?? 'en');
  }

  void _changeLanguage(String languageCode) async {
    await UserPreferences.setLanguage(languageCode);
    var locale = await _fetchLocale();
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_locale == null) {
      return CircularProgressIndicator();
    } else {
      return MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en'),
          const Locale('ja'),
        ],
        debugShowCheckedModeBanner: false,
        title: 'MyCarLogs',
        theme: ThemeData(
          brightness: Brightness.light,
          fontFamily: 'CarterOne',
          primarySwatch: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: ListPage(isar: widget.isar, onLanguageChanged: _changeLanguage,
        ),
      );
    }
  }
}