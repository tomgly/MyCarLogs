import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'collections/car.dart';
import 'setting.dart';

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
  late bool isCapitalized;
  late Color themeColor;
  bool menuVisible = false;
  double sBox = 0.0;
  List<String> itemList_en = ['White', 'Gray', 'Black', 'Silver', 'Blue', 'Red', 'Other'];
  List<String> itemList_ja = ['白', 'グレー', '黒', 'シルバー', '青', '赤', 'そのほか'];


  @override
  void initState() {
    super.initState();
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
  void dispose() {
    nameController.dispose();
    colorController.dispose();
    milesController.dispose();
    yearController.dispose();
    super.dispose();
  }

  List<String> _setItemList() {
    final langCode = UserPreferences.getLangCode();
    if (langCode == 'en') {
      return itemList_en;
    } else if (langCode == 'ja') {
      return itemList_ja;
    } else {
      return itemList_en;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.addCar, style: TextStyle(color: Colors.black, fontSize: 25)),
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
                labelText: AppLocalizations.of(context)!.name,
                border: OutlineInputBorder()
              ),
            ),
            SizedBox(height: 8),
            DropdownMenu(
              width: 250,
              hintText: AppLocalizations.of(context)!.color,
              enableFilter: false,
              requestFocusOnTap: true,
              dropdownMenuEntries: _setItemList()
                  .map(
                    (item) => DropdownMenuEntry(
                  value: item,
                  label: item,
                ),
              ).toList(),
              onSelected: (newVal) {
                setState(() {
                  colorController.text = newVal.toString();
                  if (colorController.text == 'Other' || colorController.text == 'そのほか') {
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
                  labelText: AppLocalizations.of(context)!.color,
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: milesController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.totalDist,
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
                  nameController.text = _capitalize(nameController.text);
                  if (nameController.text.isEmpty || colorController.text.isEmpty || milesController.text.isEmpty || yearController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(AppLocalizations.of(context)!.error),)
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
                child: Text(AppLocalizations.of(context)!.submit, style: TextStyle(color: Colors.white)),
              ),
            ),
            SizedBox(height: 8),
            Container(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(AppLocalizations.of(context)!.cancel, style: TextStyle(color: Colors.black)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}