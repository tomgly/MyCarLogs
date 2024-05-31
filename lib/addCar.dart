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
  List<String> itemList_en = ['White', 'Gray', 'Black', 'Silver', 'Blue', 'Red'];
  List<String> itemList_ja = ['白', 'グレー', '黒', 'シルバー', '青', '赤'];
  List<String> itemList_es = ['Blanco', 'Gris', 'Negro', 'Plata', 'Azul', 'Rojo'];
  List<String> itemList_pt = ['Branco', 'Cinza', 'Preto', 'Prata', 'Azul', 'Vermelho'];

  @override
  void initState() {
    super.initState();
    isCapitalized = UserPreferences.getCapitalize();
    themeColor = UserPreferences.getThemeColor();
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
    if (langCode == 'ja') {
      return itemList_ja;
    } else if (langCode == 'es') {
      return itemList_es;
    } else if (langCode == 'pt') {
      return itemList_pt;
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
                border: OutlineInputBorder(),
                suffixIcon: PopupMenuButton<String>(
                  icon: Icon(Icons.color_lens),
                  onSelected: (String color) {
                    setState(() {
                      colorController.text = color;
                    });
                  },
                  itemBuilder: (BuildContext context) {
                    return _setItemList().map((String color) {
                      return PopupMenuItem(
                        child: Text(color),
                        value: color,
                      );
                    }).toList();
                  }
                )
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: milesController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.totalDist,
                border: OutlineInputBorder()
              ),
            ),
            const SizedBox(height: 8),
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
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: () async {
                  FocusScope.of(context).unfocus();
                  if (nameController.text.isEmpty || nameController.text.isEmpty || milesController.text.isEmpty || yearController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(AppLocalizations.of(context)!.error))
                    );
                  } else if (int.tryParse(milesController.text) == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(AppLocalizations.of(context)!.errorNum))
                    );
                  } else {
                    nameController.text = UserPreferences.capitalize(nameController.text);
                    colorController.text = UserPreferences.capitalize(colorController.text);
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
          ],
        ),
      ),
    );
  }
}