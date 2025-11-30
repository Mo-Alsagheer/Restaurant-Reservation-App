// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'time_slot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TimeSlotImpl _$$TimeSlotImplFromJson(Map<String, dynamic> json) =>
    _$TimeSlotImpl(
      id: json['id'] as String,
      time: json['time'] as String,
      isAvailable: json['isAvailable'] as bool? ?? true,
    );

Map<String, dynamic> _$$TimeSlotImplToJson(_$TimeSlotImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'time': instance.time,
      'isAvailable': instance.isAvailable,
    };
