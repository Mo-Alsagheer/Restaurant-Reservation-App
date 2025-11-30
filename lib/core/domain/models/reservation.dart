import 'package:freezed_annotation/freezed_annotation.dart';

part 'reservation.freezed.dart';
part 'reservation.g.dart';

enum ReservationStatus { pending, confirmed, cancelled, completed, noShow }

@freezed
class Reservation with _$Reservation {
  const factory Reservation({
    required String id,
    required String restaurantId,
    required String tableId,
    required String customerId,
    String? customerName, // Denormalized for display
    String? customerPhone,
    required DateTime reservationDate,
    required String timeSlot, // e.g., "10:00"
    required int partySize, // Number of seats requested (max 6)
    @Default(ReservationStatus.pending) ReservationStatus status,
    String? specialRequests,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Reservation;

  factory Reservation.fromJson(Map<String, dynamic> json) =>
      _$ReservationFromJson(json);
}
