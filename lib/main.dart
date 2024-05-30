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
  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>()!;
    state.setLocale(newLocale);
  }

  MyApp({required this.isar});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? locale;

  @override
  void initState() {
    super.initState();
    _loadLang();
  }

  void setLocale(Locale newLocale) {
    setState(() {
      locale = newLocale;
    });
  }

  void _loadLang() async {
    String savedLangCode = UserPreferences.getLangCode();
    setState(() {
      locale = Locale(savedLangCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (locale == null) {
      return CircularProgressIndicator();
    } else {
      return MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          const Locale('en'),
          const Locale('ja'),
          const Locale('es'),
          const Locale('pt'),
        ],
        debugShowCheckedModeBanner: false,
        title: 'MyCarLogs',
        theme: ThemeData(
          brightness: Brightness.light,
          fontFamily: 'YuseiMagic',
          primarySwatch: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        locale: locale,
        home: ListPage(isar: widget.isar),
      );
    }
  }
}