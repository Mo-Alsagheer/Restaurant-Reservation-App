// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'restaurant.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Restaurant _$RestaurantFromJson(Map<String, dynamic> json) {
  return _Restaurant.fromJson(json);
}

/// @nodoc
mixin _$Restaurant {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  String get foodCategoryId => throw _privateConstructorUsedError;
  String? get foodCategoryName =>
      throw _privateConstructorUsedError; // Denormalized for display
  int get numberOfTables => throw _privateConstructorUsedError;
  int get maxSeatsPerTable =>
      throw _privateConstructorUsedError; // Constant max 6 seats
  Location get location => throw _privateConstructorUsedError;
  List<TimeSlot> get timeSlots =>
      throw _privateConstructorUsedError; // 5 slots per day
  bool get isActive => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  String? get vendorId => throw _privateConstructorUsedError;

  /// Serializes this Restaurant to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Restaurant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RestaurantCopyWith<Restaurant> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RestaurantCopyWith<$Res> {
  factory $RestaurantCopyWith(
    Restaurant value,
    $Res Function(Restaurant) then,
  ) = _$RestaurantCopyWithImpl<$Res, Restaurant>;
  @useResult
  $Res call({
    String id,
    String name,
    String description,
    String? imageUrl,
    String foodCategoryId,
    String? foodCategoryName,
    int numberOfTables,
    int maxSeatsPerTable,
    Location location,
    List<TimeSlot> timeSlots,
    bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? vendorId,
  });

  $LocationCopyWith<$Res> get location;
}

