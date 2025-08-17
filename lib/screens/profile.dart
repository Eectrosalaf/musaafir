import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../utils/screensize.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<UserProvider>(context, listen: false).fetchUserData(),
    );
  }
 FirebaseAuth firebaseAuth = FirebaseAuth.instance;
   Future<void> signOut() async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final userProvider = Provider.of<UserProvider>(context);

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                        onPressed: () => Navigator.pushReplacementNamed(context, '/main'),
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
                SizedBox(height: SizeConfig.blockV! * 2),
                // Avatar and name/email
                CircleAvatar(
                  radius: SizeConfig.blockH! * 8,
                  backgroundColor: Colors.pink[100],
                  child: Icon(
                    Icons.person,
                    size: SizeConfig.blockH! * 10,
                    color: Colors.blueGrey,
                  ),
                ),
                SizedBox(height: SizeConfig.blockV! * 2),
                Text(
                  userProvider.isLoading
                      ? "..."
                      : "${userProvider.firstName ?? ''} ${userProvider.lastName ?? ''}".trim().isEmpty 
                          ? (userProvider.userName ?? "User")
                          : "${userProvider.firstName ?? ''} ${userProvider.lastName ?? ''}".trim(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: SizeConfig.blockH! * 5,
                  ),
                ),
                SizedBox(height: SizeConfig.blockV! * 1),
                Text(
                  userProvider.isLoading
                      ? "..."
                      : (userProvider.userEmail ?? ""),
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
                       _ProfileMenuItem(
                        icon: Icons.logout_sharp,
                        label: "Sign Out",
                        onTap: () {
                          signOut();
                           Navigator.pushReplacementNamed(context, '/login');
                        },
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
            fontWeight: FontWeight.bold,
            fontSize: SizeConfig.blockH! * 4.5,
            color: color,
          ),
        ),
        SizedBox(height: SizeConfig.blockV! * 0.5),
        Text(
          label,
          style: TextStyle(
            color: Colors.black54,
            fontSize: SizeConfig.blockH! * 3,
          ),
          textAlign: TextAlign.center,
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
      leading: Icon(icon, color: Colors.black54),
      title: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}