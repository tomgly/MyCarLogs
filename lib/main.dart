import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:mycarlog/collections/fueling.dart';
import 'package:path_provider/path_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'collections/car.dart';
import 'carList.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [CarSchema, FuelingSchema],
    directory: dir.path,
  );

  runApp(MyApp(isar: isar));
}

class MyApp extends StatelessWidget {
  final Isar isar;

  MyApp({required this.isar});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyCarLog',
      theme: ThemeData(
        brightness: Brightness.light,
        textTheme: GoogleFonts.antonTextTheme(
          Theme.of(context).textTheme,
        ),
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ListPage(isar: isar),
    );
  }
}