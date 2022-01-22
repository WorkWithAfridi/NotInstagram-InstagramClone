import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';

class Posts {
  late String description;
  late String userName;
  late String userId;
  late String postId;
  late String profilePhotoUrl;
  late String postPhotoUrl;
  late String datePublished;
  final likes;

  Posts.name({
    required this.description,
    required this.userName,
    required this.userId,
    required this.postId,
    required this.profilePhotoUrl,
    required this.postPhotoUrl,
    required this.likes,
    required this.datePublished,
  });

  Map<String, dynamic> toJson() => {
        'username': userName,
        'uid': userId,
        'description': description,
        'postId': postId,
        'profilePhotoUrl': profilePhotoUrl,
        'postPhotoUrl': postPhotoUrl,
        'likes': likes,
        'datePublished': datePublished
      };

  static Posts fromSnap(DocumentSnapshot documentSnapshot) {
    var snapshot = documentSnapshot.data() as Map<String, dynamic>;
    return Posts.name(
        description: snapshot['description'],
        userName: snapshot['username'],
        userId: snapshot['uid'],
        postId: snapshot['postId'],
        profilePhotoUrl: snapshot['profilePhotoUrl'],
        postPhotoUrl: snapshot['postPhotoUrl'],
        likes: snapshot['likes'],
        datePublished: snapshot['datePublished']);
  }
}
