import 'package:demoapp/components/llist_tiles.dart';
import 'package:demoapp/screens/HomeScreen2.dart';
import 'package:demoapp/screens/MaterialScreen.dart';
import 'package:demoapp/screens/Profile_Screen.dart';
import 'package:demoapp/screens/Profile_Screen2.dart';
import 'package:demoapp/screens/chat_screen.dart';
import 'package:demoapp/screens/chat_screen2.dart';
import 'package:demoapp/screens/login_screen.dart';
import 'package:demoapp/screens/selectuser.dart';
import 'package:demoapp/screens/view_job.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyDrawer2 extends StatelessWidget {
  const MyDrawer2({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    return Drawer(
      backgroundColor: Colors.redAccent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const DrawerHeader(
                  child: Icon(
                Icons.person,
                color: Colors.white,
                size: 64,
              )),
              MyListTile(
                icon: Icons.home,
                text: 'H O M E',
                onTap: () => Navigator.pop(context),
              ),
              MyListTile(
                icon: Icons.person,
                text: 'P R O F I L E',
                onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ProfileScreen2())),
              ),
              MyListTile(
                icon: Icons.settings,
                text: 'S E T T I N G S',
                onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => HomeScreen2())),
              ),
              MyListTile(
                icon: Icons.person_search,
                text: 'V I E W J O BS',
                onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => JobListPage())),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 25.0),
            child: MyListTile(
              icon: Icons.logout,
              text: 'L O G O U T',
              onTap: () async {
                await auth.signOut();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => SelectionScreen()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
