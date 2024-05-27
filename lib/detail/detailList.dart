import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'detailEdit.dart';
import '../collections/car.dart';
import '../collections/input.dart';

class DetailListPage extends StatefulWidget {
  final Isar isar;
  final Car car;
  final int type;

  DetailListPage({required this.isar, required this.car, required this.type});

  @override
  _DetailListPageState createState() => _DetailListPageState();
}

class _DetailListPageState extends State<DetailListPage> {
  late Car car;
  List<Fueling> fuelings = [];
  List<Maintenance> maintes = [];
  List<Repair> repairs = [];
  Color themeColor = Colors.green;

  @override
  void initState() {
    super.initState();
    car = widget.car;
    getSetting();
  }
  Future<void> getSetting() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      themeColor = Color(prefs.getInt('themeColor') ?? Color(0xFF4CAF50).value);
    });
  }

  Future<void> loadData() async {
    final carData = await widget.isar.cars.get(car.id);
    final fuelingData = await widget.isar.fuelings.filter().carIDEqualTo(car.id).sortByDateDesc().findAll();
    final mainteData = await widget.isar.maintenances.filter().carIDEqualTo(car.id).sortByDateDesc().findAll();
    final repairData = await widget.isar.repairs.filter().carIDEqualTo(car.id).sortByDateDesc().findAll();

    setState(() {
      car = carData as Car;
      fuelings = fuelingData.cast<Fueling>();
      maintes = mainteData.cast<Maintenance>();
      repairs = repairData.cast<Repair>();
    });
  }

  mainTitle() {
    if (widget.type == 0) {
      return Text('Fueling Logs (' + fuelings.length.toString() + ')', style: TextStyle(color: Colors.black, fontSize: 25));;
    } else if (widget.type == 1) {
      return Text('Maintenance Logs (' + maintes.length.toString() + ')', style: TextStyle(color: Colors.black, fontSize: 25));
    } else if (widget.type == 2) {
      return Text('Repair Logs (' + repairs.length.toString() + ')', style: TextStyle(color: Colors.black, fontSize: 25));
    }
  }

  int count() {
    if (widget.type == 0) {
      return fuelings.length;
    } else if (widget.type == 1) {
      return maintes.length;
    } else if (widget.type == 2) {
      return repairs.length;
    }
    return 0;
  }

  delete(int index) {
    if (widget.type == 0) {
      widget.isar.fuelings.delete(fuelings[index].id);
    } else if (widget.type == 1) {
      widget.isar.maintenances.delete(maintes[index].id);
    } else if (widget.type == 2) {
      widget.isar.repairs.delete(repairs[index].id);
    }
  }

  tileTitle(int index) {
    if (widget.type == 0) {
      return Text('Fuel: ' + (fuelings[index].fuel) + ', Cost: \$' + (fuelings[index].cost),
          style: TextStyle(color: Colors.black));
    } else if (widget.type == 1) {
      return Text('Description: ' + (maintes[index].desc) + ', Cost: \$' + (maintes[index].cost),
          style: TextStyle(color: Colors.black));
    } else if (widget.type == 2) {
      return Text('Repair: ' + (repairs[index].repair) + ', Cost: \$' + (repairs[index].cost),
          style: TextStyle(color: Colors.black));
    }
  }

  tileSubtitle(int index) {
    if (widget.type == 0) {
      return Text('Date: ' + (fuelings[index].date));
    } else if (widget.type == 1) {
      return Text('Date: ' + (maintes[index].date));
    } else if (widget.type == 2) {
      return Text('Date: ' + (repairs[index].date));
    }
  }

  tileColor() {
    if (widget.type == 0) {
      return Color(0xffffdad3);
    } else if (widget.type == 1) {
      return Color(0xffd3def1);
    } else if (widget.type == 2) {
      return Color(0xfffff1ab);
    }
  }

  trailing(int index) {
    if (widget.type == 0) {
      return Text((fuelings[index].aveFuel.toStringAsFixed(2)) + ' mpg',
          style: TextStyle(fontSize: 15),
    );
    } else {
      return null;
    }
  }
  
  returnDetail(int index) {
    if (widget.type == 0) {
      return fuelings[index];
    } else if (widget.type == 1) {
      return maintes[index];
    } else if (widget.type == 2) {
      return repairs[index];
    }
  }

  @override
  Widget build(BuildContext context) {
    loadData();
    return Scaffold(
      appBar: AppBar(
        title: mainTitle(),
        backgroundColor: themeColor,
      ),
      body: Column(
        children: [ Expanded(
          child: Card(
            child: ListView.separated(
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: count(),
              padding: const EdgeInsets.all(15),
              separatorBuilder: (BuildContext context, int index) => const Divider(),
              itemBuilder: (BuildContext context, int index) {
                return Slidable(
                key: const ValueKey(0),
                endActionPane: ActionPane(
                  extentRatio: 0.4,
                  motion: const StretchMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (_) async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => DetailEditPage(isar: widget.isar, type: widget.type, detail: returnDetail(index)),
                          ),
                        );
                      },
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                      icon: Icons.more,
                    ),
                    SlidableAction(
                      onPressed: (_) async {
                        await widget.isar.writeTxn(() async {
                          delete(index);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Deleted'))
                        );
                      },
                      backgroundColor: Colors.red.shade500,
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                    ),
                  ],
                ),
                child: ListTile(
                  title: tileTitle(index),
                  subtitle: tileSubtitle(index),
                  tileColor: tileColor(),
                  trailing: trailing(index),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    side: BorderSide(color: Colors.black),
                  ),
                )
              );},
            )
          )
        )]
      ),
    );
  }
}