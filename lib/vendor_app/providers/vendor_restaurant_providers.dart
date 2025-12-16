import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/vendor_restaurant_prefs.dart';
import '../../core/domain/models/restaurant.dart';
import '../../core/domain/models/table_model.dart';
import '../../core/data/repositories/restaurant_repository.dart';
import '../../core/data/repositories/table_repository.dart';
import '../../core/data/repositories/reservation_repository.dart';
import '../../core/domain/models/reservation.dart';

/// Provider for the current vendor's restaurant ID (loaded from SharedPreferences)
final currentRestaurantIdProvider = FutureProvider<String?>((ref) async {
  return await VendorRestaurantPrefs.getRestaurantId();
});

/// StateNotifier to manage and update the current restaurant ID
class CurrentRestaurantIdNotifier extends StateNotifier<AsyncValue<String?>> {
  CurrentRestaurantIdNotifier() : super(const AsyncValue.loading()) {
    _loadRestaurantId();
  }

  Future<void> _loadRestaurantId() async {
    state = const AsyncValue.loading();
    try {
      final id = await VendorRestaurantPrefs.getRestaurantId();
      state = AsyncValue.data(id);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> setRestaurantId(String restaurantId) async {
    await VendorRestaurantPrefs.setRestaurantId(restaurantId);
    state = AsyncValue.data(restaurantId);
  }

  Future<void> clearRestaurantId() async {
    await VendorRestaurantPrefs.clearRestaurantId();
    state = const AsyncValue.data(null);
  }

  void refresh() {
    _loadRestaurantId();
  }
}

final currentRestaurantIdNotifierProvider =
    StateNotifierProvider<CurrentRestaurantIdNotifier, AsyncValue<String?>>(
      (ref) => CurrentRestaurantIdNotifier(),
    );

/// Stream provider for the current restaurant (real-time updates from Firestore)
final currentRestaurantStreamProvider = StreamProvider<Restaurant?>((ref) {
  final restaurantIdAsync = ref.watch(currentRestaurantIdNotifierProvider);

  return restaurantIdAsync.when(
    data: (id) {
      if (id == null) {
        return Stream.value(null);
      }
      final repository = RestaurantRepository();
      return repository.watchRestaurant(id);
    },
    loading: () => Stream.value(null),
    error: (_, __) => Stream.value(null),
  );
});

/// Stream provider for tables of the current restaurant
final currentRestaurantTablesStreamProvider = StreamProvider<List<TableModel>>((
  ref,
) {
  final restaurantIdAsync = ref.watch(currentRestaurantIdNotifierProvider);

  return restaurantIdAsync.when(
    data: (id) {
      if (id == null) {
        return Stream.value([]);
      }
      final repository = TableRepository();
      return repository.watchTables(id);
    },
    loading: () => Stream.value([]),
    error: (_, __) => Stream.value([]),
  );
});

/// Stream provider for reservations of the current restaurant
final currentRestaurantReservationsStreamProvider =
    StreamProvider<List<Reservation>>((ref) {
      final restaurantIdAsync = ref.watch(currentRestaurantIdNotifierProvider);

      return restaurantIdAsync.when(
        data: (id) {
          if (id == null) {
            return Stream.value([]);
          }
          final repository = ReservationRepository();
          return repository.watchRestaurantReservations(id);
        },
        loading: () => Stream.value([]),
        error: (_, __) => Stream.value([]),
      );
    });
