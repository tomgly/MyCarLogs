// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fueling.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetFuelingCollection on Isar {
  IsarCollection<Fueling> get fuelings => this.collection();
}

const FuelingSchema = CollectionSchema(
  name: r'Fueling',
  id: -214611607443245656,
  properties: {
    r'carID': PropertySchema(
      id: 0,
      name: r'carID',
      type: IsarType.long,
    ),
    r'cost': PropertySchema(
      id: 1,
      name: r'cost',
      type: IsarType.string,
    ),
    r'date': PropertySchema(
      id: 2,
      name: r'date',
      type: IsarType.string,
    ),
    r'fuel': PropertySchema(
      id: 3,
      name: r'fuel',
      type: IsarType.string,
    ),
    r'inputMiles': PropertySchema(
      id: 4,
      name: r'inputMiles',
      type: IsarType.string,
    )
  },
  estimateSize: _fuelingEstimateSize,
  serialize: _fuelingSerialize,
  deserialize: _fuelingDeserialize,
  deserializeProp: _fuelingDeserializeProp,
  idName: r'id',
  indexes: {
    r'date': IndexSchema(
      id: -7552997827385218417,
      name: r'date',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'date',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _fuelingGetId,
  getLinks: _fuelingGetLinks,
  attach: _fuelingAttach,
  version: '3.1.0+1',
);

int _fuelingEstimateSize(
  Fueling object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.cost;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.date;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.fuel;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.inputMiles;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _fuelingSerialize(
  Fueling object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.carID);
  writer.writeString(offsets[1], object.cost);
  writer.writeString(offsets[2], object.date);
  writer.writeString(offsets[3], object.fuel);
  writer.writeString(offsets[4], object.inputMiles);
}

Fueling _fuelingDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Fueling();
  object.carID = reader.readLong(offsets[0]);
  object.cost = reader.readStringOrNull(offsets[1]);
  object.date = reader.readStringOrNull(offsets[2]);
  object.fuel = reader.readStringOrNull(offsets[3]);
  object.id = id;
  object.inputMiles = reader.readStringOrNull(offsets[4]);
  return object;
}

P _fuelingDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _fuelingGetId(Fueling object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _fuelingGetLinks(Fueling object) {
  return [];
}

void _fuelingAttach(IsarCollection<dynamic> col, Id id, Fueling object) {
  object.id = id;
}

extension FuelingQueryWhereSort on QueryBuilder<Fueling, Fueling, QWhere> {
  QueryBuilder<Fueling, Fueling, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension FuelingQueryWhere on QueryBuilder<Fueling, Fueling, QWhereClause> {
  QueryBuilder<Fueling, Fueling, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterWhereClause> dateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'date',
        value: [null],
      ));
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterWhereClause> dateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'date',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterWhereClause> dateEqualTo(String? date) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'date',
        value: [date],
      ));
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterWhereClause> dateNotEqualTo(
      String? date) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [],
              upper: [date],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [date],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [date],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [],
              upper: [date],
              includeUpper: false,
            ));
      }
    });
  }
}

