// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TableModelImpl _$$TableModelImplFromJson(Map<String, dynamic> json) =>
    _$TableModelImpl(
      id: json['id'] as String,
      tableNumber: (json['tableNumber'] as num).toInt(),
      capacity: (json['capacity'] as num).toInt(),
      isActive: json['isActive'] as bool? ?? true,
      area: json['area'] as String?,
    );

Map<String, dynamic> _$$TableModelImplToJson(_$TableModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tableNumber': instance.tableNumber,
      'capacity': instance.capacity,
      'isActive': instance.isActive,
      'area': instance.area,
    };
