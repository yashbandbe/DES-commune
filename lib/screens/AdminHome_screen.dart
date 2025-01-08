// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:demoapp/components/admin_drawer.dart';
// import 'package:demoapp/components/drawer_screen.dart';
// import 'package:demoapp/components/like_button.dart';
// import 'package:demoapp/model/user_model.dart';
// import 'package:demoapp/screens/MaterialScreen.dart';
// import 'package:demoapp/screens/Profile_Screen.dart';
// import 'package:demoapp/screens/add_post_screen.dart';
// import 'package:demoapp/screens/job_form.dart';
// import 'package:demoapp/screens/login_screen.dart';
// import 'package:demoapp/screens/updatescreen.dart';
// import 'package:demoapp/screens/view_job.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_database/ui/firebase_animated_list.dart';
// import 'package:flutter/material.dart';
// import 'package:floating_bottom_bar/animated_bottom_navigation_bar.dart';
// import 'package:provider/provider.dart';

// class AdminHomeScreen extends StatefulWidget {
//   const AdminHomeScreen({Key? key});

//   @override
//   State<AdminHomeScreen> createState() => _AdminHomeScreenState();
// }

// class _AdminHomeScreenState extends State<AdminHomeScreen> {
//   final dbRef = FirebaseDatabase.instance.ref().child('Posts');
//   User? user = FirebaseAuth.instance.currentUser;
//   UserModel loggedInUser = UserModel();

//   // Function to update likes in Firestore
//   Future<void> updateLikes(String postId, List<String> likes) async {
//     try {
//       // Check if the document exists
//       DocumentSnapshot snapshot = await FirebaseFirestore.instance
//           .collection("posts")
//           .doc(postId)
//           .get();

//       if (snapshot.exists) {
//         // Update the 'likes' field for the specific document
//         await FirebaseFirestore.instance
//             .collection("posts")
//             .doc(postId)
//             .update({
//           'likes': likes,
//         });
//       } else {
//         print("Document does not exist: $postId");
//       }
//     } catch (e) {
//       if (e is FirebaseException) {
//         switch (e.code) {
//           case 'not-found':
//             print("Document not found: $postId");
//             break;
//           case 'permission-denied':
//             print("Permission denied: $postId");
//             break;
//           default:
//             print("Error updating likes: $e");
//         }
//       } else {
//         print("Unexpected error: $e");
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color.fromARGB(255, 1, 27, 69),
//         iconTheme: IconThemeData(color: Colors.white),
//       ),
//       drawer: MyDrawer2(),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               child: FirebaseAnimatedList(
//                 query: dbRef.child('Post List'),
//                 itemBuilder: (BuildContext context, DataSnapshot snapshot,
//                     Animation<double> animation, int index) {
//                   return Padding(
//                     padding: const EdgeInsets.all(10.0),
//                     child: Container(
//                       decoration: BoxDecoration(
//                           color: Colors.grey.shade200,
//                           borderRadius: BorderRadius.circular(10)),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               Padding(
//                                 padding:
//                                     const EdgeInsets.only(top: 4.0, left: 4.0),
//                                 child: CircleAvatar(
//                                   radius: 15,
//                                   backgroundColor: Colors.transparent,
//                                   backgroundImage: NetworkImage(
//                                     (snapshot.value
//                                         as Map<dynamic, dynamic>)['profileUrl'],
//                                   ),
//                                   child: GestureDetector(
//                                     onTap: () {
//                                       Navigator.of(context).push(
//                                           MaterialPageRoute(
//                                               builder: (context) =>
//                                                   ProfileScreen()));
//                                     },
//                                     child: Container(
//                                       decoration: BoxDecoration(
//                                         border: Border.all(
//                                             color: Colors.black, width: 1),
//                                         shape: BoxShape.circle,
//                                         image: DecorationImage(
//                                           fit: BoxFit.fill,
//                                           image: NetworkImage(
//                                             (snapshot.value as Map<dynamic,
//                                                 dynamic>)['profileUrl'],
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Text(
//                                 '  Posted By ',
//                                 style: TextStyle(fontWeight: FontWeight.bold),
//                               ),
//                               Text(
//                                 (snapshot.value
//                                     as Map<dynamic, dynamic>)['uEmail'],
//                                 style: TextStyle(fontWeight: FontWeight.bold),
//                               ),
//                             ],
//                           ),
//                           Divider(
//                             color: Colors.grey.shade300.withOpacity(1),
//                           ),
//                           ClipRRect(
//                             child: FadeInImage.assetNetwork(
//                               fit: BoxFit.cover,
//                               width: MediaQuery.of(context).size.width * 1,
//                               height: MediaQuery.of(context).size.height * .25,
//                               placeholder: 'assets/obs5.png',
//                               image: (snapshot.value
//                                   as Map<dynamic, dynamic>)['pImage'],
//                             ),
//                           ),
//                           SizedBox(
//                             height: 10,
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 10),
//                             child: Text(
//                               (snapshot.value
//                                   as Map<dynamic, dynamic>)['pTitle'],
//                               style: TextStyle(
//                                   fontSize: 15, fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 10),
//                             child: Text(
//                               (snapshot.value
//                                   as Map<dynamic, dynamic>)['pDescription'],
//                               style: TextStyle(
//                                   fontSize: 15, fontWeight: FontWeight.normal),
//                             ),
//                           ),
//                           SizedBox(
//                             height: 10,
//                           ),
//                           Row(
//                             children: [
//                               StreamBuilder<DocumentSnapshot>(
//                                 stream: FirebaseFirestore.instance
//                                     .collection('posts')
//                                     .doc(user!.uid)
//                                     .snapshots(),
//                                 builder: (context, snapshot) {
//                                   if (!snapshot.hasData) {
//                                     return CircularProgressIndicator();
//                                   }

