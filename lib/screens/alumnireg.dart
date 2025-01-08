import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demoapp/components/user_model2.dart';
import 'package:demoapp/screens/adminlogin_screen.dart';

import 'package:demoapp/screens/storage_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:file_picker/file_picker.dart';

class AlumniReg extends StatefulWidget {
  @override
  State<AlumniReg> createState() => _AlumniRegState();
}

class _AlumniRegState extends State<AlumniReg> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  final firstNameEditingController = new TextEditingController();
  final secondEditingController = new TextEditingController();
  final emailEditingController = new TextEditingController();
  final contactEditingController = new TextEditingController();
  final usertypeEditingController = new TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final imageEditingController = TextEditingController();
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

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

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
    final firstNameField = TextFormField(
        controller: firstNameEditingController,
        autofocus: false,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value!.isEmpty) {
            return ("First Name cannot be empty");
          }
          return null;
        },
        onSaved: (value) {
          firstNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "First Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    final secondNameField = TextFormField(
        controller: secondEditingController,
        autofocus: false,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value!.isEmpty) {
            return ("last Name cannot be empty");
          }
          return null;
        },
        onSaved: (value) {
          secondEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Last Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

//email
    final emailField = TextFormField(
        controller: emailEditingController,
        autofocus: false,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Please Enter Your Email");
          }

          //reg expession for email validation
          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
              .hasMatch(value)) {
            return ("Please Enter a valid email");
          }
          return null;
        },
        onSaved: (value) {
          emailEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.mail),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    final _dateControllerrr = TextFormField(
      controller: _dateController,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        labelText: ' Passout Year',
        prefixIcon: GestureDetector(
          onTap: () => _selectDate(context),
          child: Icon(Icons.calendar_today),
        ),
      ),
      readOnly: true,
      onTap: () => _selectDate(context),
    );
//user type
    final usertypeEditingController = TextEditingController(text: "student");

// ... rest of your code ...

    var usertypefield = TextFormField(
      controller: usertypeEditingController,
      enabled: false, // Disable user input
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.account_circle),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "User Type", // Adjust hint text if needed
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        fillColor: Colors
            .grey.shade200, // Optional: Set background color for disabled field
      ),
    );

    final imagePickerButton = ElevatedButton(
      onPressed: _pickImage,
      child: Text('Select Image'),
    );

    final selectedImageField = TextFormField(
      controller: imageEditingController,
      readOnly: true,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.image),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Selected Image",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    Column(
      children: [
        // Other form fields
        SizedBox(height: 20),
        imagePickerButton,
        SizedBox(height: 20),
        selectedImageField,
      ],
    );
    final Submitbutton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.redAccent,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          postDetailsToFirestore();
        },
        child: Text(
          "SignUp",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );

//button

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.red),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 200,
                        child: Image.asset(
                          "assets/loginimg.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(
                        height: 45,
                      ),
                      firstNameField,
                      SizedBox(
                        height: 20,
                      ),
                      secondNameField,
                      SizedBox(
                        height: 20,
                      ),
                      emailField,
                      SizedBox(
                        height: 20,
                      ),
                      _dateControllerrr,
                      SizedBox(height: 15),
                      imagePickerButton,
                      SizedBox(
                        height: 20,
                      ),
                      Submitbutton,
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }

  postDetailsToFirestore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    if (user != null) {
      UserModel2 userModel = UserModel2();
      userModel.email = emailEditingController.text; // Correctly retrieve email
      userModel.uid = user.uid;
      userModel.firstName = firstNameEditingController.text;
      userModel.secondName = secondEditingController.text;
      userModel.date = _dateController.text;
      userModel.usertype = "alumni";

      // Upload image to Firebase Storage if needed

      // Save user details to Firestore
      await firebaseFirestore
          .collection("AlumniData")
          .doc(user.uid)
          .set(userModel.toMap());

      Fluttertoast.showToast(msg: "Account created successfully :)");
      Navigator.pushAndRemoveUntil(
          (context),
          MaterialPageRoute(builder: (context) => AdminLoginScreen()),
          (route) => false);
    } else {
      Fluttertoast.showToast(msg: "Error");
    }
  }
}
