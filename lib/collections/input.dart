import 'package:isar/isar.dart';

part 'input.g.dart';

@collection
class Fueling {
  Id id = Isar.autoIncrement;

  late int carID;

  late String? fuel;

  late String? cost;

  late String? inputMiles;

  @Index()
  late String? date;
}

@collection
class Maintenance {
  Id id = Isar.autoIncrement;

  late int carID;

  late String? desc;

  late String? cost;

  @Index()
  late String? date;
}

@collection
class Repair {
  Id id = Isar.autoIncrement;

  late int carID;

  late String? repair;

  late String? cost;

  @Index()
  late String? date;
}
