import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demoapp/model/admin_usermodel.dart';
import 'package:demoapp/model/user_model.dart';
import 'package:demoapp/screens/adminlogin_screen.dart';
import 'package:demoapp/screens/home_screen.dart';
import 'package:demoapp/screens/homescreen.dart';
import 'package:demoapp/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AdminRegistrationScreen extends StatefulWidget {
  const AdminRegistrationScreen({super.key});

  @override
  State<AdminRegistrationScreen> createState() =>
      AdminRegistrationScreenState();
}

class AdminRegistrationScreenState extends State<AdminRegistrationScreen> {
  final _auth = FirebaseAuth.instance;

  //our form key
  final _formKey = GlobalKey<FormState>();

  //editing controller
  final firstNameEditingController = new TextEditingController();
  final secondEditingController = new TextEditingController();
  final emailEditingController = new TextEditingController();
  final phonenoController = new TextEditingController();
  final passoutController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    //first name Field
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

    //second name Field
    final secondNameField = TextFormField(
        controller: secondEditingController,
        autofocus: false,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Last Name cannot be empty");
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

    //email Field
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

    //phoneno Field
    final phonenoField = TextFormField(
        controller: phonenoController,
        autofocus: false,
        keyboardType: TextInputType.phone,
        validator: (value) {
          if (value!.isEmpty) {
            return ("First Name cannot be empty");
          }
          return null;
        },
        onSaved: (value) {
          phonenoController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Phone No",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));
    //Confirm password Field
    final passoutField = TextFormField(
        controller: passoutController,
        autofocus: false,
        keyboardType: TextInputType.datetime,
        validator: (value) {
          if (value!.isEmpty) {
            return ("First Name cannot be empty");
          }
          return null;
        },
        onSaved: (value) {
          passoutController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Passout",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));
    //SignUp Buttton
    final SignUpButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.redAccent,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          signUp(emailEditingController.text);
        },
        child: Text(
          "SignUp",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
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
                      phonenoField,
                      SizedBox(
                        height: 20,
                      ),
                      passoutField,
                      SizedBox(
                        height: 20,
                      ),
                      SignUpButton,
                      SizedBox(height: 15),
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }

  void signUp(String email) async {
    if (_formKey.currentState!.validate()) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: "")
          .then((value) => {postDetailsToFirestore()})
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }

  postDetailsToFirestore() async {
    //calling our firest5ore
    //calling our user model
    //sending these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    AdminUserModel userModel = AdminUserModel();

    //Writing all the values
    userModel.email = user!.email;
    userModel.uid = user!.uid;
    userModel.firstName = firstNameEditingController.text;
    userModel.secondName = secondEditingController.text;
    userModel.phoneno = phonenoController.text;
    userModel.passout = passoutController.text;

    await firebaseFirestore
        .collection("test")
        .doc(user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Account created successfully :)");
    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => AdminLoginScreen()),
        (route) => false);
  }
}
