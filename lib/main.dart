import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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

class MyApp extends StatelessWidget {
  final Isar isar;

  MyApp({required this.isar});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
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
      home: ListPage(isar: isar),
    );
  }
}