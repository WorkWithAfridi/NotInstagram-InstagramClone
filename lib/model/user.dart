import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  late String email;
  late String userName;
  late String userId;
  late String bio;
  late String photoUrl;
  late List<String> followers;
  late List<String> following;
  late List<String> chatRooms;

  User.name(
      {required this.email,
      required this.userName,
      required this.userId,
      required this.bio,
      required this.photoUrl,
      required this.followers,
      required this.chatRooms,
      required this.following});

  Map<String, dynamic> toJson() => {
        'username': userName,
        'uid': userId,
        'email': email,
        'bio': bio,
        'followers': followers,
        'following': following,
        'photoUrl': photoUrl,
        'chatRooms': chatRooms
      };

  static User fromSnap(DocumentSnapshot documentSnapshot) {
    var snapshot = documentSnapshot.data() as Map<String, dynamic>;
    return User.name(
      email: snapshot['email'],
      following: snapshot['following'].cast<String>(),
      userId: snapshot['uid'],
      bio: snapshot['bio'],
      userName: snapshot['username'],
      photoUrl: snapshot['photoUrl'],
      followers: snapshot['followers'].cast<String>(),
      chatRooms: snapshot['chatRooms'].cast<String>(),
    );
  }
}