/// @nodoc
class _$RestaurantCopyWithImpl<$Res, $Val extends Restaurant>
    implements $RestaurantCopyWith<$Res> {
  _$RestaurantCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Restaurant
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? imageUrl = freezed,
    Object? foodCategoryId = null,
    Object? foodCategoryName = freezed,
    Object? numberOfTables = null,
    Object? maxSeatsPerTable = null,
    Object? location = null,
    Object? timeSlots = null,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? vendorId = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            imageUrl: freezed == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            foodCategoryId: null == foodCategoryId
                ? _value.foodCategoryId
                : foodCategoryId // ignore: cast_nullable_to_non_nullable
                      as String,
            foodCategoryName: freezed == foodCategoryName
                ? _value.foodCategoryName
                : foodCategoryName // ignore: cast_nullable_to_non_nullable
                      as String?,
            numberOfTables: null == numberOfTables
                ? _value.numberOfTables
                : numberOfTables // ignore: cast_nullable_to_non_nullable
                      as int,
            maxSeatsPerTable: null == maxSeatsPerTable
                ? _value.maxSeatsPerTable
                : maxSeatsPerTable // ignore: cast_nullable_to_non_nullable
                      as int,
            location: null == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as Location,
            timeSlots: null == timeSlots
                ? _value.timeSlots
                : timeSlots // ignore: cast_nullable_to_non_nullable
                      as List<TimeSlot>,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            vendorId: freezed == vendorId
                ? _value.vendorId
                : vendorId // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of Restaurant
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LocationCopyWith<$Res> get location {
    return $LocationCopyWith<$Res>(_value.location, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RestaurantImplCopyWith<$Res>
    implements $RestaurantCopyWith<$Res> {
  factory _$$RestaurantImplCopyWith(
    _$RestaurantImpl value,
    $Res Function(_$RestaurantImpl) then,
  ) = __$$RestaurantImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String description,
    String? imageUrl,
    String foodCategoryId,
    String? foodCategoryName,
    int numberOfTables,
    int maxSeatsPerTable,
    Location location,
    List<TimeSlot> timeSlots,
    bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? vendorId,
  });

  @override
  $LocationCopyWith<$Res> get location;
}

/// @nodoc
class __$$RestaurantImplCopyWithImpl<$Res>
    extends _$RestaurantCopyWithImpl<$Res, _$RestaurantImpl>
    implements _$$RestaurantImplCopyWith<$Res> {
  __$$RestaurantImplCopyWithImpl(
    _$RestaurantImpl _value,
    $Res Function(_$RestaurantImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Restaurant
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? imageUrl = freezed,
    Object? foodCategoryId = null,
    Object? foodCategoryName = freezed,
    Object? numberOfTables = null,
    Object? maxSeatsPerTable = null,
    Object? location = null,
    Object? timeSlots = null,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? vendorId = freezed,
  }) {
    return _then(
      _$RestaurantImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        imageUrl: freezed == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        foodCategoryId: null == foodCategoryId
            ? _value.foodCategoryId
            : foodCategoryId // ignore: cast_nullable_to_non_nullable
                  as String,
        foodCategoryName: freezed == foodCategoryName
            ? _value.foodCategoryName
            : foodCategoryName // ignore: cast_nullable_to_non_nullable
                  as String?,
        numberOfTables: null == numberOfTables
            ? _value.numberOfTables
            : numberOfTables // ignore: cast_nullable_to_non_nullable
                  as int,
        maxSeatsPerTable: null == maxSeatsPerTable
            ? _value.maxSeatsPerTable
            : maxSeatsPerTable // ignore: cast_nullable_to_non_nullable
                  as int,
        location: null == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as Location,
        timeSlots: null == timeSlots
            ? _value._timeSlots
            : timeSlots // ignore: cast_nullable_to_non_nullable
                  as List<TimeSlot>,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        vendorId: freezed == vendorId
            ? _value.vendorId
            : vendorId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RestaurantImpl implements _Restaurant {
  const _$RestaurantImpl({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
    required this.foodCategoryId,
    this.foodCategoryName,
    required this.numberOfTables,
    this.maxSeatsPerTable = 6,
    required this.location,
    final List<TimeSlot> timeSlots = const [],
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
    this.vendorId,
  }) : _timeSlots = timeSlots;

  factory _$RestaurantImpl.fromJson(Map<String, dynamic> json) =>
      _$$RestaurantImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String description;
  @override
  final String? imageUrl;
  @override
  final String foodCategoryId;
  @override
  final String? foodCategoryName;
  // Denormalized for display
  @override
  final int numberOfTables;
  @override
  @JsonKey()
  final int maxSeatsPerTable;
  // Constant max 6 seats
  @override
  final Location location;
  final List<TimeSlot> _timeSlots;
  @override
  @JsonKey()
  List<TimeSlot> get timeSlots {
    if (_timeSlots is EqualUnmodifiableListView) return _timeSlots;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_timeSlots);
  }

  // 5 slots per day
  @override
  @JsonKey()
  final bool isActive;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final String? vendorId;

  @override
  String toString() {
    return 'Restaurant(id: $id, name: $name, description: $description, imageUrl: $imageUrl, foodCategoryId: $foodCategoryId, foodCategoryName: $foodCategoryName, numberOfTables: $numberOfTables, maxSeatsPerTable: $maxSeatsPerTable, location: $location, timeSlots: $timeSlots, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt, vendorId: $vendorId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RestaurantImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.foodCategoryId, foodCategoryId) ||
                other.foodCategoryId == foodCategoryId) &&
            (identical(other.foodCategoryName, foodCategoryName) ||
                other.foodCategoryName == foodCategoryName) &&
            (identical(other.numberOfTables, numberOfTables) ||
                other.numberOfTables == numberOfTables) &&
            (identical(other.maxSeatsPerTable, maxSeatsPerTable) ||
                other.maxSeatsPerTable == maxSeatsPerTable) &&
            (identical(other.location, location) ||
                other.location == location) &&
            const DeepCollectionEquality().equals(
              other._timeSlots,
              _timeSlots,
            ) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.vendorId, vendorId) ||
                other.vendorId == vendorId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    description,
    imageUrl,
    foodCategoryId,
    foodCategoryName,
    numberOfTables,
    maxSeatsPerTable,
    location,
    const DeepCollectionEquality().hash(_timeSlots),
    isActive,
    createdAt,
    updatedAt,
    vendorId,
  );

  /// Create a copy of Restaurant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RestaurantImplCopyWith<_$RestaurantImpl> get copyWith =>
      __$$RestaurantImplCopyWithImpl<_$RestaurantImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RestaurantImplToJson(this);
  }
}

abstract class _Restaurant implements Restaurant {
  const factory _Restaurant({
    required final String id,
    required final String name,
    required final String description,
    final String? imageUrl,
    required final String foodCategoryId,
    final String? foodCategoryName,
    required final int numberOfTables,
    final int maxSeatsPerTable,
    required final Location location,
    final List<TimeSlot> timeSlots,
    final bool isActive,
    final DateTime? createdAt,
    final DateTime? updatedAt,
    final String? vendorId,
  }) = _$RestaurantImpl;

  factory _Restaurant.fromJson(Map<String, dynamic> json) =
      _$RestaurantImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get description;
  @override
  String? get imageUrl;
  @override
  String get foodCategoryId;
  @override
  String? get foodCategoryName; // Denormalized for display
  @override
  int get numberOfTables;
  @override
  int get maxSeatsPerTable; // Constant max 6 seats
  @override
  Location get location;
  @override
  List<TimeSlot> get timeSlots; // 5 slots per day
  @override
  bool get isActive;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  String? get vendorId;

  /// Create a copy of Restaurant
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RestaurantImplCopyWith<_$RestaurantImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
