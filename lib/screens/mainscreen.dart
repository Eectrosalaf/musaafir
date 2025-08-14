import 'package:flutter/material.dart';
import 'package:musaafir/screens/calendar.dart';
import 'package:musaafir/screens/home.dart';
import 'package:musaafir/screens/messagelist.dart';
import 'package:musaafir/screens/profile.dart';
import 'package:musaafir/screens/search.dart';
import 'package:musaafir/utils/constants.dart';

class MainNav extends StatefulWidget {
  const MainNav({super.key});

  @override
  State<MainNav> createState() => _MainNavState();
}

class _MainNavState extends State<MainNav> {
  final List<Widget> screens = [
    HomeScreen(),
    CalendarScreen(),
    SearchScreen(),
    MessagesScreen(),
    ProfileScreen(),
  ];

  int currentScreen = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentScreen],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: DesignColors.primaryColor, // Custom selected color
        unselectedItemColor: Colors.grey, // Custom unselected color
        type: BottomNavigationBarType.fixed, // For more than 3 items
        showUnselectedLabels: true, // Always show labels
        currentIndex: currentScreen,
        onTap: (value) {
          setState(() {
            currentScreen = value;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 42),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_rounded, size: 42),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_rounded, size: 42),
            label: 'search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message_rounded, size: 42),
            label: 'Message',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 42),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
