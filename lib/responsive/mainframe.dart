import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:not_instagram/model/user.dart' as model;
import 'package:not_instagram/providers/user_provider.dart';
import 'package:not_instagram/screens/explore_screen.dart';
import 'package:not_instagram/screens/user_profile_screen.dart';
import 'package:not_instagram/screens/upload_post.dart';
import 'package:not_instagram/utils/colors.dart';
import 'package:not_instagram/utils/global_variables.dart';
import 'package:not_instagram/utils/utils.dart';
import 'package:provider/provider.dart';

import '../functions/getImage.dart';

class MainFrame extends StatefulWidget {
  const MainFrame({Key? key}) : super(key: key);

  @override
  State<MainFrame> createState() => _MainFrameState();
}

class _MainFrameState extends State<MainFrame> {
  String userName = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getData();
  }

  void getData() async {
    _page = 0;

    pageController = PageController();

    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    userName = (documentSnapshot.data() as Map<String, dynamic>)['username'];

    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    userProvider.refreshUser();
  }

  late PageController pageController;

  late int _page;
  @override
  void dispose() {
    // TODO: implement dispose
    // pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    model.UserModel _user =
        Provider.of<UserProvider>(context, listen: false).user;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(
          backgroundColor: backgroundColor,
          elevation: 0,
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child:
            // ProfileScreen()

            PageView(
          children: Pages,

          // physics: BouncingScrollPhysics(),
          controller: pageController,
          onPageChanged: (value) {
            if (value == 2) {
              setState(() {
                _page = 3;
              });
            } else {
              setState(() {
                _page = value;
              });
            }
          },
        ),
      ),
      // backgroundColor: Colors.black87,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.white,
        unselectedItemColor: Colors.white38,
        backgroundColor: backgroundColor,
        elevation: 6,
        enableFeedback: false,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        iconSize: 25,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              label: 'Home',
              backgroundColor: Colors.pink),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.explore,
              ),
              label: 'Explore',
              backgroundColor: Colors.pink),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.add_circle,
              ),
              label: 'Post',
              backgroundColor: Colors.pink),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite,
              ),
              label: 'Likes',
              backgroundColor: Colors.pink),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Account',
              backgroundColor: Colors.pink),
        ],
        onTap: (value) {
          if (value == 2) {
            GetImage().OpenDialogAndShowOptionToPickImageFrom(context, false);
          } else if (value > 2) {
            setState(() {
              _page = value - 1;
            });
            pageController.jumpToPage(_page);
          } else {
            setState(() {
              _page = value;
            });
            pageController.jumpToPage(_page);
          }
        },
        currentIndex: _page,
      ),
    );
  }
}
