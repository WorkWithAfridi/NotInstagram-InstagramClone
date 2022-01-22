import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:not_instagram/model/user.dart' as model;
import 'package:not_instagram/providers/user_provider.dart';
import 'package:not_instagram/screens/app_post.dart';
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
    getData();
    super.initState();
  }

  void getData() async {
    _page = 0;
    addData() async {
      UserProvider _userProvider = Provider.of(context, listen: false);
      await _userProvider.refreshUser();
    }

    pageController = PageController();

    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    userName = (documentSnapshot.data() as Map<String, dynamic>)['username'];
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
      appBar: PreferredSize(preferredSize: Size.fromHeight(0), child: AppBar()),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child:
        // AddPostScreen()

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
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              label: 'Home',
              backgroundColor: Colors.pink),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
              ),
              label: 'Search',
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
              icon: Icon(
                Icons.person,
              ),
              label: 'Account',
              backgroundColor: Colors.pink),
        ],
        onTap: (value) {
          setState(() {
            _page = value;
            print(value);
          });
          pageController.jumpToPage(_page);
        },
        currentIndex: _page,
      ),
    );
  }
}
