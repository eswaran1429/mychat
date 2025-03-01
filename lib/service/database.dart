import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mychat/model/messagemodel.dart';
import 'package:mychat/model/usermodel.dart';

class Database {
  final String uid;
  Database({required this.uid,});

  final CollectionReference _user =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference _chat =
      FirebaseFirestore.instance.collection('chats');

  // ✅ Add user with email field
  Future<void> addUser(String uid, String email,) async {
    return await _user.doc(uid).set({
      'uid': uid,
      'email': email,
    });
  }

  // ✅ Ensure consistent chat ID
  String getChatId(String senderId, String receiverId) {
    List<String> list = [senderId, receiverId];
    list.sort();
    return list.join("_");
  }

  // ✅ Add message to Firestore
  Future<void> addMessage(
      String senderId, String receiverId, String message) async {
    String chatId = getChatId(senderId, receiverId);
    await _chat.doc(chatId).collection('messages').add({
      'senderId': senderId,
      'receiverId': receiverId,
      'text': message,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // ✅ Stream all users
  Stream<List<Usermodel>> get allUsers {
    return _user.snapshots().map((snap) {
      return snap.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>? ?? {};
        return Usermodel(
          uid: data['uid'] ?? 'Unknown',
          email: data['email'] ?? 'no email',
        );
      }).toList();
    });
  }

 Stream<List<Messagemodel>> getMessages(String chatId) {
  return _chat
      .doc(chatId)
      .collection('messages')
      .orderBy('timestamp', descending: false)
      .snapshots()
      .map((snap) {
    return snap.docs.map((doc) {
      final data = doc.data(); // No need for explicit casting
      return Messagemodel(
        senderId: data['senderId'] ?? 'no id',
        receiverId: data['receiverId'] ?? 'no id',
        message: data['text'] ?? 'no message',
        time: (data['timestamp'] as Timestamp).toDate(), // ✅ Ensure valid timestamp
      );
    }).toList();
  });
}

}
