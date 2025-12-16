import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/table_model.dart';

class TableFirestoreDataSource {
  final FirebaseFirestore _firestore;

  TableFirestoreDataSource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  // Get tables subcollection for a restaurant
  CollectionReference<Map<String, dynamic>> _tablesCollection(
    String restaurantId,
  ) => _firestore
      .collection('restaurants')
      .doc(restaurantId)
      .collection('tables');

  // Create a new table
  Future<String> createTable(String restaurantId, TableModel table) async {
    final data = {
      ..._toFirestore(table),
      'createdAt': FieldValue.serverTimestamp(),
    };
    final docRef = await _tablesCollection(restaurantId).add(data);
    return docRef.id;
  }

  // Update table
  Future<void> updateTable(String restaurantId, TableModel table) async {
    await _tablesCollection(
      restaurantId,
    ).doc(table.id).update(_toFirestore(table));
  }

  // Get all tables for a restaurant
  Future<List<TableModel>> getTables(String restaurantId) async {
    final snapshot = await _tablesCollection(
      restaurantId,
    ).orderBy('tableNumber').get();
    return snapshot.docs.map(_fromFirestore).toList();
  }

  // Stream tables for a restaurant
  Stream<List<TableModel>> watchTables(String restaurantId) {
    return _tablesCollection(restaurantId)
        .orderBy('tableNumber')
        .snapshots()
        .map((snapshot) => snapshot.docs.map(_fromFirestore).toList());
  }

  // Delete table
  Future<void> deleteTable(String restaurantId, String tableId) async {
    await _tablesCollection(restaurantId).doc(tableId).delete();
  }

  // Convert TableModel to Firestore map
  Map<String, dynamic> _toFirestore(TableModel table) {
    return {
      'tableNumber': table.tableNumber,
      'capacity': table.capacity,
      'isActive': table.isActive,
      'area': table.area,
    };
  }

  // Convert Firestore document to TableModel
  TableModel _fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return TableModel(
      id: doc.id,
      tableNumber: data['tableNumber'] ?? 0,
      capacity: data['capacity'] ?? 2,
      isActive: data['isActive'] ?? true,
      area: data['area'],
    );
  }
}
