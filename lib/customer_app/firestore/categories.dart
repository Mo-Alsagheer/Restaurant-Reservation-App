import 'package:cloud_firestore/cloud_firestore.dart';

// ------------------------------
// FoodCategory Model
// ------------------------------
class FoodCategory {
  final String id;
  final String name;
  final String? description;
  final String? iconUrl;

  FoodCategory({
    required this.id,
    required this.name,
    this.description,
    this.iconUrl,
  });
}

// ------------------------------
// Firestore Data Source
// ------------------------------
class FoodCategoryFirestoreDataSource {
  final FirebaseFirestore _firestore;

  FoodCategoryFirestoreDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _categoriesCollection =>
      _firestore.collection('foodCategories');

  // Create new category
  Future<String> createCategory(FoodCategory category) async {
    final docRef = await _categoriesCollection.add(_toFirestore(category));
    return docRef.id;
  }

  // Update category
  Future<void> updateCategory(FoodCategory category) async {
    await _categoriesCollection.doc(category.id).update(_toFirestore(category));
  }

  // Get all categories once
  Future<List<FoodCategory>> getAllCategories() async {
    final snapshot = await _categoriesCollection.orderBy('name').get();
    return snapshot.docs.map(_fromFirestore).toList();
  }

  // Stream categories
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

  // Convert model → Firestore
  Map<String, dynamic> _toFirestore(FoodCategory category) {
    return {
      'name': category.name,
      'description': category.description,
      'iconUrl': category.iconUrl,
    };
  }

  // Convert Firestore → model
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

// ------------------------------
// Testing Usage (Run in main())
// ------------------------------
void main() async {
  final dataSource = FoodCategoryFirestoreDataSource();

  // Create dummy test category
  final id = await dataSource.createCategory(
    FoodCategory(
      id: "",
      name: "Burger",
      description: "All types of burgers",
      iconUrl: null,
    ),
  );

  print("Created category with id: $id");

  // Read categories
  final categories = await dataSource.getAllCategories();

  for (var c in categories) {
    print("Category: ${c.name}");
  }
}
