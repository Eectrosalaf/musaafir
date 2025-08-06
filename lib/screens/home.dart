import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/screensize.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? userName;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    fetchUserName();
  }

  Future<void> fetchUserName() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .get();
        setState(() {
          userName = doc.data()?['name'] ?? 'User';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        userName = 'User';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),

      body: SafeArea(
        child: SingleChildScrollView(
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
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: SizedBox(
                        width: SizeConfig.blockV! * 20,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: DesignColors.activeTextColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                SizeConfig.blockH! * 4,
                              ),
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
                                padding: const EdgeInsets.only(
                                  left: 3,
                                  right: 4,
                                ),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: SizeConfig.blockH! * 4,
                                  child: Icon(
                                    Icons.person,
                                    color: DesignColors.primaryColor,
                                  ),
                                ),
                              ),

                              Text(
                                isLoading ? "..." : (userName ?? "User"),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: SizeConfig.blockH! * 3.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    CircleAvatar(
                      backgroundColor: DesignColors.backgroundColorInactive,
                      radius: SizeConfig.blockV! * 2.5,
                      child: IconButton(
                        icon: Icon(
                          Icons.notifications_none,
                          color: DesignColors.primaryColor,
                          size: SizeConfig.blockH! * 7,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
                SizedBox(height: SizeConfig.blockV! * 3),
                // Title
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: SizeConfig.blockH! * 9,
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
                SizedBox(height: SizeConfig.blockV! * 2.5),
                // Best Destination Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Best Destination",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.blockH! * 5,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "View all",
                        style: TextStyle(
                          color: DesignColors.primaryColor,
                          fontSize: SizeConfig.blockH! * 4,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: SizeConfig.blockV! * 2),
                // Horizontal List of Destinations
                SizedBox(
                  height: SizeConfig.blockV! * 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _DestinationCard(
                        image: 'images/aa.jpg',
                        title: isLoading ? "..." : (userName ?? "User"),
                        location: 'Tekergat, Sunamgj',
                        rating: 4.7,
                        onTap: () {
                          Navigator.pushNamed(context, '/details');
                        },
                      ),
                      SizedBox(width: SizeConfig.blockH! * 4),
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
        // height: 10,//SizeConfig.blockH! * 70,
        width: SizeConfig.blockH! * 55,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 8),
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
                height: SizeConfig.blockV! * 30,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(SizeConfig.blockH! * 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: SizeConfig.blockH! * 4,
                        ),
                      ),

                      SizedBox(width: SizeConfig.blockV! * 5),

                      Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: SizeConfig.blockH! * 4,
                      ),
                      Text(
                        rating.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: SizeConfig.blockH! * 4,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: SizeConfig.blockV! * 1.5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.location_on,
                        color: DesignColors.primaryColor,
                        size: 14,
                      ),
                      //SizedBox(width: 2),
                      Text(
                        location,
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: SizeConfig.blockH! * 3,
                        ),
                      ),

                      SizedBox(width: SizeConfig.blockH! * 4),
                      AvatarStack(
                        avatarImages: [
                          'images/a.jpg',
                          'images/a.jpg',
                          'images/a.jpg',
                        ],
                        extraCount: 50,
                        size: SizeConfig.blockH! * 7,
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

class AvatarStack extends StatelessWidget {
  final List<String> avatarImages; // List of asset paths
  final int extraCount;
  final double size;

  const AvatarStack({
    super.key,
    required this.avatarImages,
    required this.extraCount,
    this.size = 28,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> avatars = [];
    for (int i = 0; i < avatarImages.length; i++) {
      avatars.add(
        Positioned(
          left: i * (size * 0.6),
          child: CircleAvatar(
            radius: size / 2,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: size / 2 - 2,
              backgroundImage: AssetImage(avatarImages[i]),
            ),
          ),
        ),
      );
    }
    // Add the "+N" circle
    avatars.add(
      Positioned(
        left: avatarImages.length * (size * 0.6),
        child: CircleAvatar(
          radius: size / 2,
          backgroundColor: Colors.white,
          child: CircleAvatar(
            radius: size / 2 - 2,
            backgroundColor: Colors.blue[50],
            child: Text(
              '+$extraCount',
              style: TextStyle(
                fontSize: size * 0.45,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );

    return SizedBox(
      width: (avatarImages.length + 1) * (size * 0.6) + size * 0.4,
      height: size,
      child: Stack(children: avatars),
    );
  }
}
