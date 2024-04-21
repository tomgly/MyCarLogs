import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'collections/car.dart';
import 'addCar.dart';
import 'setting.dart';
import 'carDetail.dart';

class ListPage extends StatefulWidget {
  final Isar isar;

  ListPage({required this.isar});

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List<Car> cars = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final data = await widget.isar.cars.where().findAll();
    setState(() {
      cars = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    loadData();
    return Scaffold(
      appBar: AppBar(
        title: Text('MyCarLogs', style: TextStyle(color: Colors.black, fontSize: 25)),
        backgroundColor: Colors.green,
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) {
                  return SettingPage(isar: widget.isar);
                }),
              );
            },
            icon: Icon(Icons.settings, color: Colors.black),
          )
        ],
      ),
      body: Column(
        children: [ Expanded(
          child: Card(
            child: ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: cars.length,
              padding: const EdgeInsets.all(15),
              itemBuilder: (BuildContext context, int index) {
                final car = cars[index];
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(car.name, style: TextStyle(color: Colors.black)),
                    subtitle: Text('Color: ' + (car.color) + ', Year: ' + (car.year)),
                    tileColor: Color(0xffddffdd),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      side: BorderSide(color: Colors.black),
                    ),
                    onTap: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) {
                          return DetailPage(isar: widget.isar, car: car);
                        }),
                      );
                    },
                  )
                );
              },
            )
          )
        )]
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              return AddCarPage(isar: widget.isar);
            }),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xffddffdd),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          side: BorderSide(color: Colors.black),
        ),
      ),
    );
  }
}