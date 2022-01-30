import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:not_instagram/screens/login_screen.dart';
import 'package:not_instagram/screens/messanger_screen.dart';
import 'package:not_instagram/utils/global_variables.dart';
import 'package:not_instagram/widgets/posts_card.dart';

class MyFeedScreen extends StatelessWidget {
  const MyFeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Not Instagram',
          style: titleTextStyle.copyWith(fontSize: 20),
        ),
        backgroundColor: backgroundColor,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => MessangerScreen()));
            },
            icon: Icon(FontAwesomeIcons.comment),
          ),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => Dialog(
                  child: ListView(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shrinkWrap: true,
                    children: [
                      'Settings',
                      'Logout',
                    ]
                        .map(
                          (option) => InkWell(
                            onTap: () {
                              if (option == 'Logout') {
                                FirebaseAuth.instance.signOut();
                                Navigator.of(context).pop();
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreen(),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 16),
                              child: Text(option),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              );
            },
            icon: Icon(Icons.menu),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .orderBy('datePublished', descending: true)
              .snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return PostCard(
                  snap: snapshot.data!.docs[index],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
