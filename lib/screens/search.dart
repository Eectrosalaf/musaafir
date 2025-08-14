import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/screensize.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Search',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => Navigator.pushReplacementNamed(context, '/main'),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Colors.deepOrange,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          Padding(
            padding: EdgeInsets.all(SizeConfig.blockH! * 4),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search Places",
                hintStyle: TextStyle(
                  color: Colors.grey[500],
                  fontSize: SizeConfig.blockH! * 4,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey[500],
                  size: SizeConfig.blockH! * 5,
                ),
                suffixIcon: Icon(
                  Icons.mic_none,
                  color: Colors.grey[700],
                  size: SizeConfig.blockH! * 5,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.blockH! * 4,
                  vertical: SizeConfig.blockV! * 1.5,
                ),
              ),
            ),
          ),
          
          // Search Places Title
          Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockH! * 4),
            child: Text(
              'Search Places',
              style: TextStyle(
                fontSize: SizeConfig.blockH! * 5,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          
          SizedBox(height: SizeConfig.blockV! * 2),
          
          // Places Grid
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockH! * 4),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: SizeConfig.blockH! * 3,
                mainAxisSpacing: SizeConfig.blockV! * 2,
                childAspectRatio: 0.85,
                children: [
                  _buildPlaceCard(
                    'images/a.jpg',
                    'Niladri Reservoir',
                    'Tekergat, Sunamganj',
                    '\$59/Person',
                  ),
                  _buildPlaceCard(
                    'images/aa.jpg',
                    'Casa Las Tirtugas',
                    'Av Damero, Mexico',
                    '\$89/Person',
                  ),
                  _buildPlaceCard(
                    'images/aaa.jpg',
                    'Aoraki Mount',
                    'South Island, New Zealand',
                    '\$125/Person',
                  ),
                  _buildPlaceCard(
                    'images/a.jpg',
                    'Crocosaurus Cove',
                    'Darwin, Australia',
                    '\$99/Person',
                  ),
                  _buildPlaceCard(
                    'images/a.jpg',
                    'Niladri Reservoir',
                    'Tekergat, Sunamganj',
                    '\$59/Person',
                  ),
                  _buildPlaceCard(
                    'images/aa.jpg',
                    'Casa Las Tirtugas',
                    'Av Damero, Mexico',
                    '\$89/Person',
                  ),
                  _buildPlaceCard(
                    'images/aaa.jpg',
                    'Aoraki Mount',
                    'South Island, New Zealand',
                    '\$125/Person',
                  ),
                  _buildPlaceCard(
                    'images/a.jpg',
                    'Crocosaurus Cove',
                    'Darwin, Australia',
                    '\$99/Person',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceCard(String imagePath, String title, String location, String price) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                  onError: (exception, stackTrace) {
                    // Fallback for missing images
                  },
                ),
                color: Colors.grey[300], // Fallback color
              ),
            ),
          ),
          
          // Content
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.all(SizeConfig.blockH! * 3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: SizeConfig.blockH! * 3.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: SizeConfig.blockH! * 3,
                        color: Colors.grey[600],
                      ),
                      SizedBox(width: SizeConfig.blockH! * 1),
                      Expanded(
                        child: Text(
                          location,
                          style: TextStyle(
                            fontSize: SizeConfig.blockH! * 2.8,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    price,
                    style: TextStyle(
                      fontSize: SizeConfig.blockH! * 3.2,
                      fontWeight: FontWeight.w600,
                      color: DesignColors.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}