//                                   var postData = snapshot.data!.data() as Map?;
//                                   var likes = List<String>.from(
//                                       postData?['likes'] ?? []);
//                                   var postId =
//                                       snapshot.data!.id; // Get the post ID

//                                   return FutureBuilder<void>(
//                                     future: null,
//                                     builder: (context, snapshot) {
//                                       return LikeButton(
//                                         isLiked: likes.contains(
//                                             postId), // Check if post is liked
//                                         onTap: () async {
//                                           setState(() {
//                                             if (likes.contains(postId)) {
//                                               likes.remove(
//                                                   postId); // Remove like if already liked
//                                             } else {
//                                               likes.add(
//                                                   postId); // Add like if not already liked
//                                             }
//                                           });
//                                           try {
//                                             await updateLikes(postId,
//                                                 likes); // Update likes for this post
//                                           } catch (e) {
//                                             print("Error updating likes: $e");
//                                             setState(() {
//                                               // Revert back the changes if update fails
//                                               if (likes.contains(postId)) {
//                                                 likes.remove(postId);
//                                               } else {
//                                                 likes.add(postId);
//                                               }
//                                             });
//                                           }
//                                         },
//                                         likeCount: likes.length,
//                                         postId:
//                                             postId, // Pass the postId to the LikeButton
//                                       );
//                                     },
//                                   );
//                                 },
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: AnimatedBottomNavigationBar(
//         barColor: Colors.white,
//         controller: FloatingBottomBarController(initialIndex: 1),
//         bottomBar: [
//           BottomBarItem(
//             icon: const Icon(
//               Icons.home,
//               size: 30,
//             ),
//             iconSelected: const Icon(Icons.home,
//                 color: Color.fromARGB(255, 1, 27, 69), size: 30),
//             title: 'Home',
//             dotColor: Color.fromARGB(255, 1, 27, 69),
//             onTap: (value) {
//               Navigator.of(context).push(
//                   MaterialPageRoute(builder: (context) => MaterialScreen()));
//             },
//           ),
//           BottomBarItem(
//             icon: const Icon(Icons.person_search, size: 30),
//             iconSelected: const Icon(Icons.person_search,
//                 color: Color.fromARGB(255, 1, 27, 69), size: 30),
//             title: 'Jobs',
//             dotColor: Color.fromARGB(255, 1, 27, 69),
//             onTap: (value) {
//               Navigator.of(context)
//                   .push(MaterialPageRoute(builder: (context) => JobListPage()));
//             },
//           ),
//           BottomBarItem(
//             icon: const Icon(Icons.person, size: 30),
//             iconSelected: const Icon(Icons.person,
//                 color: Color.fromARGB(255, 1, 27, 69), size: 30),
//             title: 'person',
//             dotColor: Color.fromARGB(255, 1, 27, 69),
//             onTap: (value) {
//               Navigator.of(context).push(
//                   MaterialPageRoute(builder: (context) => UpdateScreen()));
//             },
//           ),
//           BottomBarItem(
//             icon: const Icon(Icons.settings, size: 30),
//             iconSelected: const Icon(Icons.settings,
//                 color: Color.fromARGB(255, 1, 27, 69), size: 30),
//             title: 'settings',
//             dotColor: Color.fromARGB(255, 1, 27, 69),
//             onTap: (value) {
//               Navigator.of(context).push(
//                   MaterialPageRoute(builder: (context) => JobPostingForm()));
//             },
//           ),
//         ],
//         bottomBarCenterModel: BottomBarCenterModel(
//           centerBackgroundColor: Color.fromARGB(255, 1, 27, 69),
//           centerIcon: const FloatingCenterButton(
//             child: Icon(
//               Icons.add,
//               color: AppColors.white,
//             ),
//           ),
//           centerIconChild: [
//             FloatingCenterButtonChild(
//                 child: const Icon(
//                   Icons.add_a_photo,
//                   color: AppColors.white,
//                 ),
//                 onTap: () {
//                   Navigator.of(context).push(
//                       MaterialPageRoute(builder: (context) => AddPostScreen()));
//                 }),
//           ],
//         ),
//       ),
//     );
//   }
// }
