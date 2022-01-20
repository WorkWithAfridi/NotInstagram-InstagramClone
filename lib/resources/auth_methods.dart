import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:not_instagram/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> signUpUser({
    required String email,
    required String password,
    required String userName,
    required String bio,
    required Uint8List file,
  }) async {
    String res = 'Some error occurred.';
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          userName.isNotEmpty ||
          file != null) {
        //reg user
        UserCredential userCredential= await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        
        
        String photoUrl=await StorageMethods().uploadImageToStorage(childName: 'profilePics', file: file, isPost: false);
        // UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        //     email: email, password: password);
        //add user to db
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'username': userName,
          'uid': userCredential.user!.uid,
          'email': email,
          'bio': bio,
          'followers': [],
          'following': [],
          'photoUrl':photoUrl
        });

        res = 'success';
      }
    } catch (err) {
      res = err.toString();
    }

    return res;
  }
}
