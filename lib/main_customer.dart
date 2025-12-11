import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_reservation_app/customer_app/auth/login.dart';
import 'package:restaurant_reservation_app/customer_app/auth/signup.dart';
import 'package:restaurant_reservation_app/customer_app/screens/book_form.dart';
import 'package:restaurant_reservation_app/customer_app/screens/main_layout.dart';
import 'package:restaurant_reservation_app/customer_app/screens/restaurant_details.dart';
import 'package:restaurant_reservation_app/customer_app/screens/splash.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Splash(),
      routes: {
        '/login': (context) => Login(),
        '/signup': (context) => SignUp(),
        '/home': (context) => MainLayout(),
        '/restaurantDetails': (context) => RestaurantDetails(),
        '/book': (context) => BookForm(),
      },
    );
  }
}
