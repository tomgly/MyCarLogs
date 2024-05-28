import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'collections/car.dart';
import 'collections/input.dart';
import 'main.dart';
import 'setting.dart';

class EditPage extends StatefulWidget {
  final Isar isar;
  final Car car;

  const EditPage({required this.isar, required this.car});

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late Car car;
  late TextEditingController nameController;
  late TextEditingController colorController;
  late TextEditingController milesController;
  late TextEditingController yearController;
  late bool isCapitalized;
  late Color themeColor;

  @override
  void initState() {
    super.initState();
    car = widget.car;
    nameController = TextEditingController(text: car.name);
    colorController = TextEditingController(text: car.color);
    milesController = TextEditingController(text: car.totalMiles);
    yearController = TextEditingController(text: car.year);
    isCapitalized = UserPreferences.getCapitalize();
    themeColor = UserPreferences.getThemeColor();
  }

  String _capitalize(text) {
    if (isCapitalized) {
      return "${text[0].toUpperCase()}${text.substring(1).toLowerCase()}";
    } else {
      return text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.editCar, style: TextStyle(color: Colors.black, fontSize: 25)),
        backgroundColor: themeColor,
      ),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(64),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 8),
            TextField(
              controller: nameController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.name,
                border: OutlineInputBorder()
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: colorController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.color,
                border: OutlineInputBorder()
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: milesController,
              keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.totalDist,
                border: OutlineInputBorder()
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: yearController,
              keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: AppLocalizations.of(context)!.year,
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(AppLocalizations.of(context)!.selectYear),
                          content: Container(
                            width: 300,
                            height: 300,
                            child: YearPicker(
                              firstDate: DateTime(1980),
                              lastDate: DateTime(2024),
                              //initialDate: DateTime.now(),
                              selectedDate: DateFormat('yyyy').parse(car.year),
                              onChanged: (DateTime value) {
                                Navigator.pop(context);
                                yearController.text = DateFormat('yyyy').format(value);
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: () async {
                  FocusScope.of(context).unfocus();
                  nameController.text = _capitalize(nameController.text);
                  if (nameController.text.isEmpty || colorController.text.isEmpty || milesController.text.isEmpty || yearController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(AppLocalizations.of(context)!.error))
                    );
                  } else {
                    car
                      ..name = nameController.text
                      ..color = colorController.text
                      ..totalMiles = milesController.text
                      ..year = yearController.text;
                    widget.isar.writeTxn(() async {
                      await widget.isar.cars.put(car);
                    });
                    Navigator.of(context).pop();
                  }
                },
                child: Text(AppLocalizations.of(context)!.submit, style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(AppLocalizations.of(context)!.cancel, style: TextStyle(color: Colors.black)),
              ),
            ),
            Container(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  showDialog(context: context, builder: (context) {
                    return AlertDialog(
                      title: Text(AppLocalizations.of(context)!.delete_this_alert),
                      actions: <Widget>[
                        GestureDetector(
                          child: Text(AppLocalizations.of(context)!.delete, style: TextStyle(color: Colors.red)),
                          onTap: () async {
                            await widget.isar.writeTxn(() async {
                              await widget.isar.cars.delete(car.id);
                              await widget.isar.fuelings..filter().carIDEqualTo(car.id).deleteAll();
                              await widget.isar.maintenances..filter().carIDEqualTo(car.id).deleteAll();
                              await widget.isar.repairs..filter().carIDEqualTo(car.id).deleteAll();
                            });
                            Navigator.pushAndRemoveUntil( context,
                              MaterialPageRoute(builder: (context) => MyApp(isar: widget.isar)),
                                  (_) => false
                            );
                          },
                        ),
                        SizedBox(width: 8),
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
                child: Text(AppLocalizations.of(context)!.delete_this, style: TextStyle(color: Colors.red),
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}