import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/restaurants/presentation/vendor_restaurant_dashboard_page.dart';
import '../features/restaurants/presentation/restaurant_selection_page.dart';
import '../features/restaurants/presentation/pages/vendor_restaurant_form_page_new.dart';
import '../features/restaurants/presentation/pages/food_category_management_page.dart';
import '../features/tables/presentation/table_management_page.dart';
import '../features/bookings/presentation/vendor_bookings_page.dart';
import 'providers/vendor_restaurant_providers.dart';

// Provider for the GoRouter
final vendorRouterProvider = Provider<GoRouter>((ref) {
  final restaurantIdNotifier = ref.watch(currentRestaurantIdNotifierProvider);

  return GoRouter(
    initialLocation: '/dashboard',
    redirect: (context, state) {
      // Get the current restaurant ID
      final restaurantId = restaurantIdNotifier.valueOrNull;
      final isGoingToAddRestaurant = state.matchedLocation == '/restaurant/add';

      // If vendor has a restaurant and tries to go to add page, redirect to dashboard
      if (restaurantId != null && isGoingToAddRestaurant) {
        return '/dashboard';
      }

      return null; // No redirect needed
    },
    routes: [
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, state) => const VendorRestaurantDashboardPage(),
      ),
      GoRoute(
        path: '/restaurants',
        name: 'select-restaurant',
        builder: (context, state) => const RestaurantSelectionPage(),
      ),
      GoRoute(
        path: '/restaurant/add',
        name: 'add-restaurant',
        builder: (context, state) => const VendorRestaurantFormPage(),
      ),
      GoRoute(
        path: '/restaurant/:id/edit',
        name: 'edit-restaurant',
        builder: (context, state) {
          final restaurantId = state.pathParameters['id']!;
          return VendorRestaurantFormPage(restaurantId: restaurantId);
        },
      ),
      GoRoute(
        path: '/restaurant/:id/tables',
        name: 'manage-tables',
        builder: (context, state) {
          final restaurantId = state.pathParameters['id']!;
          return TableManagementPage(restaurantId: restaurantId);
        },
      ),
      GoRoute(
        path: '/restaurant/:id/bookings',
        name: 'vendor-bookings',
        builder: (context, state) {
          final restaurantId = state.pathParameters['id']!;
          return VendorBookingsPage(restaurantId: restaurantId);
        },
      ),
      GoRoute(
        path: '/categories',
        name: 'food-categories',
        builder: (context, state) => const FoodCategoryManagementPage(),
      ),
    ],
  );
});

class VendorRouter {
  // Keep for backward compatibility, but router should now be accessed via provider
  static GoRouter get router => throw UnimplementedError(
    'Use vendorRouterProvider instead of VendorRouter.router',
  );
}
