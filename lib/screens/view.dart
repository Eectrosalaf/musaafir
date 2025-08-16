import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/screensize.dart';

class ViewScreen extends StatelessWidget {
  const ViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Stack(
        children: [
          // Main image
          Image.asset(
            'images/aa.jpg',
            width: SizeConfig.screenW,
            height: SizeConfig.screenH,
            fit: BoxFit.cover,
          ),
          // Top bar
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.blockH! * 3,
                vertical: SizeConfig.blockV! * 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: DesignColors.primaryColor),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Text(
                    "View",
                    style: TextStyle(
                      color: DesignColors.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: SizeConfig.blockH! * 4.5,
                    ),
                  ),
                  SizedBox(width: SizeConfig.blockH! * 7), // For symmetry
                ],
              ),
            ),
          ),
          // Sliding Card
          DraggableScrollableSheet(
            initialChildSize: 0.32,
            minChildSize: 0.18,
            maxChildSize: 0.6,
            builder: (context, scrollController) => Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 12,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.blockH! * 6,
                vertical: SizeConfig.blockV! * 2,
              ),
              child: ListView(
                controller: scrollController,
                children: [
                  Row(
                    children: [
                      Text(
                        "Niladri Reservoir",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: SizeConfig.blockH! * 5,
                        ),
                      ),
                      const Spacer(),
                      Icon(Icons.star, color: Colors.amber, size: 18),
                      SizedBox(width: 2),
                      Text(
                        "4.7",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: SizeConfig.blockH! * 3.5,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: SizeConfig.blockV! * 1),
                  Row(
                   // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      SizedBox(width: 12),
                      Spacer(),
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
                  SizedBox(height: SizeConfig.blockV! * 2),
                  // Avatars row
                  Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.black54, size: 18),
                       Text(
                        "45 Minutes",
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: SizeConfig.blockH! * 3.5,
                        ),
                      ),
                    ],
                  ),
                      //SizedBox(width: 4),
                     
                  SizedBox(height: SizeConfig.blockV! * 2),
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
                      onPressed: () {},
                      child: Text(
                        "See On The Map",
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
          // Floating hotel/location cards
          Positioned(
            top: SizeConfig.screenH! * 0.22,
            left: SizeConfig.blockH! * 7,
            child: _FloatingCard(
              title: "La-Hotel",
              distance: "2.09 mi",
              image: 'images/aaaa.webp',
            ),
          ),
          Positioned(
            top: SizeConfig.screenH! * 0.32,
            left: SizeConfig.blockH! * 15,
            child: _FloatingCard(
              title: "Lemon Garden",
              distance: "2.09 mi",
              image: 'images/aaaa.webp',
            ),
          ),
        ],
      ),
    );
  }
}

class _FloatingCard extends StatelessWidget {
  final String title, distance, image;
  const _FloatingCard({
    required this.title,
    required this.distance,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(image),
              radius: 18,
            ),
            SizedBox(width: 8),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  distance,
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                ),
              ],
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
