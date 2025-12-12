import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/domain/models/table_model.dart';

class TableConfiguration extends StatefulWidget {
  final List<TableModel> initialTables;
  final ValueChanged<List<TableModel>> onTablesChanged;
  final int maxSeatsPerTable;

  const TableConfiguration({
    super.key,
    required this.initialTables,
    required this.onTablesChanged,
    this.maxSeatsPerTable = 6,
  });

  @override
  State<TableConfiguration> createState() => _TableConfigurationState();
}

class _TableConfigurationState extends State<TableConfiguration> {
  late List<TableModel> _tables;
  final _uuid = const Uuid();

  @override
  void initState() {
    super.initState();
    _tables = List.from(widget.initialTables);
  }

  void _generateTables(int numberOfTables, int seatsPerTable) {
    if (numberOfTables <= 0 || seatsPerTable <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid numbers')),
      );
      return;
    }

    if (seatsPerTable > widget.maxSeatsPerTable) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Maximum ${widget.maxSeatsPerTable} seats per table allowed',
          ),
        ),
      );
      return;
    }

    setState(() {
      _tables = List.generate(
        numberOfTables,
        (index) => TableModel(
          id: _uuid.v4(),
          tableNumber: index + 1,
          capacity: seatsPerTable,
          area: 'Main Hall', // Default area
        ),
      );
    });

    widget.onTablesChanged(_tables);
  }

  void _addTable() {
    showDialog(
      context: context,
      builder: (context) => _AddTableDialog(
        maxSeats: widget.maxSeatsPerTable,
        onAdd: (int tableNumber, int capacity, String area) {
          setState(() {
            _tables.add(
              TableModel(
                id: _uuid.v4(),
                tableNumber: tableNumber,
                capacity: capacity,
                area: area,
              ),
            );
          });
          widget.onTablesChanged(_tables);
        },
        existingTableNumbers: _tables.map((t) => t.tableNumber).toList(),
      ),
    );
  }

  void _editTable(int index) {
    final table = _tables[index];
    showDialog(
      context: context,
      builder: (context) => _EditTableDialog(
        table: table,
        maxSeats: widget.maxSeatsPerTable,
        onEdit: (int tableNumber, int capacity, String area) {
          setState(() {
            _tables[index] = table.copyWith(
              tableNumber: tableNumber,
              capacity: capacity,
              area: area,
            );
          });
          widget.onTablesChanged(_tables);
        },
        existingTableNumbers: _tables
            .asMap()
            .entries
            .where((entry) => entry.key != index)
            .map((entry) => entry.value.tableNumber)
            .toList(),
      ),
    );
  }

  void _removeTable(int index) {
    setState(() {
      _tables.removeAt(index);
    });
    widget.onTablesChanged(_tables);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Quick setup
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quick Setup',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                _QuickSetupForm(
                  maxSeatsPerTable: widget.maxSeatsPerTable,
                  onGenerate: _generateTables,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Tables list
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tables (${_tables.length})',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            TextButton.icon(
              onPressed: _addTable,
              icon: const Icon(Icons.add),
              label: const Text('Add Table'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (_tables.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Column(
                  children: [
                    const Icon(
                      Icons.table_restaurant,
                      size: 48,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 8),
                    const Text('No tables configured'),
                    const SizedBox(height: 4),
                    Text(
                      'Use quick setup above or add tables manually',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _tables.length,
            itemBuilder: (context, index) {
              final table = _tables[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.deepOrange.shade100,
                    child: Text(
                      '${table.tableNumber}',
                      style: TextStyle(
                        color: Colors.deepOrange.shade900,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text('Table ${table.tableNumber}'),
                  subtitle: Text('${table.capacity} seats • ${table.area}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _editTable(index),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _removeTable(index),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}

class _QuickSetupForm extends StatefulWidget {
  final int maxSeatsPerTable;
  final Function(int numberOfTables, int seatsPerTable) onGenerate;

  const _QuickSetupForm({
    required this.maxSeatsPerTable,
    required this.onGenerate,
  });

  @override
  State<_QuickSetupForm> createState() => _QuickSetupFormState();
}

class _QuickSetupFormState extends State<_QuickSetupForm> {
  final _numberOfTablesController = TextEditingController();
  final _seatsPerTableController = TextEditingController();

  @override
  void dispose() {
    _numberOfTablesController.dispose();
    _seatsPerTableController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _numberOfTablesController,
          decoration: const InputDecoration(
            labelText: 'Number of Tables',
            border: OutlineInputBorder(),
            isDense: true,
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _seatsPerTableController,
          decoration: InputDecoration(
            labelText: 'Seats per Table (max ${widget.maxSeatsPerTable})',
            border: const OutlineInputBorder(),
            isDense: true,
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () {
            final numberOfTables =
                int.tryParse(_numberOfTablesController.text) ?? 0;
            final seatsPerTable =
                int.tryParse(_seatsPerTableController.text) ?? 0;
            widget.onGenerate(numberOfTables, seatsPerTable);
          },
          icon: const Icon(Icons.auto_awesome),
          label: const Text('Generate'),
        ),
      ],
    );
  }
}

class _AddTableDialog extends StatefulWidget {
  final int maxSeats;
  final Function(int tableNumber, int capacity, String area) onAdd;
  final List<int> existingTableNumbers;

  const _AddTableDialog({
    required this.maxSeats,
    required this.onAdd,
    required this.existingTableNumbers,
  });

  @override
  State<_AddTableDialog> createState() => _AddTableDialogState();
}

class _AddTableDialogState extends State<_AddTableDialog> {
  final _formKey = GlobalKey<FormState>();
  final _tableNumberController = TextEditingController();
  final _capacityController = TextEditingController();
  final _areaController = TextEditingController(text: 'Main Hall');

  @override
  void dispose() {
    _tableNumberController.dispose();
    _capacityController.dispose();
    _areaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Table'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _tableNumberController,
              decoration: const InputDecoration(
                labelText: 'Table Number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter table number';
                }
                final number = int.tryParse(value);
                if (number == null || number <= 0) {
                  return 'Please enter valid number';
                }
                if (widget.existingTableNumbers.contains(number)) {
                  return 'Table number already exists';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _capacityController,
              decoration: InputDecoration(
                labelText: 'Capacity (max ${widget.maxSeats})',
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter capacity';
                }
                final capacity = int.tryParse(value);
                if (capacity == null || capacity <= 0) {
                  return 'Please enter valid capacity';
                }
                if (capacity > widget.maxSeats) {
                  return 'Maximum ${widget.maxSeats} seats allowed';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _areaController,
              decoration: const InputDecoration(
                labelText: 'Area',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter area';
                }
                return null;
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
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onAdd(
                int.parse(_tableNumberController.text),
                int.parse(_capacityController.text),
                _areaController.text,
              );
              Navigator.pop(context);
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}

class _EditTableDialog extends StatefulWidget {
  final TableModel table;
  final int maxSeats;
  final Function(int tableNumber, int capacity, String area) onEdit;
  final List<int> existingTableNumbers;

  const _EditTableDialog({
    required this.table,
    required this.maxSeats,
    required this.onEdit,
    required this.existingTableNumbers,
  });

  @override
  State<_EditTableDialog> createState() => _EditTableDialogState();
}

class _EditTableDialogState extends State<_EditTableDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _tableNumberController = TextEditingController(
    text: widget.table.tableNumber.toString(),
  );
  late final _capacityController = TextEditingController(
    text: widget.table.capacity.toString(),
  );
  late final _areaController = TextEditingController(text: widget.table.area);

  @override
  void dispose() {
    _tableNumberController.dispose();
    _capacityController.dispose();
    _areaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Table'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _tableNumberController,
              decoration: const InputDecoration(
                labelText: 'Table Number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter table number';
                }
                final number = int.tryParse(value);
                if (number == null || number <= 0) {
                  return 'Please enter valid number';
                }
                if (widget.existingTableNumbers.contains(number)) {
                  return 'Table number already exists';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _capacityController,
              decoration: InputDecoration(
                labelText: 'Capacity (max ${widget.maxSeats})',
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter capacity';
                }
                final capacity = int.tryParse(value);
                if (capacity == null || capacity <= 0) {
                  return 'Please enter valid capacity';
                }
                if (capacity > widget.maxSeats) {
                  return 'Maximum ${widget.maxSeats} seats allowed';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _areaController,
              decoration: const InputDecoration(
                labelText: 'Area',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter area';
                }
                return null;
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
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onEdit(
                int.parse(_tableNumberController.text),
                int.parse(_capacityController.text),
                _areaController.text,
              );
              Navigator.pop(context);
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
