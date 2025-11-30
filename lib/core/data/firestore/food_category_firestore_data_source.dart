import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/food_category.dart';

class FoodCategoryFirestoreDataSource {
  final FirebaseFirestore _firestore;

  FoodCategoryFirestoreDataSource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _categoriesCollection =>
      _firestore.collection('foodCategories');

  // Create a new category
  Future<String> createCategory(FoodCategory category) async {
    final docRef = await _categoriesCollection.add(_toFirestore(category));
    return docRef.id;
  }

  // Update category
  Future<void> updateCategory(FoodCategory category) async {
    await _categoriesCollection.doc(category.id).update(_toFirestore(category));
  }

  // Get all categories
  Future<List<FoodCategory>> getAllCategories() async {
    final snapshot = await _categoriesCollection.orderBy('name').get();
    return snapshot.docs.map(_fromFirestore).toList();
  }

  // Stream all categories
  Stream<List<FoodCategory>> watchAllCategories() {
    return _categoriesCollection
        .orderBy('name')
        .snapshots()
        .map((snapshot) => snapshot.docs.map(_fromFirestore).toList());
  }

  // Delete category
  Future<void> deleteCategory(String id) async {
    await _categoriesCollection.doc(id).delete();
  }

  // Convert FoodCategory to Firestore map
  Map<String, dynamic> _toFirestore(FoodCategory category) {
    return {
      'name': category.name,
      'description': category.description,
      'iconUrl': category.iconUrl,
    };
  }

  // Convert Firestore document to FoodCategory
  FoodCategory _fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return FoodCategory(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'],
      iconUrl: data['iconUrl'],
    );
  }
}
