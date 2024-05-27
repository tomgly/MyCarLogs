import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'collections/car.dart';
import 'collections/input.dart';
import 'main.dart';

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
  Color themeColor = Colors.green;

  @override
  void initState() {
    super.initState();
    car = widget.car;
    nameController = TextEditingController(text: car.name);
    colorController = TextEditingController(text: car.color);
    milesController = TextEditingController(text: car.totalMiles);
    yearController = TextEditingController(text: car.year);
    getSetting();
  }

  Future<void> getSetting() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      themeColor = Color(prefs.getInt('themeColor') ?? Color(0xFF4CAF50).value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Your Car', style: TextStyle(color: Colors.black, fontSize: 25)),
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
                labelText: 'Car Name',
                border: OutlineInputBorder()
              ),
              onChanged: (newVal) {
                nameController.text = newVal.capitalize();
              },
            ),
            const SizedBox(height: 8),
            TextField(
              controller: colorController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                labelText: 'Body Color',
                border: OutlineInputBorder()
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: milesController,
              keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
              decoration: InputDecoration(
                labelText: 'Total Miles',
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
                labelText: 'Year',
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Select Year'),
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
                  if (nameController.text.isEmpty || colorController.text.isEmpty || milesController.text.isEmpty || yearController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Error, You need to fill all'))
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
                child: Text('Submit', style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
            ),
            Container(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  showDialog(context: context, builder: (context) {
                    return AlertDialog(
                      title: Text('Are you sure to delete this car?'),
                      actions: <Widget>[
                        GestureDetector(
                          child: Text('DELETE', style: TextStyle(color: Colors.red)),
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
                child: Text('Delete This Car', style: TextStyle(color: Colors.red),
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}