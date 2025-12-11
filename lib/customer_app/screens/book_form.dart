import 'package:flutter/material.dart';

class BookForm extends StatefulWidget {
  const BookForm({super.key});

  @override
  State<BookForm> createState() => _BookFormState();
}

class _BookFormState extends State<BookForm> {
  int? selectedGuests;
  DateTime? selectedDate;
  String? selectedTable;
  String? selectedTime;

  List<String> timeSlots = [
    "10:00",
    "10:30",
    "11:00",
    "11:30",
    "12:00",
  ];

  // 🔶 Unified style for selectable containers
  BoxDecoration selectorStyle(bool selected) {
    return BoxDecoration(
      color: selected ? Colors.black : Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: selected ? Colors.black : Colors.black26,
        width: 1.4,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final restaurantId = ModalRoute.of(context)!.settings.arguments as String;

    List<String> tables =
        selectedGuests == null ? [] : _getAvailableTables(selectedGuests!);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Book a Table"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            "Restaurant ID: $restaurantId",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // ---------------- Guests ----------------
          const Text(
            "Number of Guests",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            children: List.generate(6, (i) {
              final num = i + 1;
              final isSelected = selectedGuests == num;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedGuests = num;
                    selectedTable = null;
                  });
                },
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 70),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                  decoration: selectorStyle(isSelected),
                  child: Text(
                    "$num",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 25),

          // ---------------- Date Picker ----------------
          const Text(
            "Select Date",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: selectedGuests == null
                ? () => _showError("Please choose number of guests first")
                : () async {
                    final picked = await showDatePicker(
                      context: context,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2026),
                      initialDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setState(() => selectedDate = picked);
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              side: const BorderSide(color: Colors.black26),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              selectedDate == null
                  ? "Choose Date"
                  : selectedDate!.toIso8601String().substring(0, 10),
            ),
          ),
          const SizedBox(height: 25),

          // ---------------- Tables ----------------
          const Text(
            "Available Tables",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: tables.map((t) {
              final isSelected = selectedTable == t;

              return GestureDetector(
                onTap: selectedGuests == null
                    ? () => _showError("Choose number of guests first")
                    : () {
                        setState(() => selectedTable = t);
                      },
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 110),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                  decoration: selectorStyle(isSelected),
                  child: Text(
                    t,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 25),

          // ---------------- Time Slots ----------------
          const Text(
            "Time Slots",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: timeSlots.map((time) {
              final isSelected = selectedTime == time;

              return GestureDetector(
                onTap: () {
                  if (selectedGuests == null) {
                    _showError("Choose number of guests first");
                    return;
                  }
                  setState(() => selectedTime = time);
                },
                child: Container(
                  constraints:
                      const BoxConstraints(minWidth: 100, maxWidth: 130),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: selectorStyle(isSelected),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 18,
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        time,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 30),

          // ---------------- Confirm Button ----------------
          SizedBox(
            height: 55,
            child: ElevatedButton(
              onPressed: () {
                if (selectedGuests == null ||
                    selectedDate == null ||
                    selectedTable == null ||
                    selectedTime == null) {
                  _showError("Please complete all fields");
                  return;
                }

                print("Booking Details:");
                print("Restaurant ID: $restaurantId");
                print("Guests: $selectedGuests");
                print("Date: $selectedDate");
                print("Table: $selectedTable");
                print("Time: $selectedTime");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF83B01),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Confirm Booking",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  List<String> _getAvailableTables(int guests) {
    if (guests <= 2) return ["Table 1", "Table 2", "Table 3"];
    if (guests <= 4) return ["Table 4", "Table 5"];
    return ["Table 6", "Table 7"];
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 1)),
    );
  }
}
