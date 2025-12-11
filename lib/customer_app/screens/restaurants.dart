import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant_reservation_app/customer_app/custom-widgets/card.dart';
import 'package:restaurant_reservation_app/customer_app/custom-widgets/title.dart';

class RestaurantsScreen extends StatefulWidget {
  RestaurantsScreen({super.key});

  @override
  State<RestaurantsScreen> createState() => _RestaurantsScreenState();
}

class _RestaurantsScreenState extends State<RestaurantsScreen> {
  List<String> categories = [
    'Fast Food',
    'Pizza',
    'Chinese',
    'Sushi',
    'Healthy',
  ];

  List<Map<String, dynamic>> restaurants = [
    {
      'id': '1',
      'name': 'Pizza King',
      'image': 'assets/images.jpeg',
      'desc':
          'A cozy place for families and friends.A cozy place for families and friends.A cozy place for families and friends.A cozy place for families and friends.',
    },
    {
      'id': '2',

      'name': 'Food City',
      'image': 'assets/images.jpeg',
      'desc': 'Best fast food in town!',
    },
    {
      'id': '3',

      'name': 'Sushi House',
      'image': 'assets/images.jpeg',
      'desc': 'Fresh Japanese sushi everyday!',
    },
    {
      'id': '4',
      'name': 'Sushi House',
      'image': 'assets/images.jpeg',
      'desc': 'Fresh Japanese sushi everyday!',
    },
    {
      'id': '5',
      'name': 'Sushi House',
      'image': 'assets/images.jpeg',
      'desc': 'Fresh Japanese sushi everyday!',
    },
    {
      'id': '6',
      'name': 'Sushi House',
      'image': 'assets/images.jpeg',
      'desc': 'Fresh Japanese sushi everyday!',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        toolbarHeight: 70,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Color(0xffF83B01),
              child: Icon(Icons.restaurant, color: Colors.white),
            ),
            SizedBox(width: 12),
            Text(
              "Welcome back ",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            Spacer(),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.settings, color: Colors.black87),
            ),
            IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Logged out successfully")),
                );

                // Navigate to login screen
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
              },
              icon: Icon(Icons.logout, color: Colors.black87),
            ),
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTitle(title: "Restaurants"),

            // 🔍 Modern Search Bar
            Container(
              margin: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Colors.black87),
                  hintText: 'Search restaurants...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(15),
                ),
              ),
            ),

            SizedBox(height: 20),
            Text(
              "Categories",
              style: GoogleFonts.poppins(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),

            // ⭐ Category Chips
            Container(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ...categories.map(
                    (category) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xffF83B01),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          category,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 10),

            // 🔥 Restaurants List
            Expanded(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: restaurants.length,
                itemBuilder: (context, index) {
                  return CustomCard(
                    id: restaurants[index]['id'],
                    name: restaurants[index]['name'],
                    image: restaurants[index]['image'],
                    desc: restaurants[index]['desc'],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
