// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:demoapp/components/drawer_screen.dart';
// import 'package:demoapp/model/user_model.dart';
// import 'package:demoapp/screens/login_screen.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   User? user = FirebaseAuth.instance.currentUser;
//   UserModel loggedInUser = UserModel();

//   @override
//   void initState() {
//     super.initState();
//     FirebaseFirestore.instance
//         .collection("users")
//         .doc(user!.uid)
//         .get()
//         .then((value) {
//       this.loggedInUser = UserModel.fromMap(value.data());
//       setState(() {});
//     });
//   }

//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text("Welcome Home"),
//           centerTitle: true,
//         ),
//         body: Text("Hello World")
//         // Center(
//         //   child: Padding(
//         //     padding: EdgeInsets.all(20),
//         //     child: Column(
//         //       mainAxisAlignment: MainAxisAlignment.center,
//         //       crossAxisAlignment: CrossAxisAlignment.center,
//         //       // children: <Widget>[
//         //       //   Text("${loggedInUser.firstName} ${loggedInUser.secondName}"),
//         //       //   Text("${loggedInUser.email}"),
//         //       //   SizedBox(
//         //       //     height: 15,
//         //       //   ),
//         //       //   ActionChip(
//         //       //       label: Text("Logout"),
//         //       //       onPressed: () {
//         //       //         logout(context);
//         //       //       }),
//         //       // ],
//         //     ),
//         //   ),
//         // ),
//         );
//   }

//   Future<void> logout(BuildContext context) async {
//     await FirebaseAuth.instance.signOut();
//     Navigator.of(context).pushReplacement(
//         MaterialPageRoute(builder: (context) => LoginScreen()));
//   }
// }
