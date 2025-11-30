import '../../domain/models/reservation.dart';
import '../firestore/reservation_firestore_data_source.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReservationRepository {
  final ReservationFirestoreDataSource _dataSource;
  final FirebaseFirestore _firestore;

  ReservationRepository({
    ReservationFirestoreDataSource? dataSource,
    FirebaseFirestore? firestore,
  }) : _dataSource = dataSource ?? ReservationFirestoreDataSource(),
       _firestore = firestore ?? FirebaseFirestore.instance;

  /// Create a reservation with double-booking prevention
  Future<String> createReservation(Reservation reservation) async {
    // Use a transaction to check for conflicts and create the reservation atomically
    return await _firestore.runTransaction<String>((transaction) async {
      // Check for conflicting reservations
      final conflicts = await _dataSource.getConflictingReservations(
        restaurantId: reservation.restaurantId,
        tableId: reservation.tableId,
        date: reservation.reservationDate,
        timeSlot: reservation.timeSlot,
      );

      if (conflicts.isNotEmpty) {
        throw Exception(
          'This table is already booked for the selected time slot',
        );
      }

      // No conflicts, create the reservation
      return await _dataSource.createReservation(reservation);
    });
  }

  Future<void> updateReservation(Reservation reservation) async {
    await _dataSource.updateReservation(reservation);
  }

  Future<Reservation?> getReservation(String id) async {
    return await _dataSource.getReservation(id);
  }

  Stream<List<Reservation>> watchRestaurantReservations(String restaurantId) {
    return _dataSource.watchRestaurantReservations(restaurantId);
  }

  Future<List<Reservation>> getReservationsByDate(
    String restaurantId,
    DateTime date,
  ) async {
    return await _dataSource.getReservationsByDate(restaurantId, date);
  }

  Stream<List<Reservation>> watchCustomerReservations(String customerId) {
    return _dataSource.watchCustomerReservations(customerId);
  }

  Future<void> cancelReservation(String id) async {
    await _dataSource.cancelReservation(id);
  }
}
