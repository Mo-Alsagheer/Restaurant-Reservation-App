// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FoodCategoryImpl _$$FoodCategoryImplFromJson(Map<String, dynamic> json) =>
    _$FoodCategoryImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      iconUrl: json['iconUrl'] as String?,
    );

Map<String, dynamic> _$$FoodCategoryImplToJson(_$FoodCategoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'iconUrl': instance.iconUrl,
    };
