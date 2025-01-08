import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demoapp/components/colors.dart';
import 'package:demoapp/components/roundbutton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_database/firebase_database.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  bool showSpinner = false;
  final DatabaseReference postRef =
      FirebaseDatabase.instance.ref().child('Posts');
  final CollectionReference postsCollection =
      FirebaseFirestore.instance.collection('posts');

  FirebaseAuth _auth = FirebaseAuth.instance;

  File? _image;
  final picker = ImagePicker();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  Future getImageGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No Image Selected');
      }
    });
  }

  Future getImageCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No Image Selected');
      }
    });
  }

  void dialog(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            content: Container(
              height: 120,
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      getImageCamera();
                      Navigator.pop(context);
                    },
                    child: ListTile(
                      leading: Icon(Icons.camera),
                      title: Text('Camera'),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      getImageGallery();
                      Navigator.pop(context);
                    },
                    child: ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text('Gallery'),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  Future<void> updateLikes(String postId, List<String> likes) async {
    try {
      // Check if the document exists
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("posts")
          .doc(postId)
          .get();

      if (snapshot.exists) {
        // Update the 'likes' field for the specific document
        await FirebaseFirestore.instance
            .collection("posts")
            .doc(postId)
            .update({
          'likes': likes,
        });
      } else {
        print("Document does not exist: $postId");
      }
    } catch (e) {
      print("Error updating likes: $e");
    }
  }

  Future<void> addPost() async {
    setState(() {
      showSpinner = true;
    });
    try {
      int date = DateTime.now().millisecondsSinceEpoch;
      // Upload post image to Firebase Storage
      firebase_storage.Reference refupload =
          firebase_storage.FirebaseStorage.instance.ref('/PostImages/$date');
      UploadTask uploadTask = refupload.putFile(_image!.absolute);
      await Future.value(uploadTask);

      // Get download URL of the uploaded image
      var newUrl = await refupload.getDownloadURL();

      // Get current user details
      final User? user = _auth.currentUser;
      if (user != null) {
        // Fetch profile URL from Firestore
        final userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (userData.exists) {
          final profileUrl = userData[
              'profile']; // Adjust field name as per your Firestore structure

          // Let Firestore generate a unique ID for the document
          DocumentReference postDocRef = await postsCollection.add({
            'uid': user.uid.toString(),
            'likes': [], // Initialize likes array for the post
          });

          // Retrieve the document ID which contains the uid
          String postId = postDocRef.id;

          // Write post data to Realtime Database
          await postRef.child('Post List').child(postId).set({
            'pId': date.toString(),
            'pImage': newUrl.toString(),
            'pTime': date.toString(),
            'pTitle': titleController.text.toString(),
            'pDescription': descriptionController.text.toString(),
            'uEmail': user.email.toString(),
            'Uid': user.uid.toString(),
            'profileUrl': profileUrl,
          });

          // Show success message
          toastMessage('Post Published');
          setState(() {
            showSpinner = false;
          });
        }
      }
    } catch (e) {
      // Show error message
      toastMessage(e.toString());
      setState(() {
        showSpinner = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Upload Feeds', style: TextStyle(color: Colors.white)),
          backgroundColor: primarycolor,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    dialog(context);
                  },
                  child: Center(
                    child: Container(
                      height: MediaQuery.of(context).size.height * .2,
                      width: MediaQuery.of(context).size.width * 1,
                      child: _image != null
                          ? ClipRect(
                              child: Image.file(
                                _image!.absolute,
                                width: 100,
                                height: 100,
                                fit: BoxFit.fitWidth,
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(10)),
                              width: 100,
                              height: 100,
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.blue,
                              ),
                            ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Form(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: titleController,
                        keyboardType: TextInputType.text,
                        minLines: 1,
                        decoration: InputDecoration(
                          labelText: 'Title',
                          hintText: 'Enter Post Title',
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 2.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.normal,
                          ),
                          labelStyle: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        controller: descriptionController,
                        keyboardType: TextInputType.text,
                        minLines: 2,
                        maxLines: 5,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          hintText: 'Enter Post Description',
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 2.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.normal,
                          ),
                          labelStyle: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                RoundButton(
                  title: 'Upload',
                  onPress: () async {
                    await addPost();
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void toastMessage(String message) {
    Fluttertoast.showToast(
        msg: message.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        fontSize: 16.0);
  }
}
