import 'package:firebase_database/firebase_database.dart';

class ChatService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref("messages");

  // Send a message
  Future<void> sendMessage(String sender, String text) async {
    final message = {
      "sender": sender,
      "text": text,
      "timestamp": DateTime.now().toIso8601String(),
    };
    await _dbRef.push().set(message);
  }

  // Listen to messages
  Stream<List<Map<String, dynamic>>> getMessages() {
    return _dbRef.onValue.map((event) {
      final messages = event.snapshot.value as Map<dynamic, dynamic>?;
      if (messages != null) {
        return messages.values.map((msg) => Map<String, dynamic>.from(msg)).toList();
      } else {
        return [];
      }
    });
  }
}
