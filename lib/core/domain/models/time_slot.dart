import 'package:freezed_annotation/freezed_annotation.dart';

part 'time_slot.freezed.dart';
part 'time_slot.g.dart';

@freezed
class TimeSlot with _$TimeSlot {
  const factory TimeSlot({
    required String id,
    required String time, // Format: "10:00", "10:30", etc.
    @Default(true) bool isAvailable,
  }) = _TimeSlot;

  factory TimeSlot.fromJson(Map<String, dynamic> json) =>
      _$TimeSlotFromJson(json);
}
