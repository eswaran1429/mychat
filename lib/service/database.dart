import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mychat/model/messagemodel.dart';
import 'package:mychat/model/usermodel.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Database {
  final String uid = FirebaseAuth.instance.currentUser!.uid;
  final CollectionReference _user =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference _chat =
      FirebaseFirestore.instance.collection('chats');
  final CollectionReference _profile =
      FirebaseFirestore.instance.collection('profiles');
  final CollectionReference _contacts =
      FirebaseFirestore.instance.collection('contacts');

  Future<void> addProfile(String profile) async {
    if (uid.isEmpty) {
      throw Exception("UID cannot be empty");
    }
    return await _profile.doc(uid).set({'profile': profile});
  }

  Future<String?> getProfile(String userId) async {
    DocumentSnapshot snap = await _profile.doc(userId).get();
    if (snap.exists && snap.data() != null) {
      final data = snap.data() as Map<String, dynamic>;
      return data['profile'] as String?;
    } else {
      return null;
    }
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

//get all messages
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
          time: (data['timestamp'] as Timestamp)
              .toDate(), // ✅ Ensure valid timestamp
        );
      }).toList();
    });
  }

  // ✅ Add user with email field
  Future<void> addUser(String uid, String email, String name) async {
    return await _user.doc(uid).set({'uid': uid, 'email': email, 'name': name});
  }

  // ✅ Stream all users
  Stream<List<Usermodel>> get allUsers {
    return _user.snapshots().map((snap) {
      return snap.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>? ?? {};
        return Usermodel(
            uid: data['uid'] ?? 'Unknown',
            email: data['email'] ?? 'no email',
            name: data['name'] ?? 'no name');
      }).toList();
    });
  }

  Stream<List<Usermodel>> getcontacts() {
    final contactsRef = _contacts.doc(uid).collection('contacts');

    return contactsRef.snapshots().asyncMap((snap) async {
      final emails = snap.docs.map((doc) => doc['email'] as String).toList();
      List<Usermodel> users = [];
      for (var i = 0; i < emails.length; i += 10) {
        final chunk = emails.sublist(
            i, (i + 10 > emails.length) ? emails.length : i + 10);

        final userSnap = await _user.where('email', whereIn: chunk).get();
        users.addAll(userSnap.docs.map((map) =>
            Usermodel.fromMap(map.data() as Map<String, dynamic>, map.id)));
      }
      return users;
    });
  }

  Future<void> addContacts(String email) async {
    await _contacts.doc(uid).collection('contacts').add({'email': email});
  }
}
 