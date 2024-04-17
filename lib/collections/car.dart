import 'package:isar/isar.dart';

part 'car.g.dart';

@collection
class Car {
  Id id = Isar.autoIncrement;

  String? name;

  String? color;

  String? totalMiles;

  String? year;
}