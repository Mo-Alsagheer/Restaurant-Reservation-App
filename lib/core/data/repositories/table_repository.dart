import '../../domain/models/table_model.dart';
import '../firestore/table_firestore_data_source.dart';

class TableRepository {
  final TableFirestoreDataSource _dataSource;

  TableRepository({TableFirestoreDataSource? dataSource})
    : _dataSource = dataSource ?? TableFirestoreDataSource();

  Future<String> createTable(String restaurantId, TableModel table) async {
    return await _dataSource.createTable(restaurantId, table);
  }

  Future<void> updateTable(String restaurantId, TableModel table) async {
    await _dataSource.updateTable(restaurantId, table);
  }

  Future<List<TableModel>> getTables(String restaurantId) async {
    return await _dataSource.getTables(restaurantId);
  }

  Stream<List<TableModel>> watchTables(String restaurantId) {
    return _dataSource.watchTables(restaurantId);
  }

  Future<void> deleteTable(String restaurantId, String tableId) async {
    await _dataSource.deleteTable(restaurantId, tableId);
  }
}
