import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';

class Stories {
  late String userName;
  late String userId;
  late String storyId;
  late String profilePhotoUrl;
  late String storyPhotoUrl;
  late String datePublished;

  Stories.name({
    required this.userName,
    required this.userId,
    required this.storyId,
    required this.profilePhotoUrl,
    required this.storyPhotoUrl,
    required this.datePublished,
  });

  Map<String, dynamic> toJson() => {
    'username': userName,
    'uid': userId,
    'postId': storyId,
    'profilePhotoUrl': profilePhotoUrl,
    'postPhotoUrl': storyPhotoUrl,
    'datePublished': datePublished
  };

  static Stories fromSnap(DocumentSnapshot documentSnapshot) {
    var snapshot = documentSnapshot.data() as Map<String, dynamic>;
    return Stories.name(
        userName: snapshot['username'],
        userId: snapshot['uid'],
        storyId: snapshot['postId'],
        profilePhotoUrl: snapshot['profilePhotoUrl'],
        storyPhotoUrl: snapshot['postPhotoUrl'],
        datePublished: snapshot['datePublished']);
  }
}
