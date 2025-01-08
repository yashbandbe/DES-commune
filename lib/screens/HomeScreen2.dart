import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demoapp/components/admin_drawer.dart';
import 'package:demoapp/components/drawer_screen.dart';
import 'package:demoapp/screens/MaterialScreen.dart';
import 'package:demoapp/screens/Profile_Screen.dart';
import 'package:demoapp/screens/Profile_Screen2.dart';
import 'package:demoapp/screens/add_post_screen.dart';
import 'package:demoapp/screens/chat_screen2.dart';
import 'package:demoapp/screens/job_form.dart';
import 'package:demoapp/screens/login_screen.dart';
import 'package:demoapp/screens/updatescreen.dart';
import 'package:demoapp/screens/view_job.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:floating_bottom_bar/animated_bottom_navigation_bar.dart';
import 'package:provider/provider.dart';
import 'package:demoapp/screens/add_post_screen2.dart';

class HomeScreen2 extends StatefulWidget {
  const HomeScreen2({super.key});

  @override
  State<HomeScreen2> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen2> {
  final dbRef = FirebaseDatabase.instance.ref().child('Posts');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Feeds',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      drawer: MyDrawer2(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: FirebaseAnimatedList(
                query: dbRef.child('Post List'),
                itemBuilder: (BuildContext context, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
                  final post = (snapshot.value as Map<dynamic, dynamic>);
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 4.0, left: 4.0),
                                    child: CircleAvatar(
                                      radius: 15,
                                      backgroundColor: Colors.transparent,
                                      backgroundImage: NetworkImage(
                                        post['profileUrl'],
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (Context) =>
                                                      ProfileScreen2()));
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black, width: 1),
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              fit: BoxFit.fill,
                                              image: NetworkImage(
                                                post['profileUrl'],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '  Posted By ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    post['uEmail'],
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              PopupMenuButton<String>(
                                onSelected: (String value) {
                                  switch (value) {
                                    case 'Repost':
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  RepostPage(post: post)));
                                      break;
                                    // Add more cases here for additional menu options
                                  }
                                },
                                itemBuilder: (BuildContext context) {
                                  return {'Repost', 'Option 2'}
                                      .map((String choice) {
                                    return PopupMenuItem<String>(
                                      value: choice,
                                      child: Text(choice),
                                    );
                                  }).toList();
                                },
                              ),
                            ],
                          ),
                          Divider(
                            color: Colors.grey.shade300.withOpacity(1),
                          ),
                          ClipRRect(
                            child: FadeInImage.assetNetwork(
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width * 1,
                              height: MediaQuery.of(context).size.height * .25,
                              placeholder: 'assets/obs5.png',
                              image: post['pImage'],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              post['pTitle'],
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              post['pDescription'],
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.normal),
                            ),
                          ),
                          if (post['isReposted'] == true)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                'Reposted',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AnimatedBottomNavigationBar(
        barColor: Colors.red.shade50,
        controller: FloatingBottomBarController(initialIndex: 1),
        bottomBar: [
          BottomBarItem(
            icon: const Icon(
              Icons.home,
              size: 30,
            ),
            iconSelected:
                const Icon(Icons.home, color: Colors.redAccent, size: 30),
            title: 'Home',
            dotColor: Colors.redAccent,
            onTap: (value) {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => HomeScreen2()));
            },
          ),
          BottomBarItem(
            icon: const Icon(Icons.chat, size: 30),
            iconSelected:
                const Icon(Icons.chat, color: Colors.redAccent, size: 30),
            title: 'Discussion',
            dotColor: Colors.redAccent,
            onTap: (value) {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => ChatScreen2()));
            },
          ),
          BottomBarItem(
            icon: const Icon(Icons.work, size: 28),
            iconSelected:
                const Icon(Icons.work, color: Colors.redAccent, size: 30),
            title: 'Jobs',
            dotColor: Colors.redAccent,
            onTap: (value) {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => JobPostingForm()));
            },
          ),
          BottomBarItem(
            icon: const Icon(Icons.notifications_on_rounded, size: 30),
            iconSelected: const Icon(Icons.notifications_on_rounded,
                color: Colors.redAccent, size: 30),
            title: 'Updates',
            dotColor: Colors.redAccent,
            onTap: (value) {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => UpdateScreen()));
            },
          ),
        ],
        bottomBarCenterModel: BottomBarCenterModel(
          centerBackgroundColor: Colors.redAccent,
          centerIcon: const FloatingCenterButton(
            child: Icon(
              Icons.add,
              color: AppColors.white,
            ),
          ),
          centerIconChild: [
            FloatingCenterButtonChild(
                child: const Icon(
                  Icons.add_a_photo,
                  color: AppColors.white,
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AddPostScreen1()));
                }),
          ],
        ),
      ),
    );
  }
}

class RepostPage extends StatelessWidget {
  final Map<dynamic, dynamic> post;

  RepostPage({required this.post});

  @override
  Widget build(BuildContext context) {
    final TextEditingController titleController =
        TextEditingController(text: post['pTitle']);
    final TextEditingController descriptionController =
        TextEditingController(text: post['pDescription']);

    return Scaffold(
      appBar: AppBar(
        title: Text("Repost Page"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            SizedBox(height: 10),
            Image.network(
              post['pImage'],
              fit: BoxFit.cover,
              width: double.infinity,
              height: 200,
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  final newPost = {
                    'pTitle': titleController.text,
                    'pDescription': descriptionController.text,
                    'pImage': post['pImage'],
                    'profileUrl': post['profileUrl'],
                    'uEmail': post['uEmail'],
                    'isReposted': true,
                  };
                  FirebaseDatabase.instance
                      .ref()
                      .child('Posts')
                      .child('Post List')
                      .push()
                      .set(newPost)
                      .then((_) {
                    Navigator.of(context).pop();
                  });
                },
                child: Text("Repost"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
