import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomCard extends StatelessWidget {
  final String id;
  final String name;
  final String image;
  final String desc;

  const CustomCard({
    super.key,
    required this.id,
    required this.name,
    required this.image,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
            child: Image.asset(
              image,
              height: 100,
              width: 110,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: ListTile(
              title: Text(
                name,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xffF83B01),
                ),
              ),
              subtitle: Text(
                desc,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: IconButton(
                onPressed: () {
                  //  print(id) ;
                  Navigator.pushNamed(
                    context,
                    '/restaurantDetails',
                    arguments: {
                      'id': id,
                      'name': name,
                      'desc': desc,
                      'image': image,
                    },
                  );
                },
                icon: Icon(Icons.arrow_forward_ios_rounded),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
