import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:musaafir/providers/calendar_provider.dart';
import 'package:musaafir/screens/calendar.dart';
import 'package:musaafir/screens/details.dart';
import 'package:musaafir/screens/editprofile.dart';
import 'package:musaafir/screens/forgotpassword.dart';
import 'package:musaafir/screens/login.dart';
import 'package:musaafir/screens/mainscreen.dart';
import 'package:musaafir/screens/messagelist.dart';
import 'package:musaafir/screens/onboarding.dart';
import 'package:musaafir/screens/signup.dart';
import 'package:musaafir/screens/splash.dart';
import 'package:musaafir/screens/view.dart';
import 'package:provider/provider.dart';
import 'providers/user_provider.dart';
import 'screens/home.dart';
import 'screens/profile.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => CalendarProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Musaafir',
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      routes: {
       '/home': (context) => const HomeScreen(),
          '/splash': (context) => const SplashScreen(),
          '/onboarding': (context) => const OnboardingScreen(),
          '/login': (context) => const LoginScreen(), 
          '/signup': (context) => const SignupScreen(),
          '/forgotpassword': (context) => const ForgotPasswordScreen(),
           '/profile': (context) => const ProfileScreen(),
           '/editprofile': (context) => const EditProfileScreen(),
          '/details': (context) => const DetailsScreen(),
          '/view': (context) => const ViewScreen(),
           '/main': (context) => const MainNav(),
           '/calendar': (context) => const CalendarScreen(),
          '/message': (context) => const MessagesScreen(),
      }
    );
  }
}