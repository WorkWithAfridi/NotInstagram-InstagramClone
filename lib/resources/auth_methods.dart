import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:not_instagram/model/user.dart' as model;
import 'package:not_instagram/providers/user_provider.dart';
import 'package:not_instagram/resources/storage_methods.dart';
import 'package:provider/provider.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot documentSnapshot = await _firestore.collection('users').doc(currentUser.uid).get();
    return model.User.fromSnap(documentSnapshot);
  }

  Future<String> signUpUser({
    required String email,
    required String password,
    required String userName,
    required String bio,
    required Uint8List file,
  }) async {
    String res = 'An error occurred.';
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          userName.isNotEmpty ||
          file != null) {
        //reg user
        UserCredential userCredential = await _auth
            .createUserWithEmailAndPassword(email: email, password: password);

        String photoUrl = await StorageMethods().uploadImageToStorage(
            childName: 'profilePics', file: file, isPost: false);
        //add user to db

        model.User user = model.User.name(
            userName: userName,
            userId: userCredential.user!.uid,
            email: email,
            bio: bio,
            followers: [],
            following: [],
            photoUrl: photoUrl, chatRooms: []);


        await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(user.toJson());

        res = 'success';
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'invalid-email') res = "The email is badly formatted.";
      if (err.code == 'weak-password') res = "Weak Password.";
      if (err.code == 'email-already-in-use')
        res = "Email already linked with an account.";
      else
        res = err.code;
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> logInUser({
    required String email,
    required String password,
    required BuildContext context
  }) async {
    String res = 'An error occurred.';
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
            email: email, password: password);

        res = 'success';
        model.User _user = Provider.of<UserProvider>(context, listen: false).user;
        _user = await getUserDetails();
      } else {
        res = 'Please enter all the required fields.';
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'invalid-email') res = "The email is badly formatted.";
      if (err.code == 'user-not-found')
        res = "No user found. Please sign up and try again.";
      else
        res = 'Wrong Credentioals';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
