// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:musaafir/services/auth.dart';
import 'package:musaafir/services/google_auth.dart';
import 'package:musaafir/widgets/alert.dart';
import '../utils/constants.dart';
import '../utils/screensize.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscure = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  AuthenticationMethods authenticationMethods = AuthenticationMethods();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.blockH! * 7,
              vertical: SizeConfig.blockV! * 4,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      onPressed: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                    ),
                  ),
                ),
                SizedBox(height: SizeConfig.blockV! * 2),
                Text(
                  "Sign in now",
                  style: TextStyle(
                    fontSize: SizeConfig.blockH! * 6,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: SizeConfig.blockV! * 2),
                Text(
                  "Please sign in to continue our app",
                  style: TextStyle(
                    fontSize: SizeConfig.blockH! * 4,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: SizeConfig.blockV! * 4),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: "enter gmail",
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: SizeConfig.blockV! * 2),
                TextField(
                  obscureText: _obscure,
                  controller: passwordController,
                  decoration: InputDecoration(
                    hintText: "Enter password",
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscure
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: Colors.grey,
                      ),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                ),
                SizedBox(height: SizeConfig.blockV! * 1),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, '/forgotpassword'),
                    child: const Text("Forgot Password?"),
                  ),
                ),
                SizedBox(height: SizeConfig.blockV! * 1),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: DesignColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: SizeConfig.blockV! * 1.5,
                      ),
                    ),
                    onPressed: () async {
                      String output = await authenticationMethods.signInUser(
                        email: emailController.text,
                        password: passwordController.text,
                      );

                      emailController.clear();

                      passwordController.clear();

                      if (output == 'success') {
                        Navigator.pushNamed(
                          // ignore: use_build_context_synchronously
                          context,
                          '/main',
                        );
                      } else {
                        showDialog(
                          // ignore: use_build_context_synchronously
                          context: context,
                          builder: (context) {
                            return AnimatedContainer(
                              duration: const Duration(seconds: 10),
                              curve: Curves.linearToEaseOut,
                              child: Notifyalert(
                                onpressed: () {
                                  Navigator.pushNamed(context, '/login');
                                },
                                title: 'Opps!',
                                btntitle: 'Log in Again',
                                details: output,
                              ),
                            );
                          },
                        );
                      }
                    },
                    child: Text(
                      "Log In",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: SizeConfig.blockH! * 4.5,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: SizeConfig.blockV! * 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        fontSize: SizeConfig.blockH! * 3.5,
                        color: Colors.black54,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/signup'),
                      child: Text(
                        "Sign up",
                        style: TextStyle(
                          color: DesignColors.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: SizeConfig.blockH! * 3.5,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: SizeConfig.blockV! * 2),

                SizedBox(height: SizeConfig.blockV! * 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: DesignColors.activeTextColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: SizeConfig.blockV! * 1,
                      ),
                    ),
                    onPressed: () async {
                      String output = await GoogleSignInService()
                          .signInWithGoogle();
                      if (output == 'success') {
                        Navigator.pushReplacementNamed(context, '/main');
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Google Sign-In Failed'),
                            content: Text(output),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _socialIcon(Colors.blue),

                        Text(
                          "Continue with Google",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: SizeConfig.blockH! * 4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _socialIcon(Color color) {
    return CircleAvatar(
      backgroundColor: color.withOpacity(0.1),
      radius: SizeConfig.blockH! * 5,
      child: Image.asset(
        'images/ab.webp',
        height: SizeConfig.blockH! * 7,
        width: SizeConfig.blockH! * 7,
      ),

      //Icon(icon, color: color, size: SizeConfig.blockH! * 8),
    );
  }
}
