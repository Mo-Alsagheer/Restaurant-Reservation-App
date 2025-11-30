import 'package:go_router/go_router.dart';
import '../features/restaurants/presentation/vendor_restaurant_dashboard_page.dart';
import '../features/restaurants/presentation/vendor_restaurant_form_page.dart';
import '../features/tables/presentation/table_management_page.dart';
import '../features/bookings/presentation/vendor_bookings_page.dart';

class VendorRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/dashboard',
    routes: [
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, state) => const VendorRestaurantDashboardPage(),
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
    ],
  );
}
