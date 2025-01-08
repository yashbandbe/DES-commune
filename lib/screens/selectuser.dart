import 'package:demoapp/screens/adminlogin_screen.dart';
import 'package:demoapp/screens/login_screen.dart';
import 'package:flutter/material.dart';

class SelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                "assets/background.jpg"), // Replace with your image path
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Select User Type',
                style: TextStyle(
                  fontSize: 30,
                  color: Color.fromARGB(255, 23, 69, 236),
                  fontWeight: FontWeight.normal,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.grey,
                      offset: Offset(1.0, 1.0),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),
              OptionButton(
                title: ' DES Alumni',
                imagePath:
                    'assets/alumni_img.png', // Replace with your image path
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AdminLoginScreen()),
                  );
                },
              ),
              OptionButton(
                title: 'DES Student',
                imagePath:
                    'assets/student_img.jpg', // Replace with your image path
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OptionButton extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback onTap;

  OptionButton(
      {required this.title, required this.imagePath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.asset(
                  imagePath,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
