import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'detailEdit.dart';
import '../collections/car.dart';
import '../collections/input.dart';
import '../setting.dart';

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
  late Color themeColor;
  late String distUnit;
  late String capUnit;
  late String aveFuelSym;
  late String currencySymbol;

  @override
  void initState() {
    super.initState();
    car = widget.car;
    themeColor = UserPreferences.getThemeColor();
    distUnit = UserPreferences.getDistUnit();
    capUnit = UserPreferences.getCapUnit();
    aveFuelSym = UserPreferences.getAveFuel();
    currencySymbol = UserPreferences.getCurrencySymbol();
  }

  Future<void> _loadData() async {
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

  _mainTitle() {
    if (widget.type == 0) {
      return Text(AppLocalizations.of(context)!.fuelingLogs + ' (' + fuelings.length.toString() + ')', style: TextStyle(color: Colors.black, fontSize: 25));;
    } else if (widget.type == 1) {
      return Text(AppLocalizations.of(context)!.maintenanceLogs + ' (' + maintes.length.toString() + ')', style: TextStyle(color: Colors.black, fontSize: 25));
    } else if (widget.type == 2) {
      return Text(AppLocalizations.of(context)!.repairLogs + ' (' + repairs.length.toString() + ')', style: TextStyle(color: Colors.black, fontSize: 25));
    }
  }

  int _count() {
    if (widget.type == 0) {
      return fuelings.length;
    } else if (widget.type == 1) {
      return maintes.length;
    } else if (widget.type == 2) {
      return repairs.length;
    }
    return 0;
  }

  _deleteData(int index) {
    if (widget.type == 0) {
      widget.isar.fuelings.delete(fuelings[index].id);
    } else if (widget.type == 1) {
      widget.isar.maintenances.delete(maintes[index].id);
    } else if (widget.type == 2) {
      widget.isar.repairs.delete(repairs[index].id);
    }
  }

  _tileTitle(int index) {
    final String cost = AppLocalizations.of(context)!.cost + ': ' + currencySymbol;
    if (widget.type == 0) {
      return Text(AppLocalizations.of(context)!.fuelAmount + ': ' + (fuelings[index].fuel) + capUnit + ', ' +
          cost + (fuelings[index].cost), style: TextStyle(color: Colors.black)
      );
    } else if (widget.type == 1) {
      return Text(AppLocalizations.of(context)!.description + ': ' + (maintes[index].desc) + ', ' +
          cost + (maintes[index].cost), style: TextStyle(color: Colors.black)
      );
    } else if (widget.type == 2) {
      return Text(AppLocalizations.of(context)!.repair + ': ' + (repairs[index].repair) + ', ' +
          cost + (repairs[index].cost), style: TextStyle(color: Colors.black)
      );
    }
  }

  _tileSubtitle(int index) {
    final String date = AppLocalizations.of(context)!.date + ': ';
    if (widget.type == 0) {
      return Text(date + (fuelings[index].date));
    } else if (widget.type == 1) {
      return Text(date + (maintes[index].date));
    } else if (widget.type == 2) {
      return Text(date + (repairs[index].date));
    }
  }

  _tileColor() {
    if (widget.type == 0) {
      return Color(0xffffdad3);
    } else if (widget.type == 1) {
      return Color(0xffd3def1);
    } else if (widget.type == 2) {
      return Color(0xfffff1ab);
    }
  }

  _trailing(int index) {
    if (widget.type == 0) {
      return Text((fuelings[index].aveFuel.toStringAsFixed(2)) + ' ' + aveFuelSym, style: TextStyle(fontSize: 15));
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
    _loadData();
    return Scaffold(
      appBar: AppBar(
        title: _mainTitle(),
        backgroundColor: themeColor,
      ),
      body: Column(
        children: [ Expanded(
          child: Card(
            child: ListView.separated(
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: _count(),
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
                          _deleteData(index);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(AppLocalizations.of(context)!.deleted))
                        );
                      },
                      backgroundColor: Colors.red.shade500,
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                    ),
                  ],
                ),
                child: ListTile(
                  title: _tileTitle(index),
                  subtitle: _tileSubtitle(index),
                  tileColor: _tileColor(),
                  trailing: _trailing(index),
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