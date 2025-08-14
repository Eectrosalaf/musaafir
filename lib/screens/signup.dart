// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:musaafir/services/auth.dart';
import 'package:musaafir/services/google_auth.dart';
import 'package:musaafir/widgets/alert.dart';
import '../utils/constants.dart';
import '../utils/screensize.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _obscure = true;
  TextEditingController nameController = TextEditingController();
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
                      onPressed: () => Navigator.pushNamed(context, '/login'),
                      //() => Navigator.of(context).pop(),
                    ),
                  ),
                ),
                SizedBox(height: SizeConfig.blockV! * 2),
                Text(
                  "Sign up now",
                  style: TextStyle(
                    fontSize: SizeConfig.blockH! * 4,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: SizeConfig.blockV! * 1.5),
                Text(
                  "Please fill the details and create account",
                  style: TextStyle(
                    fontSize: SizeConfig.blockH! * 4,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: SizeConfig.blockV! * 4),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: "Enter your name",
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
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: "Enter your email",
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
                  controller: passwordController,
                  obscureText: _obscure,
                  decoration: InputDecoration(
                    hintText: "Enter your password",
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
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Password must be 8 character",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: SizeConfig.blockH! * 3.5,
                    ),
                  ),
                ),
                SizedBox(height: SizeConfig.blockV! * 2),
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
                      
                      String output = await authenticationMethods.signUpUser(
                        name: nameController.text,
                        email: emailController.text,
                        password: passwordController.text,
                      );
                       
                    

                      if (output == 'success') {
                        const Center(child: CircularProgressIndicator(color: Colors.blue,));
                        nameController.clear();
                        emailController.clear();
                        passwordController.clear();
                        showDialog(
                          // ignore: use_build_context_synchronously
                          context: context,
                          builder: (context) {
                            return AnimatedContainer(
                              duration: const Duration(seconds: 3),
                              curve: Curves.linearToEaseOut,
                              child: Notifyalert(
                                onpressed: () {
                                  Navigator.pushNamed(context, '/login');
                                },
                                title: 'Congratulations',
                                btntitle: 'Go to Log in',
                                details:
                                    'You have successfully Registered your account.',
                              ),
                            );
                          },
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
                                  Navigator.pushNamed(context, '/signup');
                                },
                                title: 'Opps!',
                                btntitle: 'Sign Up Again',
                                details: output,
                              ),
                            );
                          },
                        );

                        nameController.clear();
                        emailController.clear();

                        passwordController.clear();
                      }
                    },
                    child: Text(
                      "Sign Up  ",
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
                      "Already have an account? ",
                      style: TextStyle(
                        fontSize: SizeConfig.blockH! * 3.5,
                        color: Colors.black54,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/login'),
                      child: Text(
                        "Sign in",
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
                          // ignore: use_build_context_synchronously
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
                        _socialIcon(Colors.red),
                        // SizedBox(width: SizeConfig.blockH! * 8),
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
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     _socialIcon(Icons.facebook, Colors.blue),
                //     SizedBox(width: SizeConfig.blockH! * 4),
                //     _socialIcon(Icons.camera_alt, Colors.pink),
                //     SizedBox(width: SizeConfig.blockH! * 4),
                //     _socialIcon(Icons.alternate_email, Colors.lightBlue),
                //   ],
                //),
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
        height: SizeConfig.blockV! * 20,
        width: SizeConfig.blockV! * 20,
      ),

      //Icon(icon, color: color, size: SizeConfig.blockH! * 8),
    );
  }
}
