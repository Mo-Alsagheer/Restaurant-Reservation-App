// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RestaurantImpl _$$RestaurantImplFromJson(Map<String, dynamic> json) =>
    _$RestaurantImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String?,
      foodCategoryId: json['foodCategoryId'] as String,
      foodCategoryName: json['foodCategoryName'] as String?,
      numberOfTables: (json['numberOfTables'] as num).toInt(),
      maxSeatsPerTable: (json['maxSeatsPerTable'] as num?)?.toInt() ?? 6,
      location: Location.fromJson(json['location'] as Map<String, dynamic>),
      timeSlots:
          (json['timeSlots'] as List<dynamic>?)
              ?.map((e) => TimeSlot.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      vendorId: json['vendorId'] as String?,
    );

Map<String, dynamic> _$$RestaurantImplToJson(_$RestaurantImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'foodCategoryId': instance.foodCategoryId,
      'foodCategoryName': instance.foodCategoryName,
      'numberOfTables': instance.numberOfTables,
      'maxSeatsPerTable': instance.maxSeatsPerTable,
      'location': instance.location,
      'timeSlots': instance.timeSlots,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'vendorId': instance.vendorId,
    };
