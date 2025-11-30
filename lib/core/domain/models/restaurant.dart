import 'package:freezed_annotation/freezed_annotation.dart';
import 'location.dart';
import 'time_slot.dart';

part 'restaurant.freezed.dart';
part 'restaurant.g.dart';

@freezed
class Restaurant with _$Restaurant {
  const factory Restaurant({
    required String id,
    required String name,
    required String description,
    String? imageUrl,
    required String foodCategoryId,
    String? foodCategoryName, // Denormalized for display
    required int numberOfTables,
    @Default(6) int maxSeatsPerTable, // Constant max 6 seats
    required Location location,
    @Default([]) List<TimeSlot> timeSlots, // 5 slots per day
    @Default(true) bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? vendorId, // For future vendor authentication
  }) = _Restaurant;

  factory Restaurant.fromJson(Map<String, dynamic> json) =>
      _$RestaurantFromJson(json);
}
