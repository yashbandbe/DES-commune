import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demoapp/components/roundbutton.dart';
import 'package:demoapp/model/user_model.dart';
import 'package:demoapp/screens/homescreen.dart';
import 'package:demoapp/screens/login_screen.dart';
import 'package:demoapp/screens/profile_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ref = FirebaseFirestore.instance.collection("users");

  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (_) => ProfileController(),
        child: Consumer<ProfileController>(builder: (context, Provider, child) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('users').snapshots(),
                // user.userData!['userType'] == "alumni" ? 'Alumni' : 'users').snapshots(),

                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Something went wrong'));
                  } else {
                    List<DocumentSnapshot> documents = snapshot.data!.docs;

                    // Assuming there's only one document for the user
                    DocumentSnapshot userData = documents.first;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Center(
                                child: Container(
                                  height: 130,
                                  width: 120,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.black, width: 6)),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Provider.image == null
                                          ? userData['profile'].toString() == ""
                                              ? Icon(
                                                  Icons.person,
                                                  size: 35,
                                                )
                                              : Image(
                                                  fit: BoxFit.cover,
                                                  image: NetworkImage(
                                                      userData['profile']
                                                          .toString()),
                                                  loadingBuilder: (context,
                                                      child, loadingProgress) {
                                                    if (loadingProgress == null)
                                                      return child;
                                                    return Center(
                                                        child:
                                                            CircularProgressIndicator());
                                                  },
                                                  errorBuilder:
                                                      (context, Object, Stack) {
                                                    return Container(
                                                      child: Icon(
                                                        Icons.error_outline,
                                                        color: Colors.red,
                                                      ),
                                                    );
                                                  })
                                          : Image.file(
                                              File(Provider.image!.path)
                                                  .absolute)),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Provider.pickImage(context);
                              },
                              child: CircleAvatar(
                                radius: 14,
                                child: Icon(
                                  Icons.add,
                                  size: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 40,
                            ),
                            ReusableRow(
                                title: "USERNAME",
                                value:
                                    "${loggedInUser.firstName} ${loggedInUser.secondName}",
                                iconData: Icons.person_outlined),
                            ReusableRow(
                                title: "Email",
                                value: "${loggedInUser.email} ",
                                iconData: Icons.email_outlined),
                            SizedBox(
                              height: 40,
                            ),
                            RoundButton(
                              title: 'Save',
                              onPress: () async {
                                auth.signOut().then((value) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HomeScreen()));
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          );
        }),
      ),
    );
  }
}

class ReusableRow extends StatelessWidget {
  final String title, value;
  final IconData iconData;
  const ReusableRow(
      {super.key,
      required this.title,
      required this.value,
      required this.iconData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(title),
          leading: Icon(iconData),
          trailing: Text(
            value,
            style: TextStyle(fontSize: 13),
          ),
        ),
        Divider(
          color: Colors.grey.shade300.withOpacity(1),
        )
      ],
    );
  }
}
