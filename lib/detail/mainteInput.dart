import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:intl/intl.dart';
import '../collections/car.dart';
import '../collections/input.dart';

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
  final dateController = TextEditingController();

  @override
  void dispose() {
    descriptionController.dispose();
    costController.dispose();
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Maintenance', style: TextStyle(color: Colors.black, fontSize: 25)),
        backgroundColor: Colors.green      ),
      body: Padding(
        padding: EdgeInsets.all(64),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: descriptionController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder()
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: costController,
              keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
              decoration: InputDecoration(
                labelText: 'Cost',
                border: OutlineInputBorder()
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: dateController,
              keyboardType: TextInputType.datetime,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Date',
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
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: () async {
                  final mainte = Maintenance()
                    ..carID = widget.car.id
                    ..desc= descriptionController.text
                    ..cost = costController.text
                    ..date = dateController.text;
                  await widget.isar.writeTxn(() async {
                    await widget.isar.maintenances.put(mainte);
                  });
                  Navigator.of(context).pop();
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