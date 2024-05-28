import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../collections/input.dart';
import '../setting.dart';

class DetailEditPage extends StatefulWidget {
  final Isar isar;
  final int type;
  final detail;

  DetailEditPage({required this.isar, required this.type, required this.detail});

  @override
  _DetailEditPageState createState() => _DetailEditPageState();
}

class _DetailEditPageState extends State<DetailEditPage> {
  late Fueling fueling;
  late Maintenance mainte;
  late Repair repair;
  late TextEditingController mainController;
  late TextEditingController costController;
  late TextEditingController dateController;
  late String title;
  late String word;
  late Color themeColor;

  @override
  void initState() {
    super.initState();
    themeColor = UserPreferences.getThemeColor();
  }

  _setData () {
    if (widget.type == 0) {
      title = AppLocalizations.of(context)!.editFueling;
      word = AppLocalizations.of(context)!.fuelAmount;
      fueling = widget.detail;
      mainController = TextEditingController(text: fueling.fuel);
      costController = TextEditingController(text: fueling.cost);
      dateController = TextEditingController(text: fueling.date);
    } else if (widget.type == 1) {
      title = AppLocalizations.of(context)!.editMaintenance;
      word = AppLocalizations.of(context)!.description;
      mainte = widget.detail;
      mainController = TextEditingController(text: mainte.desc);
      costController = TextEditingController(text: mainte.cost);
      dateController = TextEditingController(text: mainte.date);
    }else if (widget.type == 2) {
      title = AppLocalizations.of(context)!.editRepair;
      word = AppLocalizations.of(context)!.repair;
      repair = widget.detail;
      mainController = TextEditingController(text: repair.repair);
      costController = TextEditingController(text: repair.cost);
      dateController = TextEditingController(text: repair.date);
    }
  }

  _selectedDate() {
    if (widget.type == 0) {
      return DateFormat('MM/dd/yyyy').parse(fueling.date);
    } else if (widget.type == 1) {
      return DateFormat('MM/dd/yyyy').parse(mainte.date);
    } else if (widget.type == 2) {
      return DateFormat('MM/dd/yyyy').parse(repair.date);
    }
  }

  _saveData() {
    if (mainController.text.isEmpty || costController.text.isEmpty || dateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.error))
      );
    } else {
      if (widget.type == 0) {
        fueling
          ..fuel = mainController.text
          ..cost = costController.text
          ..date = dateController.text;
        widget.isar.writeTxn(() async {
          await widget.isar.fuelings.put(fueling);
        });
      } else if (widget.type == 1) {
        mainController.text = UserPreferences.capitalize(mainController.text);
        mainte
          ..desc = mainController.text
          ..cost = costController.text
          ..date = dateController.text;
        widget.isar.writeTxn(() async {
          await widget.isar.maintenances.put(mainte);
        });
      } else if (widget.type == 2) {
        mainController.text = UserPreferences.capitalize(mainController.text);
        repair
          ..repair = mainController.text
          ..cost = costController.text
          ..date = dateController.text;
        widget.isar.writeTxn(() async {
          await widget.isar.repairs.put(repair);
        });
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    _setData();
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: TextStyle(color: Colors.black, fontSize: 25)),
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
              controller: mainController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                  labelText: word,
                  border: OutlineInputBorder()
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: costController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.cost,
                  border: OutlineInputBorder()
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: dateController,
              keyboardType: TextInputType.datetime,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: AppLocalizations.of(context)!.date,
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );
                    dateController.text = DateFormat('MM/dd/yyyy').format(picked as DateTime);
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
                  _saveData();
                  Navigator.of(context).pop();
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
            )
          ],
        ),
      ),
    );
  }
}