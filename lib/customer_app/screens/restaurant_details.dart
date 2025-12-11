import 'package:flutter/material.dart';

class RestaurantDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final String id = args['id'];
    final String name = args['name'];
    final String image = args['image'];
    final String desc = args['desc'];

    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: Column(
        children: [
          Image.asset(image),
          Text("ID: $id"),
          Text(desc),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/book', arguments: args['id']);
            },
            child: Text('Book'),
          ),
        ],
      ),
    );
  }
}
