import 'package:isar/isar.dart';

part 'fueling.g.dart';

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
