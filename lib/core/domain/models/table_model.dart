import 'package:freezed_annotation/freezed_annotation.dart';

part 'table_model.freezed.dart';
part 'table_model.g.dart';

@freezed
class TableModel with _$TableModel {
  const factory TableModel({
    required String id,
    required int tableNumber,
    required int capacity, // Max 6 seats
    @Default(true) bool isActive,
    String? area, // e.g., "Indoor", "Outdoor", "Terrace"
  }) = _TableModel;

  factory TableModel.fromJson(Map<String, dynamic> json) =>
      _$TableModelFromJson(json);
}
