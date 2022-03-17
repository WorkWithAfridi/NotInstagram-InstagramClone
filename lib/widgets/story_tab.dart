import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:not_instagram/screens/upload_story.dart';
import 'package:not_instagram/screens/view_story_screen.dart';
import 'package:not_instagram/utils/global_variables.dart';
import 'package:not_instagram/widgets/circleAnimation.dart';
import 'package:provider/provider.dart';

import '../constants/cacheManager.dart';
import '../model/user.dart';
import '../providers/user_provider.dart';
import '../utils/colors.dart';

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
    await Future.delayed(const Duration(seconds: 4));
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final UserModel user = Provider.of<UserProvider>(context).user;
    return isLoading
        ? const LinearProgressIndicator(
            minHeight: 1,
          )
        : Column(
            children: [
              SizedBox(
                height: 85,
                width: MediaQuery.of(context).size.width,
                // color: Colors.yellow,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const AddStoryScreen(),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: SizedBox(
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
                                              child: CachedNetworkImage(
                                                cacheManager: cacheManager,
                                                imageUrl: user.photoUrl,
                                                fit: BoxFit.cover,
                                                alignment: FractionalOffset.center,
                                                placeholder: (context, url) => Container(
                                                  color: backgroundColor,
                                                  alignment: Alignment.center,
                                                  child: CircularProgressIndicator(
                                                    color: Colors.pink,
                                                  ),
                                                ),
                                                errorWidget: (context, url, error) => Container(
                                                  color: backgroundColor,
                                                  alignment: Alignment.center,
                                                  child: Icon(
                                                    Icons.error,
                                                    color: Colors.pink,
                                                  ),
                                                ),
                                              )



                                              // Image.network(
                                              //   user.photoUrl,
                                              //   fit: BoxFit.cover,
                                              // ),
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
                                            child: const Icon(
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
                            return const Center(
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
                                        parentSnap: snapshot.data!,
                                        indexPosition: index,
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
                                  child: SizedBox(
                                    width: 70,
                                    height: double.infinity,
                                    // color: Colors.pink,
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            child: Stack(
                                              children: [
                                                Center(
                                                  child: CircleAnimation(
                                                    child: Container(
                                                      height: 65,
                                                      width: 65,
                                                      decoration: BoxDecoration(
                                                        // color: Colors.pink,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(65),
                                                        gradient:
                                                            LinearGradient(
                                                                colors: [
                                                                  Colors.orange
                                                                      .withOpacity(
                                                                          .8),
                                                                  Colors
                                                                      .orangeAccent
                                                                      .withOpacity(
                                                                          .8),
                                                                  Colors.pink
                                                                      .withOpacity(
                                                                          .8),
                                                                  Colors
                                                                      .redAccent
                                                                      .withOpacity(
                                                                          .8),
                                                                  //add more colors for gradient
                                                                ],
                                                                begin: Alignment
                                                                    .topLeft, //begin of the gradient color
                                                                end: Alignment
                                                                    .bottomRight, //end of the gradient color
                                                                stops: const [
                                                                  0,
                                                                  0.2,
                                                                  0.5,
                                                                  0.8
                                                                ] //stops for individual color
                                                                //set the stops number equal to numbers of color
                                                                ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Center(
                                                  child: Container(
                                                    height: 60,
                                                    width: 60,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              65),
                                                      child: Hero(
                                                        tag: snapshot.data!
                                                                .docs[index]
                                                            ['postPhotoUrl'],
                                                        child: CachedNetworkImage(
                                                          cacheManager: cacheManager,
                                                          imageUrl: snapshot.data!.docs[index]['postPhotoUrl'],
                                                          fit: BoxFit.cover,
                                                          alignment: FractionalOffset.center,
                                                          placeholder: (context, url) => Container(
                                                            color: backgroundColor,
                                                            alignment: Alignment.center,
                                                            child: CircularProgressIndicator(
                                                              color: Colors.pink,
                                                            ),
                                                          ),
                                                          errorWidget: (context, url, error) => Container(
                                                            color: backgroundColor,
                                                            alignment: Alignment.center,
                                                            child: Icon(
                                                              Icons.error,
                                                              color: Colors.pink,
                                                            ),
                                                          ),
                                                        )


                                                        // Image.network(
                                                        //   snapshot.data!
                                                        //           .docs[index]
                                                        //       ['postPhotoUrl'],
                                                        //   fit: BoxFit.cover,
                                                        // ),
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
                                          maxLines: 1,
                                          textAlign: TextAlign.center,
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
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
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
