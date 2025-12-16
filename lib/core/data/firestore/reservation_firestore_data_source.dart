import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/reservation.dart';

class ReservationFirestoreDataSource {
  final FirebaseFirestore _firestore;

  ReservationFirestoreDataSource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _reservationsCollection =>
      _firestore.collection('reservations');

  // Create a new reservation with conflict check
  Future<String> createReservation(Reservation reservation) async {
    // This should be called within a transaction in the repository layer
    final docRef = await _reservationsCollection.add(_toFirestore(reservation));
    return docRef.id;
  }

  // Update reservation
  Future<void> updateReservation(Reservation reservation) async {
    await _reservationsCollection
        .doc(reservation.id)
        .update(_toFirestore(reservation));
  }

  // Get reservation by ID
  Future<Reservation?> getReservation(String id) async {
    final doc = await _reservationsCollection.doc(id).get();
    if (!doc.exists) return null;
    return _fromFirestore(doc);
  }

  // Get reservations for a restaurant
  Stream<List<Reservation>> watchRestaurantReservations(String restaurantId) {
    return _reservationsCollection
        .where('restaurantId', isEqualTo: restaurantId)
        .snapshots()
        .map((snapshot) {
          final reservations = snapshot.docs.map(_fromFirestore).toList();
          // Sort in memory instead of using orderBy to avoid index requirement
          reservations.sort(
            (a, b) => a.reservationDate.compareTo(b.reservationDate),
          );
          return reservations;
        });
  }

  // Get reservations for a specific date and restaurant
  Future<List<Reservation>> getReservationsByDate(
    String restaurantId,
    DateTime date,
  ) async {
    // Query for reservations on a specific date
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final snapshot = await _reservationsCollection
        .where('restaurantId', isEqualTo: restaurantId)
        .where('reservationDate', isGreaterThanOrEqualTo: startOfDay)
        .where('reservationDate', isLessThan: endOfDay)
        .get();

    return snapshot.docs.map(_fromFirestore).toList();
  }

  // Check for conflicting reservations (for double-booking prevention)
  Future<List<Reservation>> getConflictingReservations({
    required String restaurantId,
    required String tableId,
    required DateTime date,
    required String timeSlot,
  }) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final snapshot = await _reservationsCollection
        .where('restaurantId', isEqualTo: restaurantId)
        .where('tableId', isEqualTo: tableId)
        .where('reservationDate', isGreaterThanOrEqualTo: startOfDay)
        .where('reservationDate', isLessThan: endOfDay)
        .where('timeSlot', isEqualTo: timeSlot)
        .where(
          'status',
          whereIn: [
            ReservationStatus.pending.name,
            ReservationStatus.confirmed.name,
          ],
        )
        .get();

    return snapshot.docs.map(_fromFirestore).toList();
  }

  // Get customer reservations
  Stream<List<Reservation>> watchCustomerReservations(String customerId) {
    return _reservationsCollection
        .where('customerId', isEqualTo: customerId)
        .snapshots()
        .map((snapshot) {
          final reservations = snapshot.docs.map(_fromFirestore).toList();
          // Sort in memory to avoid index requirement
          reservations.sort(
            (a, b) => b.reservationDate.compareTo(a.reservationDate),
          );
          return reservations;
        });
  }

  // Cancel reservation
  Future<void> cancelReservation(String id) async {
    await _reservationsCollection.doc(id).update({
      'status': ReservationStatus.cancelled.name,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Convert Reservation to Firestore map
  Map<String, dynamic> _toFirestore(Reservation reservation) {
    return {
      'restaurantId': reservation.restaurantId,
      'tableId': reservation.tableId,
      'customerId': reservation.customerId,
      'customerName': reservation.customerName,
      'customerPhone': reservation.customerPhone,
      'reservationDate': Timestamp.fromDate(reservation.reservationDate),
      'timeSlot': reservation.timeSlot,
      'partySize': reservation.partySize,
      'status': reservation.status.name,
      'specialRequests': reservation.specialRequests,
      'createdAt': reservation.createdAt != null
          ? Timestamp.fromDate(reservation.createdAt!)
          : FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  // Convert Firestore document to Reservation
  Reservation _fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Reservation(
      id: doc.id,
      restaurantId: data['restaurantId'] ?? '',
      tableId: data['tableId'] ?? '',
      customerId: data['customerId'] ?? '',
      customerName: data['customerName'],
      customerPhone: data['customerPhone'],
      reservationDate: (data['reservationDate'] as Timestamp).toDate(),
      timeSlot: data['timeSlot'] ?? '',
      partySize: data['partySize'] ?? 1,
      status: ReservationStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => ReservationStatus.pending,
      ),
      specialRequests: data['specialRequests'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }
}
