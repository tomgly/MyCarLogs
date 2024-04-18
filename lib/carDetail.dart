import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'collections/car.dart';
import 'collections/fueling.dart';
import 'editCar.dart';
import 'fuelingInput.dart';
//import 'repairInput.dart';

class DetailPage extends StatefulWidget {
  final Isar isar;
  final Car car;

  const DetailPage({required this.isar, required this.car});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Car car;
  List<Fueling> fuelings = [];

  @override
  void initState() {
    super.initState();
    car = widget.car;
  }

  Future<void> loadData() async {
    final carData = await widget.isar.cars.get(car.id);
    final fuelingData = await widget.isar.fuelings.filter().carIDEqualTo(car.id).sortByDateDesc().findAll();
    setState(() {
      car = carData as Car;
      fuelings = fuelingData.cast<Fueling>();
    });
  }

  @override
  Widget build(BuildContext context) {
    loadData();
    return Scaffold(
      appBar: AppBar(
        title: Text('Car Details', style: TextStyle(color: Colors.black, fontSize: 25)),
        backgroundColor: Colors.green,
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EditPage(isar: widget.isar, car: car),
                ),
              );
            },
            icon: Icon(Icons.mode_edit, color: Colors.black),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Car Information
            Text(
              'Name: ' + (car.name ?? 'No Name'),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Color: ' + (car.color ?? 'NO Color'),
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Total Miles: ' + (car.totalMiles ?? 'No Total Miles'),
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Year: ' + (car.year ?? 'No Year'),
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            // Fueling Logs
            Text(
              'Fueling Logs (' + fuelings.length.toString() + '):',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ListView.builder(
                itemCount: count(fuelings.length),
                padding: const EdgeInsets.all(15),
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  final fueling = fuelings[index];
                  return ListTile(
                      title: Text('Fuel Amount: ' + (fueling.fuel ?? 'No Data') + 'gal, Cost: \$' + (fueling.cost ?? 'No Data'),
                          style: TextStyle(color: Colors.black)),
                      subtitle: Text('Date: ' + (fueling.date ?? 'MM/dd/yyyy')),
                      tileColor: Color(0xffffdad3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                      )
                  );
                }
            ),
            const SizedBox(height: 20),
            // Maintenance Logs
            Text(
              'Maintenance Logs:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Repair Logs
            Text(
              'Repair Logs:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => FuelingInputPage(isar: widget.isar, car: car),
                      ),
                    );
                  },
                  child: Text('Add Fueling'),
                ),
                ElevatedButton(
                  onPressed: () {
                  },
                  child: Text('Add Maintenance'),
                ),
                ElevatedButton(
                  onPressed: () {
                  },
                  child: Text('Add Repair'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  count(int num) {
    if (num < 3) {
      return num;
    } else if (num >= 3){
      return 3;
    }
  }
}

class ErrorDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Error'),
      actions: <Widget>[
        GestureDetector(
          child: Text('OK'),
          onTap: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}