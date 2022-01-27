import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:not_instagram/model/user.dart' as model;
import 'package:not_instagram/providers/user_provider.dart';
import 'package:not_instagram/screens/explore_screen.dart';
import 'package:not_instagram/screens/user_profile_screen.dart';
import 'package:not_instagram/screens/upload_post.dart';
import 'package:not_instagram/utils/colors.dart';
import 'package:not_instagram/utils/global_variables.dart';
import 'package:provider/provider.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
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

    // await Provider.of<UserProvider>(context,
    //     listen: false)
    //     .refreshUser();
    // print(documentSnapshot.data());
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
    model.User _user = Provider.of<UserProvider>(context, listen: false).user;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          backgroundColor: backgroundColor,
          elevation: 0,
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child:
            // ProfileScreen()

            PageView(
          children: homeScreenPages,

          // physics: BouncingScrollPhysics(),
          controller: pageController,
          onPageChanged: (value) {
            print(value);
            setState(() {
              _page = value;
            });
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
        iconSize: 25,
        items: [
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
              icon:
              Icon(Icons.person),

              // _user.photoUrl == null
              //     ? Icon(Icons.person)
              //     : CircleAvatar(
              //         backgroundColor: backgroundColor,
              //         backgroundImage: NetworkImage(_user.photoUrl),
              //         radius: 13,
              //       ),
              label: 'Account',
              backgroundColor: Colors.pink),
        ],
        onTap: (value) {
          setState(() {
            _page = value;
          });
          pageController.jumpToPage(_page);
        },
        currentIndex: _page,
      ),
    );
  }
}
