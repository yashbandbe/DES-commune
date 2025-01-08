import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class JobPostingForm extends StatefulWidget {
  @override
  _JobPostingFormState createState() => _JobPostingFormState();
}

class _JobPostingFormState extends State<JobPostingForm> {
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _deadlineController = TextEditingController();
  final TextEditingController _jobDescriptionController =
      TextEditingController();
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _qualificationController =
      TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  User? user = FirebaseAuth.instance.currentUser;
  late UserModel loggedInUser;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("superalumni")
        .doc(user!.uid)
        .get()
        .then((value) {
      setState(() {
        loggedInUser = UserModel.fromMap(value.data()!);
      });
    });
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

  // Function to submit the form and store data in Firestore
  void _submitForm() {
    // Convert the selected date to a Firestore Timestamp
    Timestamp deadlineTimestamp =
        Timestamp.fromDate(DateTime.parse(_dateController.text));

    FirebaseFirestore.instance.collection('Job').add({
      'contact': _contactController.text,
      'deadline': deadlineTimestamp, // Store the deadline as a Timestamp
      'job_description': _jobDescriptionController.text,
      'job_title': _jobTitleController.text,
      'location': _locationController.text,
      'qualification': _qualificationController.text,
      'salary': _salaryController.text,
      'username': "${loggedInUser.firstName} ${loggedInUser.secondName}",
    }).then((value) {
      // Show a success message or navigate to another screen
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Job posting submitted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      // Clear all input fields after submission
      _contactController.clear();
      _dateController.clear();
      _jobDescriptionController.clear();
      _jobTitleController.clear();
      _locationController.clear();
      _qualificationController.clear();
      _salaryController.clear();
    }).catchError((error) {
      // Handle error if data submission fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error submitting job posting: $error'),
          backgroundColor: Colors.red,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromRGBO(33, 150, 243, 1),
                  Colors.lightGreen,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: Text('Create Jobs Alert'),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            TextFormField(
              controller: _jobTitleController,
              decoration: InputDecoration(
                labelText: 'Job Title',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.work, color: Colors.green),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _jobDescriptionController,
              decoration: InputDecoration(
                labelText: 'Job Description',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description, color: Colors.green),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 10),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on, color: Colors.green),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _qualificationController,
              decoration: InputDecoration(
                labelText: 'Qualification',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.school, color: Colors.green),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _salaryController,
              decoration: InputDecoration(
                labelText: 'Salary',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.attach_money, color: Colors.green),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _contactController,
              decoration: InputDecoration(
                labelText: 'Contact',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone, color: Colors.green),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _dateController,
              decoration: InputDecoration(
                labelText: 'Deadline',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.calendar_today, color: Colors.green),
              ),
              readOnly: true,
              onTap: () => _selectDate(context),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text(
                'Submit',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 59, 196, 126),
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserModel {
  final String? firstName;
  final String? secondName;

  UserModel({this.firstName, this.secondName});

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      firstName: map['firstName'],
      secondName: map['secondName'],
    );
  }
}

void main() {
  runApp(MaterialApp(
    title: 'Job Posting Form',
    home: JobPostingForm(),
  ));
}
