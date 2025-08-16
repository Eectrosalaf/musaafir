import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/screensize.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: Column(
          children: [
            // Top image with rounded bottom
            ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
              child: Image.asset(
                'images/aa.jpg',
                width: SizeConfig.screenW,
                height: SizeConfig.screenH! * 0.5,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.blockH! * 6,
                  vertical: SizeConfig.blockV! * 2,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Details title row
                    Row(
                      children: [
                        Text(
                          "Niladri Reservoir",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: SizeConfig.blockH! *5.5,
                          ),
                        ),
                        const Spacer(),
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          child:Image.asset('images/aaaa.webp')  //AssetImage('images/aaaa.webp'),
                        ),
                      ],
                    ),
                    SizedBox(height: SizeConfig.blockV! * 2),
                    // Title and rating
                    
                    SizedBox(height: SizeConfig.blockV! * 0.5),
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            color: DesignColors.primaryColor, size: 18),
                        SizedBox(width: 4),
                        Text(
                          "Tekergat, Sunamgj",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: SizeConfig.blockH! * 3.5,
                          ),
                        ),
                        const Spacer(),
                        Icon(Icons.star, color: Colors.amber, size: 18),
                        SizedBox(width: 2),
                        Text(
                          "4.7 (2498)",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: SizeConfig.blockH! * 3.5,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          "550/Person",
                          style: TextStyle(
                            color: DesignColors.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: SizeConfig.blockH! * 3.5,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: SizeConfig.blockV! * 2),
                    // Avatars row
                    SizedBox(
                      height: SizeConfig.blockV! * 6,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: List.generate(
                          6,
                          (i) => Padding(
                            padding: EdgeInsets.all(8),
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage: AssetImage('images/aaa.jpg',),
                              radius: SizeConfig.blockH! * 8,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: SizeConfig.blockV! * 2),
                    // About
                    Text(
                      "About Destination",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.blockH! * 4,
                      ),
                    ),
                    SizedBox(height: SizeConfig.blockV! * 1),
                    Text(
                      "You will get a complete travel package on the beaches. Packages in the form of airline tickets, recommended hotel rooms, transportation. Have you ever been on holiday to the Greek ETC... Read More",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: SizeConfig.blockH! * 3.5,
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: DesignColors.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: SizeConfig.blockV! * 2),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/view');
                        },
                        child: Text(
                          "Book Now",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: SizeConfig.blockH! * 4.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}