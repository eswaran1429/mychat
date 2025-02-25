import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mychat/model/usermodel.dart';

class Database {
  final String uid;
  Database({required this.uid});

  final CollectionReference _user =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference _chats =
      FirebaseFirestore.instance.collection('chats');

  Future addUser(String uid) async {
    return await _user.doc(uid).set({'uid': uid});
  }

  Stream<List<Usermodel>> get allUsers {
    return _user.snapshots().map((snap){
      return snap.docs.map((doc){
         final data = doc.data() as Map<String, dynamic>? ?? {};
        return Usermodel(uid: data['uid'] ?? 'Unknown');
      }).toList();
    });
  } 

}
