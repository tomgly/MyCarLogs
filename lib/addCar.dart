import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'collections/car.dart';

class AddCarPage extends StatefulWidget {
  final Isar isar;

  const AddCarPage({required this.isar});

  @override
  _AddCarPageState createState() => _AddCarPageState();
}

class _AddCarPageState extends State<AddCarPage> {
  final nameController = TextEditingController();
  final colorController = TextEditingController();
  final milesController = TextEditingController();
  final yearController = TextEditingController();
  bool isCapitalized = false;
  Color themeColor = Colors.green;
  bool menuVisible = false;
  double sBox = 0.0;
  List<String> itemList = ['White', 'Gray', 'Black', 'Silver', 'Blue', 'Red', 'Other'];

  @override
  void initState() {
    super.initState();
    getSetting();
  }

  Future<void> getSetting() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isCapitalized = prefs.getBool('isCapitalized') ?? false;
      themeColor = Color(prefs.getInt('themeColor') ?? Color(0xFF4CAF50).value);
    });
  }

  String capitalize(text) {
    if (isCapitalized) {
      return "${text[0].toUpperCase()}${text.substring(1).toLowerCase()}";
    } else {
      return text;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    colorController.dispose();
    milesController.dispose();
    yearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Your Car', style: TextStyle(color: Colors.black, fontSize: 25)),
        backgroundColor: themeColor,
      ),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(64),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 8),
            TextField(
              controller: nameController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                labelText: 'Car Name',
                border: OutlineInputBorder()
              ),
              onChanged: (newVal) {
                nameController.text = capitalize(newVal);
              },
            ),
            SizedBox(height: 8),
            DropdownMenu(
              width: 250,
              hintText: 'Body Color',
              enableFilter: false,
              requestFocusOnTap: true,
              dropdownMenuEntries: itemList
                  .map(
                    (item) => DropdownMenuEntry(
                  value: item,
                  label: item,
                ),
              ).toList(),
              onSelected: (newVal) {
                setState(() {
                  colorController.text = newVal.toString();
                  if (colorController.text == 'Other') {
                    menuVisible = true;
                    colorController.text = '';
                    sBox = 8;
                  }
                });
              },
            ),
            SizedBox(height: sBox),
            Visibility(
              visible: menuVisible,
              child: TextField(
                controller: colorController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  labelText: 'Body Color',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: milesController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Total Miles',
                border: OutlineInputBorder()
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: yearController,
              keyboardType: TextInputType.datetime,
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
                              selectedDate: DateTime.now(),
                              onChanged: (DateTime value) {
                                yearController.text = DateFormat('yyyy').format(value);
                                Navigator.pop(context);
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
            SizedBox(height: 10),
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
                    final car = Car()
                      ..name = nameController.text
                      ..color = colorController.text
                      ..firstMiles = milesController.text
                      ..totalMiles = milesController.text
                      ..year = yearController.text;
                    await widget.isar.writeTxn(() async {
                      await widget.isar.cars.put(car);
                    });
                    Navigator.of(context).pop();
                  }
                },
                child: Text('Submit', style: TextStyle(color: Colors.white)),
              ),
            ),
            SizedBox(height: 8),
            Container(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel', style: TextStyle(color: Colors.black)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}