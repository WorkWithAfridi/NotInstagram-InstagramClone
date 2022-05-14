import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:not_instagram/functions/open_webview.dart';
import 'package:not_instagram/providers/user_provider.dart';
import 'package:not_instagram/resources/auth_methods.dart';
import 'package:not_instagram/screens/login_screen.dart';
import 'package:not_instagram/screens/messanger_screen.dart';
import 'package:not_instagram/screens/upload_post.dart';
import 'package:not_instagram/utils/global_variables.dart';
import 'package:not_instagram/widgets/posts_card.dart';
import 'package:not_instagram/widgets/story_tab.dart';
import 'package:provider/provider.dart';

import '../utils/utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  openSettingPopUp(BuildContext context) {
    return showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) {
        return SimpleDialog(
          elevation: 6,
          backgroundColor: backgroundColor,
          title: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => OpenWebView(
                      websiteLink:
                          'https://sites.google.com/view/workwithafridi'),
                ),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '!instagram',
                  style: AppTitleTextStyle,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'By KYOTO',
                  style: creatorTextStyle,
                ),
              ],
            ),
          ),
          children: [
            SimpleDialogOption(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Text(
                'Settings',
                style: subHeaderTextStyle,
              ),
              onPressed: () async {},
            ),
            SimpleDialogOption(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Text(
                'Logout',
                style: subHeaderTextStyle,
              ),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  late UserProvider userProvider;
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.refreshUser().then((value) {
      print(userProvider.user.following);
      setState(() {
        isLoading = false;
      });
    });
    // AuthMethods().getUserDetails().then((value) {
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '!instagram',
          style: AppTitleTextStyle.copyWith(fontSize: 20),
        ),
        backgroundColor: backgroundColor,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () async {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const MessangerScreen()));
            },
            icon: const Icon(FontAwesomeIcons.comment),
          ),
          IconButton(
            onPressed: () {
              openSettingPopUp(context);
            },
            icon: const Icon(Icons.menu),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      body: Consumer<UserProvider>(builder: (context, provider, childProperty) {
        return SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('posts')
                      .orderBy('datePublished', descending: true)
                      .snapshots(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return LiquidPullToRefresh(
                      onRefresh: () async {
                        //TODO: implement refresh future

                        // await Future.delayed(const Duration(seconds: 1));
                        // setState(() {});
                      },
                      color: backgroundColor,
                      showChildOpacityTransition: false,
                      backgroundColor: Colors.white,
                      height: 100,
                      child:
                      // provider.user.following.length == 0
                      //     ? Center(
                      //         child: Padding(
                      //           padding: EdgeInsets.symmetric(horizontal: 45),
                      //           child: Text(
                      //             "Its quite empty down here! Maybe try uploading some memories or following someone? :)",
                      //             style: subHeaderNotHighlightedTextStyle,
                      //             textAlign: TextAlign.center,
                      //           ),
                      //         ),
                      //       )
                      //     :
                      SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                children: [
                                  const StoryTab(),
                                  ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: snapshot.data!.docs.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      print(snapshot.data!.docs[index]
                                      ['uid']);
                                      print(provider.user.userId);

                                      return provider.user.following.contains(
                                                  snapshot.data!.docs[index]
                                                      ['uid']) ||
                                              snapshot.data!.docs[index]
                                                      ['uid'] ==
                                                  provider.user.userId
                                          ? PostCard(
                                              snap: snapshot.data!.docs[index],
                                            )
                                          : SizedBox.shrink();
                                    },
                                  ),
                                ],
                              ),
                            ),
                    );
                  },
                ),
        );
      }),
    );
  }
}
