import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'main.dart';
import '../collections/car.dart';
import '../collections/input.dart';

class SettingPage extends StatefulWidget {
  final Isar isar;

  SettingPage({required this.isar});

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setting', style: TextStyle(color: Colors.black, fontSize: 25)),
        backgroundColor: Colors.green,
      ),
      body: Container(
        padding: EdgeInsets.all(64),
        child: Container(
            width: double.infinity,
            child: TextButton(
              onPressed: () {
                showDialog(context: context, builder: (context) {
                  return AlertDialog(
                    title: Text('Are you sure to delete ALL CARS?'),
                    actions: <Widget>[
                      GestureDetector(
                        child: Text('DELETE', style: TextStyle(color: Colors.red)),
                        onTap: () async {
                          await widget.isar.writeTxn(() async {
                            await widget.isar.cars.where().deleteAll();
                            await widget.isar.fuelings.where().deleteAll();
                            await widget.isar.maintenances.where().deleteAll();
                            await widget.isar.repairs.where().deleteAll();
                          });
                          Navigator.pushAndRemoveUntil( context,
                              MaterialPageRoute(builder: (context) => MyApp(isar: widget.isar)),
                                  (_) => false
                          );
                        },
                      ),
                      GestureDetector(
                        child: Text('Cancel'),
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  );
                });
              },
              child: Text('Delete All Cars', style: TextStyle(color: Colors.red),
              ),
            )
        ),
      ),
    );
  }
}