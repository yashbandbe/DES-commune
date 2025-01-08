import 'package:demoapp/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Group Chat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChatScreen2(),
    );
  }
}

class ChatScreen2 extends StatefulWidget {
  @override
  State<ChatScreen2> createState() => _ChatScreen2State();
}

class _ChatScreen2State extends State<ChatScreen2> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("superalumni")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data()!);
      setState(() {});
    });
  }

  void _addMessage(String message) async {
    await FirebaseFirestore.instance.collection('messages').add({
      'text': message,
      'username': "${loggedInUser.firstName} ${loggedInUser.secondName}",
      'timestamp': DateTime.now(),
    });
    _textController.clear();
  }

  Stream<List<DocumentSnapshot>> _getMessages() {
    return FirebaseFirestore.instance
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((QuerySnapshot querySnapshot) {
      return querySnapshot.docs;
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
          title: Text('Discussion Group'),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<DocumentSnapshot>>(
              stream: _getMessages(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  reverse: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    final messageData =
                        snapshot.data![index].data() as Map<String, dynamic>;
                    final messageText = messageData['text'];
                    final messageUsername = messageData['username'];
                    final isCurrentUser = messageUsername ==
                        "${loggedInUser.firstName} ${loggedInUser.secondName}";

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 10.0),
                      child: Align(
                        alignment: isCurrentUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isCurrentUser
                                ? Color.fromARGB(255, 79, 178, 128)
                                : Colors.grey[300],
                            borderRadius: isCurrentUser
                                ? BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    bottomLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(15),
                                  )
                                : BorderRadius.only(
                                    topRight: Radius.circular(15),
                                    bottomLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(15),
                                  ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (messageUsername != null &&
                                  messageUsername.isNotEmpty)
                                Text(
                                  messageUsername,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: isCurrentUser
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              SizedBox(height: 5),
                              Text(
                                messageText,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: isCurrentUser
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Divider(height: 1.0),
          _buildTextComposer(),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Send a message',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              ),
              onSubmitted: _handleSubmitted,
            ),
          ),
          SizedBox(width: 8.0),
          IconButton(
            icon: Icon(Icons.send, color: Colors.blue),
            onPressed: () => _handleSubmitted(_textController.text),
          ),
        ],
      ),
    );
  }

  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) return;
    _addMessage(text);
  }
}

void main() {
  runApp(ChatApp());
}
