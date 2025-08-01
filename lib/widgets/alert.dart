
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musaafir/utils/screensize.dart';

import '../utils/constants.dart';


class Notifyalert extends StatelessWidget {
  const Notifyalert(
      {super.key,
      required this.onpressed,
      required this.title,
      required this.btntitle,
      required this.details});

  final Function()? onpressed;
  final String? details;
  final String? title;
  final String? btntitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AlertDialog(
        contentPadding: const EdgeInsets.all(30),
        backgroundColor: const Color.fromARGB(255, 237, 238, 241),
        content: SizedBox(
          height: 200,
          width: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              
              
              Text(
                title!,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 23,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                details!,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
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
                    onPressed: onpressed,
                    child: 
                    Text(
                      btntitle!,
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
    );
  }
}
