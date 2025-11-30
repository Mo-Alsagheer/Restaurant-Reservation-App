// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reservation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Reservation _$ReservationFromJson(Map<String, dynamic> json) {
  return _Reservation.fromJson(json);
}

/// @nodoc
mixin _$Reservation {
  String get id => throw _privateConstructorUsedError;
  String get restaurantId => throw _privateConstructorUsedError;
  String get tableId => throw _privateConstructorUsedError;
  String get customerId => throw _privateConstructorUsedError;
  String? get customerName =>
      throw _privateConstructorUsedError; // Denormalized for display
  String? get customerPhone => throw _privateConstructorUsedError;
  DateTime get reservationDate => throw _privateConstructorUsedError;
  String get timeSlot => throw _privateConstructorUsedError; // e.g., "10:00"
  int get partySize =>
      throw _privateConstructorUsedError; // Number of seats requested (max 6)
  ReservationStatus get status => throw _privateConstructorUsedError;
  String? get specialRequests => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Reservation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Reservation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReservationCopyWith<Reservation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReservationCopyWith<$Res> {
  factory $ReservationCopyWith(
    Reservation value,
    $Res Function(Reservation) then,
  ) = _$ReservationCopyWithImpl<$Res, Reservation>;
  @useResult
  $Res call({
    String id,
    String restaurantId,
    String tableId,
    String customerId,
    String? customerName,
    String? customerPhone,
    DateTime reservationDate,
    String timeSlot,
    int partySize,
    ReservationStatus status,
    String? specialRequests,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$ReservationCopyWithImpl<$Res, $Val extends Reservation>
    implements $ReservationCopyWith<$Res> {
  _$ReservationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Reservation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? restaurantId = null,
    Object? tableId = null,
    Object? customerId = null,
    Object? customerName = freezed,
    Object? customerPhone = freezed,
    Object? reservationDate = null,
    Object? timeSlot = null,
    Object? partySize = null,
    Object? status = null,
    Object? specialRequests = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            restaurantId: null == restaurantId
                ? _value.restaurantId
                : restaurantId // ignore: cast_nullable_to_non_nullable
                      as String,
            tableId: null == tableId
                ? _value.tableId
                : tableId // ignore: cast_nullable_to_non_nullable
                      as String,
            customerId: null == customerId
                ? _value.customerId
                : customerId // ignore: cast_nullable_to_non_nullable
                      as String,
            customerName: freezed == customerName
                ? _value.customerName
                : customerName // ignore: cast_nullable_to_non_nullable
                      as String?,
            customerPhone: freezed == customerPhone
                ? _value.customerPhone
                : customerPhone // ignore: cast_nullable_to_non_nullable
                      as String?,
            reservationDate: null == reservationDate
                ? _value.reservationDate
                : reservationDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            timeSlot: null == timeSlot
                ? _value.timeSlot
                : timeSlot // ignore: cast_nullable_to_non_nullable
                      as String,
            partySize: null == partySize
                ? _value.partySize
                : partySize // ignore: cast_nullable_to_non_nullable
                      as int,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as ReservationStatus,
            specialRequests: freezed == specialRequests
                ? _value.specialRequests
                : specialRequests // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ReservationImplCopyWith<$Res>
    implements $ReservationCopyWith<$Res> {
  factory _$$ReservationImplCopyWith(
    _$ReservationImpl value,
    $Res Function(_$ReservationImpl) then,
  ) = __$$ReservationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String restaurantId,
    String tableId,
    String customerId,
    String? customerName,
    String? customerPhone,
    DateTime reservationDate,
    String timeSlot,
    int partySize,
    ReservationStatus status,
    String? specialRequests,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$ReservationImplCopyWithImpl<$Res>
    extends _$ReservationCopyWithImpl<$Res, _$ReservationImpl>
    implements _$$ReservationImplCopyWith<$Res> {
  __$$ReservationImplCopyWithImpl(
    _$ReservationImpl _value,
    $Res Function(_$ReservationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Reservation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? restaurantId = null,
    Object? tableId = null,
    Object? customerId = null,
    Object? customerName = freezed,
    Object? customerPhone = freezed,
    Object? reservationDate = null,
    Object? timeSlot = null,
    Object? partySize = null,
    Object? status = null,
    Object? specialRequests = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$ReservationImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        restaurantId: null == restaurantId
            ? _value.restaurantId
            : restaurantId // ignore: cast_nullable_to_non_nullable
                  as String,
        tableId: null == tableId
            ? _value.tableId
            : tableId // ignore: cast_nullable_to_non_nullable
                  as String,
        customerId: null == customerId
            ? _value.customerId
            : customerId // ignore: cast_nullable_to_non_nullable
                  as String,
        customerName: freezed == customerName
            ? _value.customerName
            : customerName // ignore: cast_nullable_to_non_nullable
                  as String?,
        customerPhone: freezed == customerPhone
            ? _value.customerPhone
            : customerPhone // ignore: cast_nullable_to_non_nullable
                  as String?,
        reservationDate: null == reservationDate
            ? _value.reservationDate
            : reservationDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        timeSlot: null == timeSlot
            ? _value.timeSlot
            : timeSlot // ignore: cast_nullable_to_non_nullable
                  as String,
        partySize: null == partySize
            ? _value.partySize
            : partySize // ignore: cast_nullable_to_non_nullable
                  as int,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as ReservationStatus,
        specialRequests: freezed == specialRequests
            ? _value.specialRequests
            : specialRequests // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ReservationImpl implements _Reservation {
  const _$ReservationImpl({
    required this.id,
    required this.restaurantId,
    required this.tableId,
    required this.customerId,
    this.customerName,
    this.customerPhone,
    required this.reservationDate,
    required this.timeSlot,
    required this.partySize,
    this.status = ReservationStatus.pending,
    this.specialRequests,
    this.createdAt,
    this.updatedAt,
  });

  factory _$ReservationImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReservationImplFromJson(json);

  @override
  final String id;
  @override
  final String restaurantId;
  @override
  final String tableId;
  @override
  final String customerId;
  @override
  final String? customerName;
  // Denormalized for display
  @override
  final String? customerPhone;
  @override
  final DateTime reservationDate;
  @override
  final String timeSlot;
  // e.g., "10:00"
  @override
  final int partySize;
  // Number of seats requested (max 6)
  @override
  @JsonKey()
  final ReservationStatus status;
  @override
  final String? specialRequests;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Reservation(id: $id, restaurantId: $restaurantId, tableId: $tableId, customerId: $customerId, customerName: $customerName, customerPhone: $customerPhone, reservationDate: $reservationDate, timeSlot: $timeSlot, partySize: $partySize, status: $status, specialRequests: $specialRequests, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReservationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.restaurantId, restaurantId) ||
                other.restaurantId == restaurantId) &&
            (identical(other.tableId, tableId) || other.tableId == tableId) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.customerPhone, customerPhone) ||
                other.customerPhone == customerPhone) &&
            (identical(other.reservationDate, reservationDate) ||
                other.reservationDate == reservationDate) &&
            (identical(other.timeSlot, timeSlot) ||
                other.timeSlot == timeSlot) &&
            (identical(other.partySize, partySize) ||
                other.partySize == partySize) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.specialRequests, specialRequests) ||
                other.specialRequests == specialRequests) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    restaurantId,
    tableId,
    customerId,
    customerName,
    customerPhone,
    reservationDate,
    timeSlot,
    partySize,
    status,
    specialRequests,
    createdAt,
    updatedAt,
  );

  /// Create a copy of Reservation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReservationImplCopyWith<_$ReservationImpl> get copyWith =>
      __$$ReservationImplCopyWithImpl<_$ReservationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReservationImplToJson(this);
  }
}

abstract class _Reservation implements Reservation {
  const factory _Reservation({
    required final String id,
    required final String restaurantId,
    required final String tableId,
    required final String customerId,
    final String? customerName,
    final String? customerPhone,
    required final DateTime reservationDate,
    required final String timeSlot,
    required final int partySize,
    final ReservationStatus status,
    final String? specialRequests,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$ReservationImpl;

  factory _Reservation.fromJson(Map<String, dynamic> json) =
      _$ReservationImpl.fromJson;

  @override
  String get id;
  @override
  String get restaurantId;
  @override
  String get tableId;
  @override
  String get customerId;
  @override
  String? get customerName; // Denormalized for display
  @override
  String? get customerPhone;
  @override
  DateTime get reservationDate;
  @override
  String get timeSlot; // e.g., "10:00"
  @override
  int get partySize; // Number of seats requested (max 6)
  @override
  ReservationStatus get status;
  @override
  String? get specialRequests;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of Reservation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReservationImplCopyWith<_$ReservationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
