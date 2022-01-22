import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:not_instagram/model/posts.dart';
import 'package:not_instagram/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethods {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  //upload post
  Future<String> uploadPost(
    Uint8List file,
    String description,
    String uid,
    String userName,
    String profilePictureUrl,
  ) async {
    String res = 'Some Error occurred.';
    try {
      String photoUrl = await StorageMethods()
          .uploadImageToStorage(childName: 'posts', file: file, isPost: true);

      String postId = Uuid().v1();

      Posts post = Posts.name(
        description: description,
        userName: userName,
        userId: uid,
        postId: postId,
        profilePhotoUrl: profilePictureUrl,
        postPhotoUrl: photoUrl,
        likes: [],
        datePublished: DateTime.now().toString(),
      );

      _firebaseFirestore.collection('posts').doc(postId).set(post.toJson());
      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
