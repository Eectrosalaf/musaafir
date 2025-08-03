
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:musaafir/screens/details.dart';
import 'package:musaafir/screens/forgotpassword.dart';
import 'package:musaafir/screens/home.dart';
import 'package:musaafir/screens/login.dart';
import 'package:musaafir/screens/signup.dart';
import 'package:musaafir/screens/view.dart';

import 'screens/splash.dart';
import 'screens/onboarding.dart';
//import 'screens/login.dart'; // Assuming you have a login screen

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Travenor',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/',
      routes: {
        '/home': (context) => const HomeScreen(),
        '/': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(), 
        '/signup': (context) => const SignupScreen(),
        '/forgotpassword': (context) => const ForgotPasswordScreen(),
         
        '/details': (context) => const DetailsScreen(),
        '/view': (context) => const ViewScreen(),
      },
    );
  }
}
// ...remove the MyHomePage class...