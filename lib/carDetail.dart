import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'collections/car.dart';
import 'editCar.dart';
//import 'fuelingInput.dart';
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
  late List<List<String>> _fuelingList = [
    ['10', '25', '100', '01/01/2024'],
    ['20', '35', '200', '01/02/2024'],
    ['30', '45', '300', '01/03/2024'],
    ['40', '55', '400', '01/04/2024']
  ];

  @override
  void initState() {
    super.initState();
    car = widget.car;
  }

  Future<void> loadData() async {
    final data = await widget.isar.cars.get(car.id);
    setState(() {
      car = data as Car;
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
              'Name: ' + car.name.toString(),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Color: ' + car.color.toString(),
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Total Miles: ' + car.totalMiles.toString(),
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Year: ' + car.year.toString(),
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            // Fueling Logs
            Text(
              'Fueling Logs (' + _fuelingList.length.toString() + '):',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ListView.builder(
                itemCount: _count(_fuelingList.length),
                padding: const EdgeInsets.all(15),
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int fuelingIndex) {
                  return ListTile(
                      title: Text('Fuel Amount: ' + _fuelingList[_fuelingList.length - 1 - fuelingIndex][0]
                          + 'gal, Cost: \$' + _fuelingList[_fuelingList.length - 1 - fuelingIndex][1], style:
                      TextStyle(color: Colors.black)),
                      subtitle: Text('Date: ' + _fuelingList[_fuelingList.length - 1 - fuelingIndex][3]),
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
                  onPressed: () {
                  },
                  child: Text('Add Fueling'),
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

  _count(int num) {
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