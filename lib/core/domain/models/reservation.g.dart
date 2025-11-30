// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReservationImpl _$$ReservationImplFromJson(Map<String, dynamic> json) =>
    _$ReservationImpl(
      id: json['id'] as String,
      restaurantId: json['restaurantId'] as String,
      tableId: json['tableId'] as String,
      customerId: json['customerId'] as String,
      customerName: json['customerName'] as String?,
      customerPhone: json['customerPhone'] as String?,
      reservationDate: DateTime.parse(json['reservationDate'] as String),
      timeSlot: json['timeSlot'] as String,
      partySize: (json['partySize'] as num).toInt(),
      status:
          $enumDecodeNullable(_$ReservationStatusEnumMap, json['status']) ??
          ReservationStatus.pending,
      specialRequests: json['specialRequests'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ReservationImplToJson(_$ReservationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'restaurantId': instance.restaurantId,
      'tableId': instance.tableId,
      'customerId': instance.customerId,
      'customerName': instance.customerName,
      'customerPhone': instance.customerPhone,
      'reservationDate': instance.reservationDate.toIso8601String(),
      'timeSlot': instance.timeSlot,
      'partySize': instance.partySize,
      'status': _$ReservationStatusEnumMap[instance.status]!,
      'specialRequests': instance.specialRequests,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$ReservationStatusEnumMap = {
  ReservationStatus.pending: 'pending',
  ReservationStatus.confirmed: 'confirmed',
  ReservationStatus.cancelled: 'cancelled',
  ReservationStatus.completed: 'completed',
  ReservationStatus.noShow: 'noShow',
};
