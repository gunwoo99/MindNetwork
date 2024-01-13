import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class User {
  String userName = '';
  String userId = '';
  List<dynamic> networkIds = [];

  User() {
    userName = 'New User';
    userId = const Uuid().v4();
  }

  User.fromJson(dynamic json) {
    userId = json['userId'];
    userName = json['userName'];
    networkIds = json['networkIds'];
  }

  User.fromSnapShot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data());
  
  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'userId': userId,
      'networkIds': networkIds,
    };
  }
}


Future<int> createUser(User user) async {
  await FirebaseFirestore.instance
      .collection('User')
      .doc(user.userId)
      .set(user.toJson());
  return 0;
}

Future<User> getUser(String userId) async {
  DocumentSnapshot<Map<String, dynamic>> result =
      await FirebaseFirestore.instance.collection("User").doc(userId).get();
  User user = User.fromSnapShot(result);
  return user;
}
