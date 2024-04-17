import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
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
        title: Text('MyCarLog', style: TextStyle(color: Colors.black, fontSize: 25)),
        backgroundColor: Colors.green,
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) {
                  return SettingPage();
                }),
              );
            },
            icon: Icon(Icons.settings, color: Colors.black),
          )
        ],
      ),
      body: Column(
        children: [ Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              await loadData();
            },
            child: Card(child: ListView.separated(
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: cars.length,
              padding: const EdgeInsets.all(15),
              itemBuilder: (BuildContext context, int index) {
                final car = cars[index];
                return ListTile(
                  title: Text(car.name ?? "No Name", style: TextStyle(color: Colors.black)),
                  subtitle: Text("Color: " + (car.color ?? "No Color") + ", Year: " + (car.year ?? "No Year")),
                  tileColor: Color(0xffddffdd),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                  ),
                  onTap: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) {
                        return DetailPage(isar: widget.isar, car: car);
                      }),
                    );
                  },
                );
              },
              separatorBuilder: (BuildContext context,
                  int index) => const Divider(),
            ))
          ))
        ]
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
        backgroundColor: Colors.green,
      ),
    );
  }
}