import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/data/repositories/reservation_repository.dart';
import '../../../core/data/repositories/table_repository.dart';
import '../../../core/domain/models/reservation.dart';

// Provider for reservations stream
final reservationsStreamProvider =
    StreamProvider.family<List<Reservation>, String>((ref, restaurantId) {
      final repository = ReservationRepository();
      return repository.watchRestaurantReservations(restaurantId);
    });

class VendorBookingsPage extends ConsumerStatefulWidget {
  final String restaurantId;

  const VendorBookingsPage({super.key, required this.restaurantId});

  @override
  ConsumerState<VendorBookingsPage> createState() => _VendorBookingsPageState();
}

class _VendorBookingsPageState extends ConsumerState<VendorBookingsPage> {
  ReservationStatus? _filterStatus;

  String _getTableName(String tableId) {
    // Extract table number from ID if it follows pattern
    return 'Table ${tableId.substring(0, 1)}';
  }

  @override
  Widget build(BuildContext context) {
    final reservationsAsync = ref.watch(
      reservationsStreamProvider(widget.restaurantId),
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Reservations & Bookings'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          PopupMenuButton<ReservationStatus?>(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filter by status',
            onSelected: (status) {
              setState(() => _filterStatus = status);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: null, child: Text('All')),
              const PopupMenuItem(
                value: ReservationStatus.pending,
                child: Text('Pending'),
              ),
              const PopupMenuItem(
                value: ReservationStatus.confirmed,
                child: Text('Confirmed'),
              ),
              const PopupMenuItem(
                value: ReservationStatus.cancelled,
                child: Text('Cancelled'),
              ),
              const PopupMenuItem(
                value: ReservationStatus.completed,
                child: Text('Completed'),
              ),
            ],
          ),
        ],
      ),
      body: reservationsAsync.when(
        data: (reservations) {
          // Apply filter
          final filteredReservations = _filterStatus == null
              ? reservations
              : reservations.where((r) => r.status == _filterStatus).toList();

          // Sort by date and time
          filteredReservations.sort((a, b) {
            final dateCompare = b.reservationDate.compareTo(a.reservationDate);
            if (dateCompare != 0) return dateCompare;
            return b.timeSlot.compareTo(a.timeSlot);
          });

          if (filteredReservations.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.event_busy,
                    size: 80,
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _filterStatus == null
                        ? 'No reservations yet'
                        : 'No ${_filterStatus!.name} reservations',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Reservations will appear here when customers book',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(reservationsStreamProvider(widget.restaurantId));
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredReservations.length,
              itemBuilder: (context, index) {
                final reservation = filteredReservations[index];
                return _buildReservationCard(reservation);
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error loading reservations'),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: const TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () {
                  ref.invalidate(
                    reservationsStreamProvider(widget.restaurantId),
                  );
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReservationCard(Reservation reservation) {
    final dateFormat = DateFormat('EEE, MMM d, yyyy');
    final statusColor = _getStatusColor(reservation.status);
    final isUpcoming =
        reservation.reservationDate.isAfter(DateTime.now()) &&
        reservation.status == ReservationStatus.pending;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: statusColor.withOpacity(0.2),
              child: Icon(
                _getStatusIcon(reservation.status),
                color: statusColor,
              ),
            ),
            title: Text(
              reservation.customerName ?? 'Customer',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(dateFormat.format(reservation.reservationDate)),
                    const SizedBox(width: 12),
                    Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(reservation.timeSlot),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.table_restaurant,
                      size: 14,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(_getTableName(reservation.tableId)),
                    const SizedBox(width: 12),
                    Icon(Icons.people, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text('${reservation.partySize} guests'),
                  ],
                ),
              ],
            ),
            trailing: Chip(
              label: Text(
                reservation.status.name.toUpperCase(),
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: statusColor.withOpacity(0.2),
              labelStyle: TextStyle(color: statusColor),
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
          ),
          if (reservation.customerPhone != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  Icon(Icons.phone, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    reservation.customerPhone!,
                    style: TextStyle(color: Colors.grey[700], fontSize: 13),
                  ),
                ],
              ),
            ),
          if (reservation.specialRequests != null &&
              reservation.specialRequests!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.note, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      reservation.specialRequests!,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Color _getStatusColor(ReservationStatus status) {
    switch (status) {
      case ReservationStatus.pending:
        return Colors.orange;
      case ReservationStatus.confirmed:
        return Colors.green;
      case ReservationStatus.cancelled:
        return Colors.red;
      case ReservationStatus.completed:
        return Colors.blue;
      case ReservationStatus.noShow:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(ReservationStatus status) {
    switch (status) {
      case ReservationStatus.pending:
        return Icons.schedule;
      case ReservationStatus.confirmed:
        return Icons.check_circle;
      case ReservationStatus.cancelled:
        return Icons.cancel;
      case ReservationStatus.completed:
        return Icons.check_circle_outline;
      case ReservationStatus.noShow:
        return Icons.person_off;
    }
  }
}
