import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class SendMail extends StatefulWidget {
  final String email;
  final String username;
  final Map<String, dynamic> alumniData;

  SendMail(
      {required this.email, required this.username, required this.alumniData});

  @override
  State<SendMail> createState() => _SendMailState();
}

class _SendMailState extends State<SendMail> {
  final TextEditingController _recipientEmailController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late TextEditingController _mailMessageController;

  @override
  void initState() {
    super.initState();
    _recipientEmailController.text = widget.email;
    _mailMessageController = TextEditingController(
      text: '''Hello ${widget.username},

We are pleased to inform you that your application for alumni access has been approved by the Deccan Education Society office team. Your username for the app is "${widget.email}" and your password is "${_passwordController.text}". Thank you for becoming a member of the DES Connect app alumni community.

Best regards,
[Your Name/DES Team]''',
    );
  }

  // Send Mail function
  void sendMail({
    required String recipientEmail,
    required String mailMessage,
    required String password,
  }) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    try {
      // Create user with email and password
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: recipientEmail,
        password: password,
      );

      // If user creation is successful, proceed to store the details in Firestore and send email
      if (userCredential.user != null) {
        // Store the UID and other details in "superalumni"
        await FirebaseFirestore.instance
            .collection('superalumni')
            .doc(userCredential.user!.uid)
            .set({
          'uid': userCredential.user!.uid,
          'firstName': widget.alumniData['firstName'] ?? '',
          'secondName': widget.alumniData['secondName'] ?? '',
          'email': recipientEmail,
          'passout': widget.alumniData['passout'] ?? '',
          'phoneno': widget.alumniData['phoneno'] ?? '',
          'imageUrl': widget.alumniData['imageUrl'] ?? '',
        });

        String username = 'bandbeyash2001@gmail.com';
        String appPassword =
            'poiuytrewqlkjhgfdsaz'; // Use your generated app password here
        final smtpServer = gmail(username, appPassword);
        final message = Message()
          ..from = Address(username, 'Mail Service')
          ..recipients.add(recipientEmail)
          ..subject = 'Alumni Access Approved'
          ..text = mailMessage;

        try {
          await send(message, smtpServer);
          showSnackbar('Email sent successfully');
        } catch (e) {
          if (kDebugMode) {
            print('Error sending email: $e');
          }
          showSnackbar('Failed to send email');
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showSnackbar('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        showSnackbar('The account already exists for that email.');
      } else {
        showSnackbar('Failed to create user: ${e.message}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      showSnackbar('An error occurred');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Send Mail'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/vvv.jpg",
                height: 220,
                width: 400,
                fit: BoxFit.contain,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Recipient Email',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(),
                  ),
                ),
                controller: _recipientEmailController,
              ),
              const SizedBox(height: 20),
              TextFormField(
                maxLines: 5,
                controller: _mailMessageController,
                decoration: const InputDecoration(
                  labelText: 'Message',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                onChanged: (value) {
                  setState(() {
                    // Update the message text whenever the password changes
                    _updateMessageText(value);
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    sendMail(
                      recipientEmail: _recipientEmailController.text.toString(),
                      mailMessage: _mailMessageController.text.toString(),
                      password: _passwordController.text.toString(),
                    );
                  },
                  child: const Text('Submit'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _updateMessageText(String password) {
    setState(() {
      _mailMessageController.text = '''Hello ${widget.username},

We are pleased to inform you that your application for alumni access has been approved by the Deccan Education Society office team. Your username for the app is "${widget.email}" and your password is "$password". Thank you for becoming a member of the DES Connect app alumni community.

Best regards,
[Your Name/DES Team]''';
    });
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: FittedBox(
          child: Text(
            message,
            style: const TextStyle(
              fontSize: 10,
            ),
          ),
        ),
      ),
    );
  }
}
