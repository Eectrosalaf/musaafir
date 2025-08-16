// ignore_for_file: unnecessary_this

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProvider extends ChangeNotifier {
  String? userName;
  String? userEmail;
  String? firstName;
  String? lastName;
  String? location;
  String? mobile;
  bool isLoading = true;

  Future<void> fetchUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final data = doc.data();
      userName = data?['name'] ?? '';
      userEmail = data?['email'] ?? '';
      firstName = data?['firstName'] ?? '';
      lastName = data?['lastName'] ?? '';
      location = data?['location'] ?? '';
      mobile = data?['mobile'] ?? '';
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile({
    String? firstName,
    String? lastName,
    String? location,
    String? mobile,
  }) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      // Update the fields
      this.firstName = firstName ?? this.firstName;
      this.lastName = lastName ?? this.lastName;
      this.location = location ?? this.location;
      this.mobile = mobile ?? this.mobile;
      
      // Update userName to be firstName + lastName
      userName = "${this.firstName ?? ''} ${this.lastName ?? ''}".trim();
      
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'firstName': this.firstName,
        'lastName': this.lastName,
        'location': this.location,
        'mobile': this.mobile,
        'name': this.userName, // Also update the name field
      });
      
      notifyListeners(); // Notify listeners immediately
      await fetchUserData(); // Refresh from database
    }
  }
}