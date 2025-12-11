import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BookingsList extends StatelessWidget {
  final List<Map<String, dynamic>> bookings = const [
    {
      'restaurant': 'Pizza King',
      'table': 'Table 6',
      'date': '2025-12-10',
      'time': '5:00 PM',
    },
    {
      'restaurant': 'Sushi House',
      'table': 'Table 3',
      'date': '2025-12-11',
      'time': '7:30 PM',
    },
    {
      'restaurant': 'Sushi House',
      'table': 'Table 3',
      'date': '2025-12-11',
      'time': '7:30 PM',
    },
  ];

  const BookingsList({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];
      
          return Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  // Restaurant Icon
                  Container(
                    height: 55,
                    width: 55,
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.restaurant, color: Colors.deepOrange),
                  ),
      
                  const SizedBox(width: 14),
      
                  // Booking details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking['restaurant'],
                          style: GoogleFonts.poppins(
                            color: Color(0xffF83B01),
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
      
                        Row(
                          children: [
                            const Icon(Icons.chair, size: 18, color: Colors.grey),
                            const SizedBox(width: 6),
                            Text(
                              booking['table'],
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
      
                        const SizedBox(height: 4),
      
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              size: 18,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              booking['date'],
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
      
                        const SizedBox(height: 4),
      
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 18,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              booking['time'],
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
      
                 
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
