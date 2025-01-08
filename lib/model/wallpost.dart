// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WallPost extends StatefulWidget {
  final String postId;
  final List<String> likes;
  const WallPost({
    super.key,
    required this.postId,
    required this.likes,
  });

  @override
  State<WallPost> createState() => _WallPostState();
}

class _WallPostState extends State<WallPost> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
  }

  //toggle like
  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
