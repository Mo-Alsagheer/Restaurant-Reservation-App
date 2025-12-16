import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../vendor_app/providers/vendor_restaurant_providers.dart';
import '../../../core/domain/models/reservation.dart';
import '../../../core/domain/models/restaurant.dart';
import '../../../core/domain/models/table_model.dart';

class VendorRestaurantDashboardPage extends ConsumerWidget {
  const VendorRestaurantDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final restaurantAsync = ref.watch(currentRestaurantStreamProvider);
    final reservationsAsync = ref.watch(
      currentRestaurantReservationsStreamProvider,
    );
    final tablesAsync = ref.watch(currentRestaurantTablesStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant Manager'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            tooltip: 'Select Restaurant',
            onPressed: () => context.go('/restaurants'),
          ),
          restaurantAsync.when(
            data: (restaurant) {
              if (restaurant != null) {
                return IconButton(
                  icon: const Icon(Icons.logout),
                  tooltip: 'Clear Restaurant',
                  onPressed: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Clear Restaurant'),
                        content: const Text(
                          'This will log you out of this restaurant. You can register a new one or select it again later.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          FilledButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Clear'),
                          ),
                        ],
                      ),
                    );

                    if (confirmed == true) {
                      await ref
                          .read(currentRestaurantIdNotifierProvider.notifier)
                          .clearRestaurantId();
                    }
                  },
                );
              }
              return const SizedBox.shrink();
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: restaurantAsync.when(
        data: (restaurant) {
          if (restaurant == null) {
            return _buildNoRestaurantView(context);
          }
          return _buildRestaurantDashboard(
            context,
            ref,
            restaurant,
            reservationsAsync,
            tablesAsync,
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error'),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () =>
                    ref.invalidate(currentRestaurantStreamProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoRestaurantView(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant,
              size: 100,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'Welcome to Restaurant Manager',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'Manage your restaurant, tables, and bookings all in one place.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => context.go('/restaurant/add'),
                icon: const Icon(Icons.add),
                label: const Text('Register Restaurant'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRestaurantDashboard(
    BuildContext context,
    WidgetRef ref,
    Restaurant restaurant,
    AsyncValue<List<Reservation>> reservationsAsync,
    AsyncValue<List<TableModel>> tablesAsync,
  ) {
    final pendingReservations = reservationsAsync.when(
      data: (reservations) => reservations
          .where((r) => r.status == ReservationStatus.pending)
          .length,
      loading: () => 0,
      error: (_, __) => 0,
    );

    final totalTables = tablesAsync.when(
      data: (tables) => tables.length,
      loading: () => 0,
      error: (_, __) => 0,
    );

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(currentRestaurantStreamProvider);
        ref.invalidate(currentRestaurantReservationsStreamProvider);
        ref.invalidate(currentRestaurantTablesStreamProvider);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Restaurant Info Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (restaurant.imageUrl != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              restaurant.imageUrl!,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 80,
                                height: 80,
                                color: Colors.grey[300],
                                child: const Icon(Icons.restaurant),
                              ),
                            ),
                          )
                        else
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.restaurant, size: 40),
                          ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                restaurant.name,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                restaurant.foodCategoryName ?? 'No category',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                restaurant.description,
                                style: Theme.of(context).textTheme.bodySmall,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Stats Cards
            Row(
              children: [
                Expanded(
                  child: Card(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(
                            '$pendingReservations',
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimaryContainer,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Pending',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Card(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(
                            '$totalTables',
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSecondaryContainer,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Tables',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Management Actions
            Text('Management', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            _buildActionButton(
              context,
              icon: Icons.event_available,
              title: 'Reservations & Orders',
              subtitle: 'View and manage bookings',
              onTap: () => context.go('/restaurant/${restaurant.id}/bookings'),
            ),
            const SizedBox(height: 8),
            _buildActionButton(
              context,
              icon: Icons.table_restaurant,
              title: 'Manage Tables',
              subtitle: 'Configure restaurant tables',
              onTap: () => context.go('/restaurant/${restaurant.id}/tables'),
            ),
            const SizedBox(height: 8),
            _buildActionButton(
              context,
              icon: Icons.edit,
              title: 'Edit Restaurant',
              subtitle: 'Update restaurant details',
              onTap: () => context.go('/restaurant/${restaurant.id}/edit'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon, size: 32),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
