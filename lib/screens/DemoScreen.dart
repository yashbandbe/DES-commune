import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demoapp/components/user_model2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  User? user = FirebaseAuth.instance.currentUser;
  UserModel2 loggedInUser = UserModel2();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("AlumniData")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel2.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: Text(currentUser.email!),
            // child: Text(currentUser.email!)
          ),
          Text("${loggedInUser.firstName} ${loggedInUser.secondName}"),
          Text("${loggedInUser.email}"),
        ],
      ),
    );
  }
}
