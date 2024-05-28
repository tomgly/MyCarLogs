import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../collections/car.dart';
import '../collections/input.dart';
import '../setting.dart';

class MaintenanceInputPage extends StatefulWidget {
  final Isar isar;
  final Car car;

  const MaintenanceInputPage({required this.isar, required this.car});

  @override
  _MaintenanceInputPageState createState() => _MaintenanceInputPageState();
}

class _MaintenanceInputPageState extends State<MaintenanceInputPage> {
  final descriptionController= TextEditingController();
  final costController = TextEditingController();
  late TextEditingController dateController;
  bool isCapitalized = false;
  Color themeColor = Colors.green;

  @override
  void initState() {
    super.initState();
    dateController = TextEditingController(text: DateFormat('MM/dd/yyyy').format(DateTime.now()));
    isCapitalized = UserPreferences.getCapitalize();
    themeColor = UserPreferences.getThemeColor();
  }

  @override
  void dispose() {
    descriptionController.dispose();
    costController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.addMaintenance, style: TextStyle(color: Colors.black, fontSize: 25)),
        backgroundColor: themeColor,
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.all(64),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: descriptionController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.description,
                border: OutlineInputBorder()
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: costController,
              keyboardType: TextInputType.numberWithOptions(decimal: true, signed: false),
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.cost,
                border: OutlineInputBorder()
              ),
            ),
            const SizedBox(height: 20),
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
                    DateTime initDate = DateTime.now();
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: initDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );
                    dateController.text = DateFormat('MM/dd/yyyy').format(picked as DateTime);
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: () async {
                  FocusScope.of(context).unfocus();
                  if (descriptionController.text.isEmpty || costController.text.isEmpty ||dateController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(AppLocalizations.of(context)!.error))
                    );
                  } else {
                    descriptionController.text = UserPreferences.capitalize(descriptionController.text);
                    final mainte = Maintenance()
                      ..carID = widget.car.id
                      ..desc = descriptionController.text
                      ..cost = costController.text
                      ..date = dateController.text;
                    await widget.isar.writeTxn(() async {
                      await widget.isar.maintenances.put(mainte);
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