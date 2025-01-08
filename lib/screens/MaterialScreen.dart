import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';

class MaterialScreen extends StatefulWidget {
  const MaterialScreen({Key? key}) : super(key: key);

  @override
  State<MaterialScreen> createState() => _MaterialScreenState();
}

class _MaterialScreenState extends State<MaterialScreen> {
  final TextEditingController headlineController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String _filePath = "";
  String _fileName = "";
  FileType _fileType = FileType.any;

  Future<void> _pickDocument() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.any);

    if (result != null) {
      setState(() {
        _filePath = result.files.single.path ?? "";
        _fileName = result.files.single.name;
        _fileType = result.files.single.extension == 'pdf'
            ? FileType.custom
            : FileType.image;
      });
    }
  }

  Future<String?> _uploadFileToStorage(String filePath, String fileName) async {
    try {
      firebase_storage.TaskSnapshot task = await firebase_storage
          .FirebaseStorage.instance
          .ref('documents/$fileName')
          .putFile(File(filePath)); // Convert filePath to File object

      final String downloadUrl = await task.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading file: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Update'),
        backgroundColor: Colors.redAccent,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: 20),
                TextFormField(
                  controller: headlineController,
                  autofocus: false,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons
                        .title), // Changed from Icons.headline to Icons.title
                    contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                    hintText: "Headline",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: descriptionController,
                  autofocus: false,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.description),
                    contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                    hintText: "Description",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: _pickDocument,
                  child: Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 101, 102, 102),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Icon(
                            Icons.upload,
                            color: Colors.white,
                            size: 36,
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          left: 10,
                          right: 10,
                          child: Text(
                            _filePath.isNotEmpty
                                ? 'File selected: $_fileName'
                                : 'Tap to select a file',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    // Check if all fields are filled
                    if (headlineController.text.isEmpty ||
                        descriptionController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Please fill in all fields"),
                        ),
                      );
                      return;
                    }

                    // Add details to Firestore
                    CollectionReference updatesCollection =
                        FirebaseFirestore.instance.collection("Updates");
                    final fileUrl = _filePath.isNotEmpty
                        ? await _uploadFileToStorage(_filePath, _fileName)
                        : null;

                    await updatesCollection.add({
                      "headline": headlineController.text,
                      "description": descriptionController.text,
                      "fileUrl": fileUrl,
                      "fileType":
                          _fileType == FileType.custom ? 'pdf' : 'image',
                    });

                    // Clear all text controllers
                    headlineController.clear();
                    descriptionController.clear();

                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Data Submitted Successfully'),
                      ),
                    );
                  },
                  child: Text(
                    "Submit",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.redAccent),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
