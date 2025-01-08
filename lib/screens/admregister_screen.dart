import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'package:demoapp/screens/storage_service.dart';

class AdminReg extends StatefulWidget {
  const AdminReg({Key? key});

  @override
  State<AdminReg> createState() => _AdminRegState();
}

class _AdminRegState extends State<AdminReg> {
  final TextEditingController firstEditingController = TextEditingController();
  final TextEditingController secondEditingController = TextEditingController();
  final TextEditingController emailEditingController = TextEditingController();
  final TextEditingController phonenoController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  late String _filePath = "";
  final Storage storage = Storage();

  Future<void> _pickDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _filePath = result.files.single.path ?? "";
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        _dateController.text = '${picked.toLocal()}'.split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(
                  height: 200,
                  child: Image.asset(
                    "assets/loginimg.png",
                    fit: BoxFit.contain,
                  ),
                ),
                TextFormField(
                  controller: firstEditingController,
                  autofocus: false,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.account_circle),
                    contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                    hintText: "First Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                TextFormField(
                  controller: secondEditingController,
                  autofocus: false,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.account_circle),
                    contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                    hintText: "Last Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                TextFormField(
                  controller: emailEditingController,
                  autofocus: false,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.mail),
                    contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                    hintText: "Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                TextFormField(
                  controller: phonenoController,
                  autofocus: false,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.phone),
                    contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                    hintText: "Phone number",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                TextFormField(
                  controller: _dateController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: 'Passout Year',
                    prefixIcon: GestureDetector(
                      onTap: () => _selectDate(context),
                      child: Icon(Icons.calendar_today),
                    ),
                  ),
                  readOnly: true,
                  onTap: () => _selectDate(context),
                ),
                SizedBox(
                  width: 400,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      final result = await FilePicker.platform
                          .pickFiles(allowMultiple: false, type: FileType.any);
                      if (result == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("No File picked"),
                          ),
                        );
                        return null;
                      }
                      final path = result.files.single.path!;
                      final fileName = result.files.single.name;

                      storage.uploadFile(path, fileName).then((value) {
                        firebase_storage.FirebaseStorage.instance
                            .ref('documents/$fileName')
                            .getDownloadURL()
                            .then((imageUrl) {
                          CollectionReference collref =
                              FirebaseFirestore.instance.collection("Alumni");
                          collref.add({
                            "firstName": firstEditingController.text,
                            "secondName": secondEditingController.text,
                            "email": emailEditingController.text,
                            "phoneno": phonenoController.text,
                            'passout': _dateController.text,
                            'imageUrl': imageUrl,
                          }).then(
                            (_) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Data Submitted Successfully'),
                                ),
                              );
                            },
                          );

                          secondEditingController.clear();
                          emailEditingController.clear();
                          phonenoController.clear();
                          _dateController.clear();
                        });
                      });
                    },
                    child: Text('Upload Last Year Marksheet'),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    CollectionReference collref =
                        FirebaseFirestore.instance.collection("Alumni");
                    collref.add({});
                  },
                  child: Text("Submit"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
