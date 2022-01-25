import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:not_instagram/model/posts.dart';
import 'package:not_instagram/model/user.dart';
import 'package:not_instagram/providers/user_provider.dart';
import 'package:not_instagram/resources/storage_methods.dart';
import 'package:provider/provider.dart';
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

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firebaseFirestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await _firebaseFirestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> postComment(
      {required String postId,
      required String text,
      required String uid,
      required String name,
      required String profilePic}) async {
    String res = 'Some error occurred.';
    try {
      if (text.isNotEmpty) {
        String commentId = Uuid().v1();
        await _firebaseFirestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          // TODO: create model later
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
        res = 'Comment posted';
      } else {
        res = 'No input..';
      }
    } catch (e) {
      print(e.toString());
    }
    return res;
  }

  Future<String> deletePost(String postId, BuildContext context) async {
    String res = 'An error occurred.';
    try {
      DocumentSnapshot documentSnapshot = await _firebaseFirestore.collection('posts').doc(postId).get();
      String postUid= (documentSnapshot.data() as Map<String, dynamic>)['uid'];
      User _user = Provider.of<UserProvider>(context, listen: false).user;
      // print(_user.userId);
      // print(postUid);
      // print(postUid.toString()==_user.userId.toString());
      if(postUid==_user.userId){
        await _firebaseFirestore.collection('posts').doc(postId).delete();
        res='Post Deleted.';
      }else{
        res='You are not the owner of this post';
      }
    } catch (e) {
      print(e.toString());
    }
    return res;
  }
}
