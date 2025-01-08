import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demoapp/screens/homescreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserManagement {
  Future<void> storeNewUser(User user, BuildContext context) async {
    User? firebaseUser = await FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      await FirebaseFirestore.instance
          .collection('AlumniData')
          .doc(firebaseUser.uid)
          .set({'email': user.email, 'uid': user.uid}).then((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }).catchError((e) {
        print("Error storing user data: $e");
      });
    } else {
      print("Firebase user is null");
    }
  }
}
