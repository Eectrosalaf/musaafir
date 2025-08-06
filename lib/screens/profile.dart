import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/screensize.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? userName;
  String? userEmail;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .get();
        setState(() {
          userName = doc.data()?['name'] ?? 'User';
          userEmail = doc.data()?['email'] ?? '';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        userName = 'User';
        userEmail = '';
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
              horizontal: SizeConfig.blockH! * 6,
              vertical: SizeConfig.blockV! * 2,
            ),
            child: Column(
              children: [
                // Top bar
                Padding(
                  padding: const EdgeInsets.only(top: 35),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded),
                          onPressed: () =>
                              Navigator.pushNamed(context, '/home'),
                        ),
                      ),
                      Text(
                        "Profile",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: SizeConfig.blockH! * 5,
                        ),
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            Navigator.pushNamed(context, '/editprofile');
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: SizeConfig.blockV! * 2),
                // Avatar and name/email
                CircleAvatar(
                  radius: SizeConfig.blockH! * 12,
                  backgroundColor: Colors.pink[100],
                  child: Icon(
                    Icons.person,
                    size: SizeConfig.blockH! * 10,
                    color: Colors.blueGrey,
                  ),
                ),
                SizedBox(height: SizeConfig.blockV! * 2),
                Text(
                  isLoading ? "..." : (userName ?? "User"),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: SizeConfig.blockH! * 5,
                  ),
                ),
                SizedBox(height: SizeConfig.blockV! * 1),
                Text(
                  isLoading ? "..." : (userEmail ?? ""),
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: SizeConfig.blockH! * 3.5,
                  ),
                ),
                SizedBox(height: SizeConfig.blockV! * 2),
                // Stats row
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: SizeConfig.blockV! * 2,
                    horizontal: SizeConfig.blockH! * 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _StatColumn(
                        label: "Reward Points",
                        value: "360",
                        color: Colors.orange,
                      ),
                      Container(
                        width: 1,
                        height: SizeConfig.blockV! * 4,
                        color: Colors.grey[300],
                      ),
                      _StatColumn(
                        label: "Travel Trips",
                        value: "238",
                        color: Colors.orange,
                      ),
                      Container(
                        width: 1,
                        height: SizeConfig.blockV! * 4,
                        color: Colors.grey[300],
                      ),
                      _StatColumn(
                        label: "Bucket List",
                        value: "473",
                        color: Colors.orange,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: SizeConfig.blockV! * 6),
                // Menu list
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    children: [
                      _ProfileMenuItem(
                        icon: Icons.person,
                        label: "Profile",
                        onTap: () {},
                      ),
                      _ProfileMenuItem(
                        icon: Icons.bookmark,
                        label: "Bookmarked",
                        onTap: () {},
                      ),
                      _ProfileMenuItem(
                        icon: Icons.history,
                        label: "Previous Trips",
                        onTap: () {},
                      ),
                      _ProfileMenuItem(
                        icon: Icons.settings,
                        label: "Settings",
                        onTap: () {},
                      ),
                      _ProfileMenuItem(
                        icon: Icons.info_outline,
                        label: "Version",
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                SizedBox(height: SizeConfig.blockV! * 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _StatColumn({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: SizeConfig.blockH! * 4,
          ),
        ),
        SizedBox(height: SizeConfig.blockV! * 0.5),
        Text(
          label,
          style: TextStyle(
            color: Colors.black54,
            fontSize: SizeConfig.blockH! * 3.2,
          ),
        ),
      ],
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ProfileMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: DesignColors.primaryColor),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: SizeConfig.blockH! * 3.8,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 18),
      onTap: onTap,
    );
  }
}
