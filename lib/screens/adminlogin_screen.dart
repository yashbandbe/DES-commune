import 'package:demoapp/components/colors.dart';
import 'package:demoapp/screens/AdminHome_screen.dart';
import 'package:demoapp/screens/DemoScreen.dart';
import 'package:demoapp/screens/HomeScreen2.dart';
import 'package:demoapp/screens/add_post_screen.dart';
import 'package:demoapp/screens/admin_profileScreen.dart';
import 'package:demoapp/screens/admreg.dart';
import 'package:demoapp/screens/admregister_screen.dart';
import 'package:demoapp/screens/alumnireg.dart';
import 'package:demoapp/screens/home_screen.dart';
import 'package:demoapp/screens/homescreen.dart';
import 'package:demoapp/screens/office_auth.dart';
import 'package:demoapp/screens/registration_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({Key? key}) : super(key: key);

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  //form key
  final _formKey = GlobalKey<FormState>();

  //editing controller
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  //firebase
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    //email field
    final emailField = Container(
      decoration: BoxDecoration(
        color: Colors.white, // Background color of the field
        borderRadius: BorderRadius.circular(10), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // Shadow position
          ),
        ],
      ),
      child: TextFormField(
        controller: emailController,
        autofocus: false,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Please Enter Your Email");
          }

          // Regular expression for email validation
          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
              .hasMatch(value)) {
            return ("Please Enter a valid email");
          }
          return null;
        },
        onSaved: (value) {
          emailController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.mail,
            color: Colors.redAccent,
          ),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide
                .none, // Remove the border to use the container's shadow
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide
                .none, // Remove the border to use the container's shadow
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.redAccent, // Change border color when focused
              width: 2.0,
            ),
          ),
        ),
      ),
    );

// Password Field
    final passwordField = Container(
      decoration: BoxDecoration(
        color: Colors.white, // Background color of the field
        borderRadius: BorderRadius.circular(10), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // Shadow position
          ),
        ],
      ),
      child: TextFormField(
        autofocus: false,
        controller: passwordController,
        obscureText: true,
        validator: (value) {
          RegExp regex = RegExp(r'^.{6,}$');
          if (value!.isEmpty) {
            return ("Password is required for login");
          }
          if (!regex.hasMatch(value)) {
            return ("Please Enter Valid Password (Min. 6 Characters)");
          }
          return null;
        },
        onSaved: (value) {
          passwordController.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.vpn_key,
            color: Colors.redAccent,
          ),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide
                .none, // Remove the border to use the container's shadow
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide
                .none, // Remove the border to use the container's shadow
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.redAccent, // Change border color when focused
              width: 2.0,
            ),
          ),
        ),
      ),
    );

    //Login Button
    final LoginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.redAccent,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          signIn(emailController.text, passwordController.text);
        },
        child: const Text(
          "Login",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.red.shade50,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.red.shade50,
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
                      const SizedBox(
                        height: 45,
                      ),
                      emailField,
                      const SizedBox(
                        height: 25,
                      ),
                      passwordField,
                      const SizedBox(
                        height: 35,
                      ),
                      LoginButton,
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text("Don't have an account? "),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AlumniReg()));
                            },
                            child: const Text(
                              "SignUp",
                              style: TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 50),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AlumniReg()),
                          );
                        },
                        child: const Text(
                          'Want to join as an Alumni ?',
                          style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        ),
                      )
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }

  //login function
  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      // Check if entered email and password match the default credentials
      if (email == "default@example.com" && password == "password123") {
        // Navigate to the office authentication page
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => OfficeAuth()));
      } else {
        // If not default credentials, proceed with Firebase authentication
        await _auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((uid) => {
                  Fluttertoast.showToast(msg: "Login Successful"),
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => HomeScreen2()))
                })
            .catchError((e) {
          Fluttertoast.showToast(msg: e!.message.toString());
        });
      }
    }
  }
}
