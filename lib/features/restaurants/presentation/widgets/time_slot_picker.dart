import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/domain/models/time_slot.dart';

class TimeSlotPicker extends StatefulWidget {
  final List<TimeSlot> initialSlots;
  final ValueChanged<List<TimeSlot>> onSlotsChanged;
  final int maxSlots;

  const TimeSlotPicker({
    super.key,
    required this.initialSlots,
    required this.onSlotsChanged,
    this.maxSlots = 5,
  });

  @override
  State<TimeSlotPicker> createState() => _TimeSlotPickerState();
}

class _TimeSlotPickerState extends State<TimeSlotPicker> {
  late List<TimeSlot> _slots;
  final _uuid = const Uuid();

  @override
  void initState() {
    super.initState();
    _slots = List.from(widget.initialSlots);

    // Add default slots if empty
    if (_slots.isEmpty) {
      // Defer the callback until after the build is complete
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _addDefaultSlots();
      });
    }
  }

  void _addDefaultSlots() {
    // Default time slots: 10:00, 12:00, 14:00, 16:00, 18:00
    final defaultTimes = ['10:00', '12:00', '14:00', '16:00', '18:00'];

    _slots = defaultTimes
        .map((time) => TimeSlot(id: _uuid.v4(), time: time, isAvailable: true))
        .toList();

    widget.onSlotsChanged(_slots);
  }

  void _addTimeSlot() async {
    if (_slots.length >= widget.maxSlots) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Maximum ${widget.maxSlots} time slots allowed'),
        ),
      );
      return;
    }

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final timeString = _formatTimeOfDay(picked);

      // Check for duplicates
      if (_slots.any((slot) => slot.time == timeString)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('This time slot already exists')),
        );
        return;
      }

      setState(() {
        _slots.add(
          TimeSlot(id: _uuid.v4(), time: timeString, isAvailable: true),
        );
        _slots.sort((a, b) => a.time.compareTo(b.time));
      });

      widget.onSlotsChanged(_slots);
    }
  }

  void _removeTimeSlot(int index) {
    setState(() {
      _slots.removeAt(index);
    });
    widget.onSlotsChanged(_slots);
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  TimeOfDay _parseTimeString(String timeString) {
    final parts = timeString.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  String _formatDisplayTime(String timeString) {
    try {
      final time = _parseTimeString(timeString);
      final now = DateTime.now();
      final dateTime = DateTime(
        now.year,
        now.month,
        now.day,
        time.hour,
        time.minute,
      );
      return DateFormat.jm().format(dateTime); // 12-hour format with AM/PM
    } catch (e) {
      return timeString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Time Slots (${_slots.length}/${widget.maxSlots})',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (_slots.length < widget.maxSlots)
              TextButton.icon(
                onPressed: _addTimeSlot,
                icon: const Icon(Icons.add),
                label: const Text('Add Slot'),
              ),
          ],
        ),
        const SizedBox(height: 8),
        if (_slots.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(Icons.access_time, size: 48, color: Colors.grey),
                  const SizedBox(height: 8),
                  const Text('No time slots added'),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: _addDefaultSlots,
                    icon: const Icon(Icons.auto_awesome),
                    label: const Text('Add Default Slots'),
                  ),
                ],
              ),
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(
              _slots.length,
              (index) => Chip(
                avatar: const Icon(Icons.access_time, size: 18),
                label: Text(_formatDisplayTime(_slots[index].time)),
                onDeleted: () => _removeTimeSlot(index),
                deleteIcon: const Icon(Icons.close, size: 18),
                backgroundColor: Colors.deepOrange.shade50,
              ),
            ),
          ),
        const SizedBox(height: 8),
        Text(
          'Tap + to add custom time slots or use default slots',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
        ),
      ],
    );
  }
}
