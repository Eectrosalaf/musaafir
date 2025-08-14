import 'package:firebase_auth/firebase_auth.dart';
import 'package:musaafir/models/usermodel.dart';
import 'package:musaafir/services/cloudfirestore.dart';




class AuthenticationMethods {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  CloudFirestoreClass cloudFirestoreClass = CloudFirestoreClass();

  Future<String> signUpUser(
      {required String name,
      required String email,
     
      required String password}) async {
    name.trim();
    
    email.trim();
    password.trim();

    String output = "Something went wrong";
    if (name != "" &&
        email != "" &&
        password != "") 
         {
      try {
        await firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password);
        UserDetailsModel user = UserDetailsModel(
            name: name,
           
            email: email);
        await cloudFirestoreClass.uploadNameAndAddressToDatabase(user: user);
        output = "success";
      } on FirebaseAuthException catch (e) {
        output = e.message.toString();
      }
    } else {
      output = "Please fill up all the fields.";
    }
    return output;
  }


Future<String> signInUser(
    {required String email, required String password}) async {
  email = email.trim();
  password = password.trim();

  String output = "Something went wrong";
  if (email.isNotEmpty && password.isNotEmpty) {
    try {
      print("Attempting to sign in with: $email");
      
      // Use a try-catch specifically for the type casting issue
      UserCredential? result;
      try {
        result = await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
      } catch (e) {
        if (e.toString().contains('PigeonUserDetails')) {
          // Workaround: Check if user is actually signed in
          await Future.delayed(const Duration(milliseconds: 500));
          if (firebaseAuth.currentUser != null) {
            print("Sign in successful despite casting error: ${firebaseAuth.currentUser!.uid}");
            return "success";
          }
        }
        rethrow;
      }
      
      if (result?.user != null) {
        print("Sign in successful: ${result!.user!.uid}");
        output = "success";
      }
    } on FirebaseAuthException catch (e) {
      print("Firebase Auth Error: ${e.code} - ${e.message}");
      output = e.message ?? "Authentication failed";
    } catch (e) {
      print("General Error: $e");
      output = "Authentication failed";
    }
  } else {
    output = "Please fill up all the fields.";
  }
  return output;
}
  Future<String> resetpassword({
    required String email,
  }) async {
    email.trim();

    String output = "Something went wrong";
    if (email != "") {
      try {
        await firebaseAuth.sendPasswordResetEmail(
          email: email,
        );
        
        output = "success";
      } on FirebaseAuthException catch (e) {
        output = e.message.toString();
      }
    } else {
      output = "Please fill up all the fields.";
    }
    return output;
  }
}