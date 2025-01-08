import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileController2 with ChangeNotifier {
  final ref = FirebaseFirestore.instance.collection("superalumni");
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  final picker = ImagePicker();

  XFile? _image;

  XFile? get image => _image;

  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future pickGalleryImage(BuildContext context) async {
    final PickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);

    if (PickedFile != null) {
      _image = XFile(PickedFile.path);
      print(_image?.path);
      uploadImage(context);
      notifyListeners();
    }
  }

  Future pickCameraImage(BuildContext context) async {
    final PickedFile =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 100);

    if (PickedFile != null) {
      _image = XFile(PickedFile.path);
      print(_image?.path);
      uploadImage(context);
      notifyListeners();
    }
  }

  void pickImage(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              height: 120,
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      pickCameraImage(context);
                    },
                    leading: Icon(Icons.camera),
                    title: Text('Camera'),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      pickGalleryImage(context);
                    },
                    leading: Icon(Icons.image),
                    title: Text('Gallery'),
                  )
                ],
              ),
            ),
          );
        });
  }

  void uploadImage(BuildContext context) async {
    setLoading(true);

    // Get the current user's UID
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      setLoading(false);
      Fluttertoast.showToast(msg: 'User not authenticated');
      return;
    }

    // Reference to the user's profile image in Firebase Storage
    final storageRef =
        firebase_storage.FirebaseStorage.instance.ref('/profile/$uid.jpg');

    try {
      // Upload the image to Firebase Storage
      final uploadTask = storageRef.putFile(File(image!.path).absolute);
      await uploadTask;

      // Get the download URL of the uploaded image
      final imageUrl = await storageRef.getDownloadURL();

      // Update the user's profile image URL in Firestore
      await ref.doc(uid).update({
        'profile': imageUrl,
      });

      // Reset image and notify listeners
      _image = null;
      notifyListeners();
      setLoading(false);
      Fluttertoast.showToast(msg: 'Profile Updated');
    } catch (error) {
      // Handle errors
      setLoading(false);
      Fluttertoast.showToast(msg: 'Error uploading image: $error');
    }
  }
}