extension FuelingQueryFilter
    on QueryBuilder<Fueling, Fueling, QFilterCondition> {
  QueryBuilder<Fueling, Fueling, QAfterFilterCondition> carIDEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'carID',
        value: value,
      ));
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterFilterCondition> carIDGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'carID',
        value: value,
      ));
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterFilterCondition> carIDLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'carID',
        value: value,
      ));
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterFilterCondition> carIDBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'carID',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterFilterCondition> costIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'cost',
      ));
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterFilterCondition> costIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'cost',
      ));
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterFilterCondition> costEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cost',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterFilterCondition> costGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cost',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterFilterCondition> costLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cost',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterFilterCondition> costBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cost',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterFilterCondition> costStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'cost',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterFilterCondition> costEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'cost',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterFilterCondition> costContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'cost',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterFilterCondition> costMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'cost',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterFilterCondition> costIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cost',
        value: '',
      ));
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterFilterCondition> costIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'cost',
        value: '',
      ));
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterFilterCondition> dateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'date',
      ));
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterFilterCondition> dateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'date',
      ));
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterFilterCondition> dateEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterFilterCondition> dateGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterFilterCondition> dateLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterFilterCondition> dateBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'date',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterFilterCondition> dateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterFilterCondition> dateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterFilterCondition> dateContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterFilterCondition> dateMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'date',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterFilterCondition> dateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: '',
      ));
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterFilterCondition> dateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'date',
        value: '',
      ));
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterFilterCondition> fuelIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'fuel',
      ));
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterFilterCondition> fuelIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'fuel',
      ));
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterFilterCondition> fuelEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fuel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterFilterCondition> fuelGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fuel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterFilterCondition> fuelLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fuel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterFilterCondition> fuelBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fuel',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterFilterCondition> fuelStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'fuel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterFilterCondition> fuelEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'fuel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterFilterCondition> fuelContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'fuel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterFilterCondition> fuelMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'fuel',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterFilterCondition> fuelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fuel',
        value: '',
      ));
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterFilterCondition> fuelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'fuel',
        value: '',
      ));
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterFilterCondition> inputMilesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'inputMiles',
      ));
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterFilterCondition> inputMilesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'inputMiles',
      ));
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterFilterCondition> inputMilesEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'inputMiles',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterFilterCondition> inputMilesGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'inputMiles',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterFilterCondition> inputMilesLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'inputMiles',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterFilterCondition> inputMilesBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'inputMiles',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterFilterCondition> inputMilesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'inputMiles',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterFilterCondition> inputMilesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'inputMiles',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterFilterCondition> inputMilesContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'inputMiles',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterFilterCondition> inputMilesMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'inputMiles',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterFilterCondition> inputMilesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'inputMiles',
        value: '',
      ));
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterFilterCondition> inputMilesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'inputMiles',
        value: '',
      ));
    });
  }
}

extension FuelingQueryObject
    on QueryBuilder<Fueling, Fueling, QFilterCondition> {}

extension FuelingQueryLinks
    on QueryBuilder<Fueling, Fueling, QFilterCondition> {}

extension FuelingQuerySortBy on QueryBuilder<Fueling, Fueling, QSortBy> {
  QueryBuilder<Fueling, Fueling, QAfterSortBy> sortByCarID() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carID', Sort.asc);
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterSortBy> sortByCarIDDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carID', Sort.desc);
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterSortBy> sortByCost() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cost', Sort.asc);
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterSortBy> sortByCostDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cost', Sort.desc);
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterSortBy> sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterSortBy> sortByFuel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fuel', Sort.asc);
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterSortBy> sortByFuelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fuel', Sort.desc);
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterSortBy> sortByInputMiles() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inputMiles', Sort.asc);
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterSortBy> sortByInputMilesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inputMiles', Sort.desc);
    });
  }
}

extension FuelingQuerySortThenBy
    on QueryBuilder<Fueling, Fueling, QSortThenBy> {
  QueryBuilder<Fueling, Fueling, QAfterSortBy> thenByCarID() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carID', Sort.asc);
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterSortBy> thenByCarIDDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carID', Sort.desc);
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterSortBy> thenByCost() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cost', Sort.asc);
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterSortBy> thenByCostDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cost', Sort.desc);
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterSortBy> thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterSortBy> thenByFuel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fuel', Sort.asc);
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterSortBy> thenByFuelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fuel', Sort.desc);
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterSortBy> thenByInputMiles() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inputMiles', Sort.asc);
    });
  }

  QueryBuilder<Fueling, Fueling, QAfterSortBy> thenByInputMilesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inputMiles', Sort.desc);
    });
  }
}

extension FuelingQueryWhereDistinct
    on QueryBuilder<Fueling, Fueling, QDistinct> {
  QueryBuilder<Fueling, Fueling, QDistinct> distinctByCarID() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'carID');
    });
  }

  QueryBuilder<Fueling, Fueling, QDistinct> distinctByCost(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cost', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Fueling, Fueling, QDistinct> distinctByDate(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Fueling, Fueling, QDistinct> distinctByFuel(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fuel', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Fueling, Fueling, QDistinct> distinctByInputMiles(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'inputMiles', caseSensitive: caseSensitive);
    });
  }
}

extension FuelingQueryProperty
    on QueryBuilder<Fueling, Fueling, QQueryProperty> {
  QueryBuilder<Fueling, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Fueling, int, QQueryOperations> carIDProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'carID');
    });
  }

  QueryBuilder<Fueling, String?, QQueryOperations> costProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cost');
    });
  }

  QueryBuilder<Fueling, String?, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<Fueling, String?, QQueryOperations> fuelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fuel');
    });
  }

  QueryBuilder<Fueling, String?, QQueryOperations> inputMilesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'inputMiles');
    });
  }
}
