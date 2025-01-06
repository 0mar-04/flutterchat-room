import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'settings_page.dart';

class ChatPage extends StatefulWidget {
  final bool darkMode;
  final double textSize; // Add textSize parameter

  ChatPage({required this.darkMode, required this.textSize});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection('messages').add({
        'text': _messageController.text,
        'createdAt': Timestamp.now(),
        'userId': _auth.currentUser?.uid,
        'userEmail': _auth.currentUser?.email,
      });
      _messageController.clear();
    }
  }

  // Clear all chat messages
  Future<void> _clearChat() async {
    final chatDocs = await FirebaseFirestore.instance
        .collection('messages')
        .get();
    for (var doc in chatDocs.docs) {
      await doc.reference.delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Chat Room",
          style: TextStyle(
            fontSize: widget.textSize, // Apply text size here
            fontWeight: FontWeight.bold,
            color: widget.darkMode ? Colors.black : Colors.white,
          ),
        ),
        backgroundColor: widget.darkMode ? Colors.white : Colors.indigo,
        actions: [
          IconButton(
            icon: Icon(Icons.delete, color: widget.darkMode ? Colors.black : Colors.white),
            onPressed: () async {
              // Confirm before clearing the chat
              bool? shouldClear = await showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text('Clear Chat'),
                  content: Text('Are you sure you want to clear all chat messages?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop(false);
                      },
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop(true);
                      },
                      child: Text('Clear'),
                    ),
                  ],
                ),
              );
              if (shouldClear == true) {
                _clearChat();
              }
            },
          ),
        ],
      ),
      backgroundColor: widget.darkMode ? Colors.black : Colors.white,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: widget.darkMode ? Colors.black : Colors.indigo,
              ),
              child: Text(
                'Chat App Menu',
                style: TextStyle(
                  color: widget.darkMode ? Colors.white : Colors.black,
                  fontSize: widget.textSize,
                ),
              ),
            ),
            ListTile(
              title: Text(
                'Settings',
                style: TextStyle(fontSize: widget.textSize),
              ),
              onTap: () {
                // Navigate to Settings Page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsPage(darkMode: widget.darkMode),
                  ),
                );
              },
            ),
            ListTile(
              title: Text(
                'Sign Out',
                style: TextStyle(fontSize: widget.textSize),
              ),
              onTap: () async {
                await _auth.signOut();
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Chat Messages List
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (ctx, AsyncSnapshot<QuerySnapshot> chatSnapshot) {
                if (chatSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                final chatDocs = chatSnapshot.data!.docs;
                return ListView.builder(
                  reverse: true,
                  itemCount: chatDocs.length,
                  itemBuilder: (ctx, index) {
                    final messageData = chatDocs[index];
                    final timestamp = (messageData['createdAt'] as Timestamp).toDate();
                    String formattedTime = DateFormat('hh:mm a').format(timestamp); // 12-hour format with AM/PM

                    return ListTile(
                      title: Row(
                        children: [
                          Text(
                            messageData['userEmail'],
                            style: TextStyle(
                              color: Colors.blue, // Set username color to blue
                              fontWeight: FontWeight.normal, // Remove bold
                              fontSize: widget.textSize * 0.8, // Make the username smaller
                            ),
                          ),
                          SizedBox(width: 5),
                          Text(
                            formattedTime,
                            style: TextStyle(
                              color: widget.darkMode ? Colors.white70 : Colors.black,
                              fontSize: widget.textSize * 0.7, // Smaller timestamp size
                            ),
                          ),
                        ],
                      ),
                      subtitle: Text(
                        messageData['text'],
                        style: TextStyle(
                          color: widget.darkMode ? Colors.white70 : Colors.black,
                          fontSize: widget.textSize, // Apply text size here
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Enter a message",
                      filled: true,
                      fillColor: widget.darkMode ? Colors.black : Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      hintStyle: TextStyle(
                        color: widget.darkMode ? Colors.white : Colors.black,
                        fontSize: 16.0, // Fixed text size for user input
                      ),
                    ),
                    style: TextStyle(
                        color: widget.darkMode ? Colors.white : Colors.black,
                        fontSize: 16.0), // Fixed text size for user input
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: widget.darkMode ? Colors.white : Colors.black),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
