import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/domain/models/table_model.dart';
import '../../../core/data/repositories/table_repository.dart';

// Provider for tables stream
final tablesStreamProvider = StreamProvider.family<List<TableModel>, String>((
  ref,
  restaurantId,
) {
  final repository = TableRepository();
  return repository.watchTables(restaurantId);
});

class TableManagementPage extends ConsumerStatefulWidget {
  final String restaurantId;

  const TableManagementPage({super.key, required this.restaurantId});

  @override
  ConsumerState<TableManagementPage> createState() =>
      _TableManagementPageState();
}

class _TableManagementPageState extends ConsumerState<TableManagementPage> {
  Future<void> _removeDuplicateTables() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Duplicate Tables'),
        content: const Text(
          'This will remove duplicate tables with the same table number, keeping only the first one. This action cannot be undone.\n\nDo you want to continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Remove Duplicates'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final repository = TableRepository();
      final tables = await repository.getTables(widget.restaurantId);

      // Group by table number to find duplicates
      final Map<int, List<TableModel>> tablesByNumber = {};
      for (final table in tables) {
        tablesByNumber.putIfAbsent(table.tableNumber, () => []);
        tablesByNumber[table.tableNumber]!.add(table);
      }

      // Delete duplicates (keep first, delete rest)
      int deletedCount = 0;
      for (final entry in tablesByNumber.entries) {
        final duplicates = entry.value;
        if (duplicates.length > 1) {
          // Keep the first one, delete the rest
          for (int i = 1; i < duplicates.length; i++) {
            await repository.deleteTable(widget.restaurantId, duplicates[i].id);
            deletedCount++;
          }
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              deletedCount > 0
                  ? 'Removed $deletedCount duplicate table(s)'
                  : 'No duplicates found',
            ),
            backgroundColor: deletedCount > 0 ? Colors.green : null,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error removing duplicates: $e')),
        );
      }
    }
  }

  void _showAddTableDialog() {
    final tableNumberController = TextEditingController();
    final capacityController = TextEditingController(text: '4');
    final areaController = TextEditingController();
    bool isActive = true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add New Table'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: tableNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Table Number *',
                    hintText: 'e.g., 1, 2, 3',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: capacityController,
                  decoration: const InputDecoration(
                    labelText: 'Capacity (Max 6) *',
                    hintText: 'Number of seats',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: areaController,
                  decoration: const InputDecoration(
                    labelText: 'Area (Optional)',
                    hintText: 'e.g., Indoor, Outdoor, VIP',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Active'),
                  subtitle: const Text('Table available for reservations'),
                  value: isActive,
                  onChanged: (value) {
                    setDialogState(() {
                      isActive = value;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                final tableNumber = int.tryParse(tableNumberController.text);
                final capacity = int.tryParse(capacityController.text);

                if (tableNumber == null || capacity == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter valid numbers')),
                  );
                  return;
                }

                if (capacity > 6) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Maximum capacity is 6')),
                  );
                  return;
                }

                try {
                  final repository = TableRepository();
                  final newTable = TableModel(
                    id: '', // Will be generated by Firestore
                    tableNumber: tableNumber,
                    capacity: capacity,
                    isActive: isActive,
                    area: areaController.text.isEmpty
                        ? null
                        : areaController.text,
                  );

                  await repository.createTable(widget.restaurantId, newTable);

                  if (mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Table added successfully')),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('Error: $e')));
                  }
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditTableDialog(TableModel table) {
    final tableNumberController = TextEditingController(
      text: table.tableNumber.toString(),
    );
    final capacityController = TextEditingController(
      text: table.capacity.toString(),
    );
    final areaController = TextEditingController(text: table.area ?? '');
    bool isActive = table.isActive;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Edit Table'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: tableNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Table Number *',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: capacityController,
                  decoration: const InputDecoration(
                    labelText: 'Capacity (Max 6) *',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: areaController,
                  decoration: const InputDecoration(
                    labelText: 'Area (Optional)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Active'),
                  subtitle: const Text('Table available for reservations'),
                  value: isActive,
                  onChanged: (value) {
                    setDialogState(() {
                      isActive = value;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                final tableNumber = int.tryParse(tableNumberController.text);
                final capacity = int.tryParse(capacityController.text);

                if (tableNumber == null || capacity == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter valid numbers')),
                  );
                  return;
                }

                if (capacity > 6) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Maximum capacity is 6')),
                  );
                  return;
                }

                try {
                  final repository = TableRepository();
                  final updatedTable = TableModel(
                    id: table.id,
                    tableNumber: tableNumber,
                    capacity: capacity,
                    isActive: isActive,
                    area: areaController.text.isEmpty
                        ? null
                        : areaController.text,
                  );

                  await repository.updateTable(
                    widget.restaurantId,
                    updatedTable,
                  );

                  if (mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Table updated successfully'),
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('Error: $e')));
                  }
                }
              },
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteTable(TableModel table) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Table'),
        content: Text(
          'Are you sure you want to delete Table ${table.tableNumber}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              try {
                final repository = TableRepository();
                await repository.deleteTable(widget.restaurantId, table.id);

                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Table deleted successfully')),
                  );
                }
              } catch (e) {
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              }
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tablesAsync = ref.watch(tablesStreamProvider(widget.restaurantId));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Manage Tables'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          IconButton(
            icon: const Icon(Icons.cleaning_services),
            tooltip: 'Remove Duplicates',
            onPressed: _removeDuplicateTables,
          ),
        ],
      ),
      body: tablesAsync.when(
        data: (tables) {
          if (tables.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.table_restaurant,
                    size: 80,
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No tables configured yet',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tap the + button to add your first table',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          // Group tables by area
          final Map<String?, List<TableModel>> groupedTables = {};
          for (final table in tables) {
            final area = table.area ?? 'General';
            groupedTables.putIfAbsent(area, () => []);
            groupedTables[area]!.add(table);
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(tablesStreamProvider(widget.restaurantId));
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Summary Card
                Card(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem(
                          context,
                          'Total Tables',
                          tables.length.toString(),
                          Icons.table_restaurant,
                        ),
                        _buildStatItem(
                          context,
                          'Total Seats',
                          tables
                              .fold<int>(0, (sum, t) => sum + t.capacity)
                              .toString(),
                          Icons.event_seat,
                        ),
                        _buildStatItem(
                          context,
                          'Active',
                          tables.where((t) => t.isActive).length.toString(),
                          Icons.check_circle,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Tables by area
                ...groupedTables.entries.map((entry) {
                  final area = entry.key;
                  final areaTables = entry.value;

                  // Sort tables by table number
                  areaTables.sort(
                    (a, b) => a.tableNumber.compareTo(b.tableNumber),
                  );

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          area ?? 'General Area',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      ...areaTables.map(
                        (table) => _buildTableCard(context, table),
                      ),
                      const SizedBox(height: 8),
                    ],
                  );
                }),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error'),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () =>
                    ref.invalidate(tablesStreamProvider(widget.restaurantId)),
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddTableDialog,
        icon: const Icon(Icons.add),
        label: const Text('Add Table'),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          size: 32,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
      ],
    );
  }

  Widget _buildTableCard(BuildContext context, TableModel table) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: table.isActive
              ? Theme.of(context).colorScheme.primaryContainer
              : Colors.grey.shade300,
          child: Text(
            table.tableNumber.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: table.isActive
                  ? Theme.of(context).colorScheme.onPrimaryContainer
                  : Colors.grey.shade600,
            ),
          ),
        ),
        title: Row(
          children: [
            Text('Table ${table.tableNumber}'),
            const SizedBox(width: 8),
            if (!table.isActive)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Inactive',
                  style: TextStyle(fontSize: 10, color: Colors.black54),
                ),
              ),
          ],
        ),
        subtitle: Text('Capacity: ${table.capacity} seats'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, size: 20),
              onPressed: () => _showEditTableDialog(table),
              tooltip: 'Edit',
            ),
            IconButton(
              icon: const Icon(Icons.delete, size: 20, color: Colors.red),
              onPressed: () => _deleteTable(table),
              tooltip: 'Delete',
            ),
          ],
        ),
      ),
    );
  }
}
