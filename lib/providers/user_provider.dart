import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'firstName': firstName ?? this.firstName,
        'lastName': lastName ?? this.lastName,
        'location': location ?? this.location,
        'mobile': mobile ?? this.mobile,
      });
      await fetchUserData();
    }
  }
}