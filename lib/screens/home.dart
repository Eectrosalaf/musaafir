import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/screensize.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      bottomNavigationBar: _BottomNavBar(selectedIndex: 0),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.blockH! * 5,
            vertical: SizeConfig.blockV! * 2,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  SizedBox(
                  width: SizeConfig.blockV! * 15,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: DesignColors.activeTextColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(SizeConfig.blockH! * 4),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: SizeConfig.blockV! * 0.4,
                      ),
                    ),
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                         Padding(
                           padding: const EdgeInsets.only(left: 3,right: 4),
                           child: CircleAvatar(
                                               backgroundColor: Colors.white,
                                               radius: SizeConfig.blockH! * 4,
                                               child: Icon(Icons.person, color: DesignColors.primaryColor),
                                             ),
                         ),
                        //_socialIcon( Colors.red),
                        // SizedBox(width: SizeConfig.blockH! * 8),
                        Text(
                          "taiwo",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: SizeConfig.blockH! * 4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                 
                  CircleAvatar(
                    backgroundColor:DesignColors.backgroundColorInactive, 
                    radius: SizeConfig.blockH! * 4,
                    child: IconButton(
                      icon: Icon(Icons.notifications_none,
                          color: DesignColors.primaryColor,
                          size: SizeConfig.blockH! * 5),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              SizedBox(height: SizeConfig.blockV! * 2),
              // Title
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: SizeConfig.blockH! * 5.5,
                    fontWeight: FontWeight.bold,
                    color: DesignColors.textColor,
                  ),
                  children: [
                    const TextSpan(text: "Explore the\nBeautiful "),
                    TextSpan(
                      text: "world!",
                      style: TextStyle(color: DesignColors.primaryColor),
                    ),
                  ],
                ),
              ),
              SizedBox(height: SizeConfig.blockV! * 2),
              // Best Destination Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Best Destination",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: SizeConfig.blockH! * 4,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "View all",
                      style: TextStyle(
                        color: DesignColors.primaryColor,
                        fontSize: SizeConfig.blockH! * 3.5,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: SizeConfig.blockV! * 1),
              // Horizontal List of Destinations
              SizedBox(
                height: SizeConfig.blockV! * 28,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _DestinationCard(
                      image: 'images/aa.jpg',
                      title: 'Niladri Reservoir',
                      location: 'Tekergat, Sunamgj',
                      rating: 4.7,
                      onTap: () {
                        Navigator.pushNamed(context, '/details');
                      },
                    ),
                    SizedBox(width: SizeConfig.blockH! * 4),
                    _DestinationCard(
                      image: 'images/aaa.jpg',
                      title: 'Darma Reservoir',
                      location: 'Tekergat, Sunamgj',
                      rating: 4.5,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DestinationCard extends StatelessWidget {
  final String image, title, location;
  final double rating;
  final VoidCallback onTap;

  const _DestinationCard({
    required this.image,
    required this.title,
    required this.location,
    required this.rating,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: SizeConfig.blockH! * 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
              child: Image.asset(
                image,
                width: double.infinity,
                height: SizeConfig.blockV! * 15,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(SizeConfig.blockH! * 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: SizeConfig.blockH! * 4,
                    ),
                  ),
                  SizedBox(height: SizeConfig.blockV! * 0.5),
                  Row(
                    children: [
                      Icon(Icons.location_on,
                          color: DesignColors.primaryColor, size: 16),
                      SizedBox(width: 4),
                      Text(
                        location,
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: SizeConfig.blockH! * 3,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: SizeConfig.blockV! * 0.5),
                  Row(
                    children: [
                      Icon(Icons.star,
                          color: Colors.amber, size: SizeConfig.blockH! * 3),
                      SizedBox(width: 4),
                      Text(
                        rating.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: SizeConfig.blockH! * 3,
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
  }
}

class _BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  const _BottomNavBar({required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      selectedItemColor: DesignColors.primaryColor,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Calendar',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.message),
          label: 'Messages',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      onTap: (i) {
        // Handle navigation if needed
      },
    );
  }
}