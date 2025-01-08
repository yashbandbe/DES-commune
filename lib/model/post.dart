// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demoapp/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final usersRef = FirebaseFirestore.instance.collection('users');

class Post extends StatefulWidget {
  final String uid;
  final String email;
  final String firstName;
  final String secondName;
  final String profile;
  final dynamic likes;

  Post({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.secondName,
    required this.profile,
    required this.likes,
  });

//receive data from server
  factory Post.fromDocument(DocumentSnapshot doc) {
    return Post(
      uid: doc['uid'],
      email: doc['email'],
      firstName: doc['firstName'],
      secondName: doc['secondName'],
      profile: doc['profile'],
      likes: doc['likes'],
    );
  }

  int getLikeCount(likes) {
    if (likes == null) {
      return 0;
    }
    int count = 0;
    likes.values.forEach((val) {
      if (val == true) {
        count += 1;
      }
    });
    return count;
  }

  @override
  State<Post> createState() => _PostState(
        uid: this.uid,
        email: this.email,
        firstName: this.firstName,
        secondName: this.secondName,
        profile: this.profile,
        likes: this.likes,
        likeCount: getLikeCount(this.likes),
      );
}

class _PostState extends State<Post> {
  @override
  void initState() {
    getUsers();
    super.initState();
  }

  getUsers() {
    usersRef.get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        print(doc.data);
      });
    });
  }

  final String uid;
  final String email;
  final String firstName;
  final String secondName;
  final String profile;
  int likeCount;
  Map likes;

  _PostState({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.secondName,
    required this.profile,
    required this.likes,
    required this.likeCount,
  });

  buildPostHeader() {
    return FutureBuilder(
        future: usersRef.doc(uid).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          UserModel user = UserModel.fromMap(snapshot.data);
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(user.profile.toString()),
              backgroundColor: Colors.grey,
            ),
            title: GestureDetector(
              onTap: () => print('Showing Profile'),
              child: Text(
                "${user.firstName} ${user.secondName}",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            subtitle: Text(email),
            trailing: IconButton(
              onPressed: () => print('deleting post'),
              icon: Icon(Icons.more_vert),
            ),
          );
        });
  }

  buildPostImage() {
    return GestureDetector(
        onDoubleTap: () => print('liking post'),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Image.network(profile),
          ],
        ));
  }

  buildPostFooter() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(padding: const EdgeInsets.only(top: 40.0, left: 20.0)),
            GestureDetector(
              onTap: () => print('liking post'),
              child: Icon(
                Icons.favorite_border,
                size: 28.0,
                color: Colors.red,
              ),
            ),
            Padding(padding: EdgeInsets.only(right: 20.0)),
            GestureDetector(
              onTap: () => print('show comments'),
              child: Icon(
                Icons.chat,
                size: 28.0,
                color: Colors.blue[900],
              ),
            )
          ],
        ),
        Row(
          children: [
            Container(
              margin: EdgeInsets.only(left: 20.0),
              child: Text(
                "$likeCount likes",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        buildPostHeader(),
        buildPostImage(),
        buildPostFooter()
      ],
    );
  }
}
