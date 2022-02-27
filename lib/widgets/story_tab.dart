import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:not_instagram/screens/post_story_screen.dart';
import 'package:not_instagram/screens/view_story_screen.dart';
import 'package:not_instagram/utils/global_variables.dart';
import 'package:provider/provider.dart';

import '../model/user.dart';
import '../providers/user_provider.dart';
import '../utils/utils.dart';

class StoryTab extends StatefulWidget {
  const StoryTab({Key? key}) : super(key: key);

  @override
  _StoryTabState createState() => _StoryTabState();
}

class _StoryTabState extends State<StoryTab> {
  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  void getData() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).user;
    return isLoading
        ? LinearProgressIndicator()
        : Column(
            children: [
              Container(
                height: 80,
                width: MediaQuery.of(context).size.width,
                // color: Colors.yellow,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => AddStoryScreen(),
                            ),
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.only(left: 15.0),
                          child: Container(
                            width: 70,
                            height: double.infinity,
                            // color: Colors.pink,
                            child: Column(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 65,
                                    width: 65,
                                    decoration: BoxDecoration(
                                      color: Colors.pink,
                                      borderRadius: BorderRadius.circular(65),
                                    ),
                                    child: Stack(
                                      children: [
                                        Center(
                                          child: Container(
                                            height: 60,
                                            width: 60,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(65),
                                              child: Image.network(
                                                user.photoUrl,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: Colors.pink,
                                            ),
                                            child: Icon(
                                              Icons.add,
                                              size: 20,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Text(
                                  'Your story',
                                  style: headerTextStyle.copyWith(
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('stories')
                              .orderBy('datePublished', descending: true)
                              .snapshots(),
                          builder: (context,
                              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                  snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => ViewStory(
                                          snap: snapshot.data!.docs[index],
                                          user: user,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 7.0,
                                        right: index ==
                                                snapshot.data!.docs.length - 1
                                            ? 15
                                            : 0),
                                    child: Container(
                                      width: 70,
                                      height: double.infinity,
                                      // color: Colors.pink,
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              height: 65,
                                              width: 65,
                                              decoration: BoxDecoration(
                                                // color: Colors.pink,
                                                borderRadius:
                                                    BorderRadius.circular(65),
                                                gradient: LinearGradient(
                                                    colors: [
                                                      Colors.orange
                                                          .withOpacity(.8),
                                                      Colors.orangeAccent
                                                          .withOpacity(.8),
                                                      Colors.red
                                                          .withOpacity(.8),
                                                      Colors.redAccent
                                                          .withOpacity(.8),
                                                      //add more colors for gradient
                                                    ],
                                                    begin: Alignment
                                                        .topLeft, //begin of the gradient color
                                                    end: Alignment
                                                        .bottomRight, //end of the gradient color
                                                    stops: [
                                                      0,
                                                      0.2,
                                                      0.5,
                                                      0.8
                                                    ] //stops for individual color
                                                    //set the stops number equal to numbers of color
                                                    ),
                                              ),
                                              child: Stack(
                                                children: [
                                                  Center(
                                                    child: Container(
                                                      height: 60,
                                                      width: 60,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(65),
                                                        child: Hero(
                                                          tag: snapshot.data!
                                                                  .docs[index]
                                                              ['postPhotoUrl'],
                                                          child: Image.network(
                                                            snapshot.data!
                                                                    .docs[index]
                                                                [
                                                                'postPhotoUrl'],
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Text(
                                            snapshot.data!.docs[index]
                                                ['username'],
                                            style: headerTextStyle.copyWith(
                                                fontSize: 15,
                                                fontWeight: FontWeight.normal),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                height: .5,
                color: Colors.white.withOpacity(.2),
              ),
            ],
          );
  }
}
