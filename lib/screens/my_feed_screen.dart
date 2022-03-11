import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:not_instagram/screens/login_screen.dart';
import 'package:not_instagram/screens/messanger_screen.dart';
import 'package:not_instagram/utils/global_variables.dart';
import 'package:not_instagram/widgets/posts_card.dart';
import 'package:not_instagram/widgets/story_tab.dart';

class MyFeedScreen extends StatefulWidget {
  const MyFeedScreen({Key? key}) : super(key: key);

  @override
  State<MyFeedScreen> createState() => _MyFeedScreenState();
}

class _MyFeedScreenState extends State<MyFeedScreen> {
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
            onPressed: () async {
              //
              // DocumentSnapshot snap = await FirebaseFirestore.instance
              //     .collection('users')
              //     .doc(pLvwl0h0BDh5eAlhSjjmhNOmadv1)
              //     .get();
              // List following = (snap.data()! as dynamic)['followers'];

              // print('Starting');
              //
              // List userList = [];
              // for (int i = 0; i < 497; i++) {
              //   // userList.add('TempUser${i}');
              //   await FirebaseFirestore.instance
              //       .collection('users')
              //       .doc('pLvwl0h0BDh5eAlhSjjmhNOmadv1')
              //       .update(
              //     {
              //       'followers': FieldValue.arrayUnion(['TempUser${i+503}'])
              //     },
              //   );
              //   print('Adding user - TempUser${i+503}');
              // }
              //
              // await FirebaseFirestore.instance
              //     .collection('users')
              //     .doc('pLvwl0h0BDh5eAlhSjjmhNOmadv1')
              //     .update(
              //   {
              //     'followers': FieldValue.arrayUnion([...userList])
              //   },
              // );
              //
              // print('success');

              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const MessangerScreen()));
            },
            icon: const Icon(FontAwesomeIcons.comment),
          ),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                barrierColor: Colors.black54,
                builder: (context) => Dialog(
                  elevation: 6,
                  backgroundColor: backgroundColor,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 16),
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
                                    builder: (context) => const LoginScreen(),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 16),
                              child: Text(
                                option,
                                style: subHeaderTextStyle,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.menu),
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
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return LiquidPullToRefresh(
              onRefresh: () async {
                await Future.delayed(const Duration(seconds: 1));
                setState(() {});
              },
              color: backgroundColor,
              showChildOpacityTransition: false,
              backgroundColor: Colors.white,
              height: 100,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    const StoryTab(),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return PostCard(
                          snap: snapshot.data!.docs[index],
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
