import 'package:flutter/material.dart';
import 'package:restaurant_reservation_app/customer_app/screens/bookings_list.dart';
import 'package:restaurant_reservation_app/customer_app/screens/favorite.dart';
import 'package:restaurant_reservation_app/customer_app/screens/profile.dart';
import 'package:restaurant_reservation_app/customer_app/screens/restaurants.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    RestaurantsScreen(),
    Favorite(),
    BookingsList(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],

      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(vertical: 2),
        // padding: const EdgeInsets.all(12.0), // ⬅️ Add padding around the bar
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
            bottomLeft: Radius.circular(
              25,
            ), // Optional — remove if you want top only
            bottomRight: Radius.circular(25), // Optional
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Color(0xffF83B01),
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.white,
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.table_restaurant_rounded),
                label: "Restaurant",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border),
                label: "Favorite",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bookmark_added_rounded),
                label: "Booked",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: "Profile",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
