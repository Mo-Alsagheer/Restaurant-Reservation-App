import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/restaurant.dart';
import '../../domain/models/location.dart';
import '../../domain/models/time_slot.dart';

class RestaurantFirestoreDataSource {
  final FirebaseFirestore _firestore;

  RestaurantFirestoreDataSource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _restaurantsCollection =>
      _firestore.collection('restaurants');

  // Create a new restaurant
  Future<String> createRestaurant(Restaurant restaurant) async {
    final docRef = await _restaurantsCollection.add(_toFirestore(restaurant));
    return docRef.id;
  }

  // Update existing restaurant
  Future<void> updateRestaurant(Restaurant restaurant) async {
    await _restaurantsCollection
        .doc(restaurant.id)
        .update(_toFirestore(restaurant));
  }

  // Get restaurant by ID
  Future<Restaurant?> getRestaurant(String id) async {
    final doc = await _restaurantsCollection.doc(id).get();
    if (!doc.exists) return null;
    return _fromFirestore(doc);
  }

  // Stream restaurant updates
  Stream<Restaurant?> watchRestaurant(String id) {
    return _restaurantsCollection.doc(id).snapshots().map((doc) {
      if (!doc.exists) return null;
      return _fromFirestore(doc);
    });
  }

  // Get all restaurants
  Future<List<Restaurant>> getAllRestaurants() async {
    final snapshot = await _restaurantsCollection.get();
    return snapshot.docs.map(_fromFirestore).toList();
  }

  // Stream all restaurants
  Stream<List<Restaurant>> watchAllRestaurants() {
    return _restaurantsCollection.snapshots().map(
      (snapshot) => snapshot.docs.map(_fromFirestore).toList(),
    );
  }

  // Get restaurants by category
  Future<List<Restaurant>> getRestaurantsByCategory(String categoryId) async {
    final snapshot = await _restaurantsCollection
        .where('foodCategoryId', isEqualTo: categoryId)
        .get();
    return snapshot.docs.map(_fromFirestore).toList();
  }

  // Search restaurants by name
  Future<List<Restaurant>> searchRestaurantsByName(String query) async {
    final snapshot = await _restaurantsCollection
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: '$query\uf8ff')
        .get();
    return snapshot.docs.map(_fromFirestore).toList();
  }

  // Delete restaurant
  Future<void> deleteRestaurant(String id) async {
    await _restaurantsCollection.doc(id).delete();
  }

  // Convert Restaurant to Firestore map
  Map<String, dynamic> _toFirestore(Restaurant restaurant) {
    return {
      'name': restaurant.name,
      'description': restaurant.description,
      'imageUrl': restaurant.imageUrl,
      'foodCategoryId': restaurant.foodCategoryId,
      'foodCategoryName': restaurant.foodCategoryName,
      'numberOfTables': restaurant.numberOfTables,
      'maxSeatsPerTable': restaurant.maxSeatsPerTable,
      'location': {
        'latitude': restaurant.location.latitude,
        'longitude': restaurant.location.longitude,
        'address': restaurant.location.address,
      },
      'timeSlots': restaurant.timeSlots
          .map(
            (slot) => {
              'id': slot.id,
              'time': slot.time,
              'isAvailable': slot.isAvailable,
            },
          )
          .toList(),
      'isActive': restaurant.isActive,
      'createdAt': restaurant.createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'vendorId': restaurant.vendorId,
    };
  }

  // Convert Firestore document to Restaurant
  Restaurant _fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Restaurant(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'],
      foodCategoryId: data['foodCategoryId'] ?? '',
      foodCategoryName: data['foodCategoryName'],
      numberOfTables: data['numberOfTables'] ?? 0,
      maxSeatsPerTable: data['maxSeatsPerTable'] ?? 6,
      location: Location(
        latitude: data['location']?['latitude'] ?? 0.0,
        longitude: data['location']?['longitude'] ?? 0.0,
        address: data['location']?['address'],
      ),
      timeSlots:
          (data['timeSlots'] as List<dynamic>?)
              ?.map(
                (slot) => TimeSlot(
                  id: slot['id'] ?? '',
                  time: slot['time'] ?? '',
                  isAvailable: slot['isAvailable'] ?? true,
                ),
              )
              .toList() ??
          [],
      isActive: data['isActive'] ?? true,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      vendorId: data['vendorId'],
    );
  }
}
