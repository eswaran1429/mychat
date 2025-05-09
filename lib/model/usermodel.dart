class Usermodel {
  final String uid;
  final String email;
  final String name;
  Usermodel( {required this.email,required this.uid,required this.name});

  factory Usermodel.fromMap(Map<String, dynamic> map , String uid){
    return Usermodel(email: map['email'] ?? 'no email', uid: uid, name: map['name']?? 'no name');
  }
}