import '../../domain/models/restaurant.dart';
import '../firestore/restaurant_firestore_data_source.dart';

class RestaurantRepository {
  final RestaurantFirestoreDataSource _dataSource;

  RestaurantRepository({RestaurantFirestoreDataSource? dataSource})
    : _dataSource = dataSource ?? RestaurantFirestoreDataSource();

  Future<String> createRestaurant(Restaurant restaurant) async {
    return await _dataSource.createRestaurant(restaurant);
  }

  Future<void> updateRestaurant(Restaurant restaurant) async {
    await _dataSource.updateRestaurant(restaurant);
  }

  Future<Restaurant?> getRestaurant(String id) async {
    return await _dataSource.getRestaurant(id);
  }

  Stream<Restaurant?> watchRestaurant(String id) {
    return _dataSource.watchRestaurant(id);
  }

  Future<List<Restaurant>> getAllRestaurants() async {
    return await _dataSource.getAllRestaurants();
  }

  Stream<List<Restaurant>> watchAllRestaurants() {
    return _dataSource.watchAllRestaurants();
  }

  Future<List<Restaurant>> getRestaurantsByCategory(String categoryId) async {
    return await _dataSource.getRestaurantsByCategory(categoryId);
  }

  Future<List<Restaurant>> searchRestaurantsByName(String query) async {
    return await _dataSource.searchRestaurantsByName(query);
  }

  Future<void> deleteRestaurant(String id) async {
    await _dataSource.deleteRestaurant(id);
  }
}
