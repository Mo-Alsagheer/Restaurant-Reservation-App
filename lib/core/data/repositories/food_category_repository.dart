import '../../domain/models/food_category.dart';
import '../firestore/food_category_firestore_data_source.dart';

class FoodCategoryRepository {
  final FoodCategoryFirestoreDataSource _dataSource;

  FoodCategoryRepository({FoodCategoryFirestoreDataSource? dataSource})
    : _dataSource = dataSource ?? FoodCategoryFirestoreDataSource();

  Future<String> createCategory(FoodCategory category) async {
    return await _dataSource.createCategory(category);
  }

  Future<void> updateCategory(FoodCategory category) async {
    await _dataSource.updateCategory(category);
  }

  Future<List<FoodCategory>> getAllCategories() async {
    return await _dataSource.getAllCategories();
  }

  Stream<List<FoodCategory>> watchAllCategories() {
    return _dataSource.watchAllCategories();
  }

  Future<void> deleteCategory(String id) async {
    await _dataSource.deleteCategory(id);
  }
}
