import 'package:flutter/material.dart';
import 'package:musaafir/services/auth.dart';
import 'package:musaafir/widgets/alert.dart';
import '../utils/constants.dart';
import '../utils/screensize.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  AuthenticationMethods authenticationMethods = AuthenticationMethods();
  TextEditingController emailController = TextEditingController();
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
                      onPressed: () => Navigator.of(context).maybePop(),
                    ),
                  ),
                ),
                SizedBox(height: SizeConfig.blockV! * 2),
                Text(
                  "Forgot password",
                  style: TextStyle(
                    fontSize: SizeConfig.blockH! * 6,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: SizeConfig.blockV! * 1.5),
                Text(
                  "Enter your email account to reset your password",
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
                    hintText: "www.uihut@gmail.com",
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: SizeConfig.blockV! * 3),
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
                      String output = await authenticationMethods.resetpassword(
                        email: emailController.text,
                      );

                      emailController.clear();

                      if (output == 'success') {
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
                                title: output,
                                btntitle: 'Log in Again',
                                details: 'check your email to reset password',
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
                              duration: const Duration(seconds: 9),
                              curve: Curves.linearToEaseOut,
                              child: Notifyalert(
                                onpressed: () {
                                  Navigator.pushNamed(context, '/signup');
                                },
                                title: 'Opps!',
                                btntitle: 'Reset Password Again',
                                details: output,
                              ),
                            );
                          },
                        );
                      }
                    },
                    child: Text(
                      "Reset Password",
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
      ),
    );
  }
}
