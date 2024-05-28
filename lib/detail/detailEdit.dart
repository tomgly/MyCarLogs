import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:intl/intl.dart';
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
  late String word;
  Color themeColor = Colors.green;

  @override
  void dispose() {
    mainController.dispose();
    costController.dispose();
    dateController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.type == 0) {
      word = 'Fueling';
      fueling = widget.detail;
      mainController = TextEditingController(text: fueling.fuel);
      costController = TextEditingController(text: fueling.cost);
      dateController = TextEditingController(text: fueling.date);
    } else if (widget.type == 1) {
      word = 'Maintenance';
      mainte = widget.detail;
      mainController = TextEditingController(text: mainte.desc);
      costController = TextEditingController(text: mainte.cost);
      dateController = TextEditingController(text: mainte.date);
    }else if (widget.type == 2) {
      word = 'Repair';
      repair = widget.detail;
      mainController = TextEditingController(text: repair.repair);
      costController = TextEditingController(text: repair.cost);
      dateController = TextEditingController(text: repair.date);
    }
    themeColor = UserPreferences.getThemeColor();
  }

  selectedDate() {
    if (widget.type == 0) {
      return DateFormat('MM/dd/yyyy').parse(fueling.date);
    } else if (widget.type == 1) {
      return DateFormat('MM/dd/yyyy').parse(mainte.date);
    } else if (widget.type == 2) {
      return DateFormat('MM/dd/yyyy').parse(repair.date);
    }
  }

  save() {
    if (mainController.text.isEmpty || costController.text.isEmpty || dateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error, You need to fill all'))
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
        mainte
          ..desc = mainController.text
          ..cost = costController.text
          ..date = dateController.text;
        widget.isar.writeTxn(() async {
          await widget.isar.maintenances.put(mainte);
        });
      } else if (widget.type == 2) {
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit ' + word, style: TextStyle(color: Colors.black, fontSize: 25)),
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
                  labelText: 'Cost',
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
                labelText: 'Date',
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate(),
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
                  save();
                  Navigator.of(context).pop();
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
                child: Text('Cancel', style: TextStyle(color: Colors.black)),
              ),
            )
          ],
        ),
      ),
    );
  }
}