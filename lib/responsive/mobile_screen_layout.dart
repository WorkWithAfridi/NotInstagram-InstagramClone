import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:not_instagram/model/user.dart' as model;
import 'package:not_instagram/providers/user_provider.dart';
import 'package:provider/provider.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  String userName='';
  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }

  void getData() async {
    addData() async {
      UserProvider _userProvider = Provider.of(context, listen: false);
      await _userProvider.refreshUser();
    }

    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();

    setState(() {
      userName=(documentSnapshot.data() as Map<String , dynamic>)['username'];
    });
    print(userName);
    // print(documentSnapshot.data());
  }

  @override
  Widget build(BuildContext context) {
    model.User _user = Provider.of<UserProvider>(context, listen: false).user;
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Center(
            child: Text(_user.userName=='userName'? 'loading' : _user.userName),
          ),
          ElevatedButton(onPressed: (){
            print(_user.userName);
          }, child: Text('Refresh')),
        ],
      ),
    );
  }
}
