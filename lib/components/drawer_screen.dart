import 'package:demoapp/components/colors.dart';
import 'package:demoapp/components/llist_tiles.dart';
import 'package:demoapp/screens/Profile_Screen.dart';
import 'package:demoapp/screens/chat_screen.dart';
import 'package:demoapp/screens/login_screen.dart';
import 'package:demoapp/screens/selectuser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    return Drawer(
      backgroundColor: primarycolor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const DrawerHeader(
                  child: Icon(
                Icons.person,
                color: fourthcolor,
                size: 64,
              )),
              Column(children: [
                MyListTile(
                  icon: Icons.home,
                  text: 'H O M E',
                  onTap: () => Navigator.pop(context),
                ),
                Divider(
                  color: fourthcolor, // Set the color of the divider
                  thickness: 1.0, // Set the thickness of the divider
                  height: 1.0, // Set the height of the divider
                ),
                MyListTile(
                  icon: Icons.person,
                  text: 'P R O F I L E',
                  onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ProfileScreen())),
                ),
                Divider(
                  color: Colors.white, // Set the color of the divider
                  thickness: 1.0, // Set the thickness of the divider
                  height: 1.0, // Set the height of the divider
                ),
                MyListTile(
                  icon: Icons.settings,
                  text: 'S E T T I N G S',
                  onTap: () => Navigator.pop(context),
                ),
                Divider(
                  color: Colors.white, // Set the color of the divider
                  thickness: 1.0, // Set the thickness of the divider
                  height: 1.0, // Set the height of the divider
                ),
                MyListTile(
                  icon: Icons.chat,
                  text: 'D I S C U S S I O N',
                  onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ChatScreen())),
                ),
                Divider(
                  color: Colors.white, // Set the color of the divider
                  thickness: 1.0, // Set the thickness of the divider
                  height: 1.0, // Set the height of the divider
                ),
              ]),
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
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset('assets/wave.png'),
            height: 100,
          ),
        ],
      ),
    );
  }
}
