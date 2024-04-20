import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:intl/intl.dart';
import '../collections/car.dart';
import '../collections/input.dart';

class FuelingInputPage extends StatefulWidget {
  final Isar isar;
  final Car car;

  const FuelingInputPage({required this.isar, required this.car});

  @override
  _FuelingInputPageState createState() => _FuelingInputPageState();
}

class _FuelingInputPageState extends State<FuelingInputPage> {
  final fuelController = TextEditingController();
  final costController = TextEditingController();
  final milesController = TextEditingController();
  final dateController = TextEditingController();
  late Car car;

  @override
  void initState() {
    super.initState();
    car = widget.car;
  }

  @override
  void dispose() {
    fuelController.dispose();
    costController.dispose();
    milesController.dispose();
    dateController.dispose();
    super.dispose();
  }

  checkMiles() async {
    if (fuelController.text == '' || costController == '' || milesController == '' || dateController == '') {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error, You need to fill all'))
      );
    } else {
      int preMiles = int.parse(widget.car.totalMiles);
      int curMiles = int.parse(milesController.text);
      int fuel = int.parse(fuelController.text);

      if (curMiles < preMiles) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error, You need to enter higher number than Total Miles'))
        );
      } else {
        final fueling = Fueling()
          ..carID = widget.car.id
          ..fuel = fuelController.text
          ..cost = costController.text
          ..aveFuel = (curMiles - preMiles) / fuel
          ..inputMiles = milesController.text
          ..date = dateController.text;
        car
          ..totalMiles = milesController.text;
        await widget.isar.writeTxn(() async {
          await widget.isar.fuelings.put(fueling);
          await widget.isar.cars.put(car);
        });
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Fueling', style: TextStyle(color: Colors.black, fontSize: 25)),
        backgroundColor: Colors.green
      ),
      body: Padding(
        padding: EdgeInsets.all(64),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: fuelController,
              keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
              decoration: InputDecoration(
                labelText: 'Fuel Amount',
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
              controller: milesController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Total Miles',
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
                  checkMiles();
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