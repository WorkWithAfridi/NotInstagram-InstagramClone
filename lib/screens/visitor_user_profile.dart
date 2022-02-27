import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import 'package:flutter/material.dart';
import 'package:not_instagram/model/user.dart';
import 'package:not_instagram/providers/user_provider.dart';
import 'package:not_instagram/screens/chat_screen.dart';
import 'package:not_instagram/utils/global_variables.dart';
import 'package:not_instagram/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

import 'detailed_post_screen.dart';

class VisitorProfileScreen extends StatefulWidget {
  final User user;
  const VisitorProfileScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  _VisitorProfileScreenState createState() => _VisitorProfileScreenState();
}

class _VisitorProfileScreenState extends State<VisitorProfileScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  var postSnap = null;
  bool isFollowing = false;

  void getData() async {
    print(widget.user.userId);
    var snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.userId)
        .get();
    widget.user.following = snap.data()!['following'].cast<String>();
    widget.user.followers = snap.data()!['followers'].cast<String>();

    postSnap = await FirebaseFirestore.instance
        .collection('posts')
        .where(
          'uid',
          isEqualTo: widget.user.userId,
        )
        .get();

    User _user = Provider.of<UserProvider>(context, listen: false).user;
    isFollowing = widget.user.followers
        .contains(FirebaseAuth.FirebaseAuth.instance.currentUser!.uid);


    print(widget.user.followers);
    print(_user.userId);
    print(isFollowing);

    setState(() {
      print('setting state');
    });
  }

  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 2, vsync: this);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.user.userName,
          style: headerTextStyle.copyWith(fontSize: 25),
        ),
        elevation: 0,
        backgroundColor: backgroundColor,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.add_circle)),
          IconButton(onPressed: () {}, icon: Icon(Icons.menu))
        ],
      ),
      backgroundColor: backgroundColor,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              // color: Colors.yellow,
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: backgroundColor,
                    backgroundImage: NetworkImage(
                      widget.user.photoUrl,
                    ),
                    radius: 40,
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              postSnap == null ? '0' : postSnap.size.toString(),
                              style: headerTextStyle.copyWith(fontSize: 18),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Posts',
                              style: headerTextStyle.copyWith(fontSize: 18),
                            )
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              widget.user.followers.length.toString(),
                              style: headerTextStyle.copyWith(fontSize: 18),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Followers',
                              style: headerTextStyle.copyWith(fontSize: 18),
                            )
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              widget.user.following.length.toString(),
                              style: headerTextStyle.copyWith(fontSize: 18),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Following',
                              style: headerTextStyle.copyWith(fontSize: 18),
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                widget.user.userName,
                style: headerTextStyle,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                widget.user.bio,
                style: subHeaderNotHighlightedTextStyle.copyWith(fontSize: 17),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: isFollowing
                  ? Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: Container(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                DocumentSnapshot snap = await FirebaseFirestore
                                    .instance
                                    .collection('users')
                                    .doc(widget.user.userId) //visitor user id
                                    .get();
                                List followers =
                                    (snap.data()! as dynamic)['followers'];

                                print('0-00000000000000000000');
                                print(followers.length);

                                if (followers.contains(FirebaseAuth
                                    .FirebaseAuth.instance.currentUser!.uid)) {
                                  print('yes the list contains the usre');
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(widget.user.userId)
                                      .update({
                                    'followers': FieldValue.arrayRemove([
                                      FirebaseAuth.FirebaseAuth.instance
                                          .currentUser!.uid
                                    ])
                                  });

                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(FirebaseAuth.FirebaseAuth.instance
                                          .currentUser!.uid)
                                      .update({
                                    'following': FieldValue.arrayRemove(
                                        [widget.user.userId])
                                  });
                                }

                                setState(() {
                                  isFollowing = false;
                                  getData();
                                });
                              },
                              child: Text(
                                'Unfollow',
                                style: subHeaderTextStyle,
                              ),
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.pink),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          flex: 1,
                          child: Container(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ChatScreen(user2: widget.user,)));
                              },
                              child: Text(
                                'Send message',
                                style: subHeaderTextStyle,
                              ),
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.pink),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              try {
                                DocumentSnapshot snap = await FirebaseFirestore
                                    .instance
                                    .collection('users')
                                    .doc(widget.user.userId)
                                    .get();
                                List following =
                                    (snap.data()! as dynamic)['followers'];

                                print(following);

                                if (!following.contains(FirebaseAuth
                                    .FirebaseAuth.instance.currentUser!.uid)) {
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(widget.user.userId)
                                      .update({
                                    'followers': FieldValue.arrayUnion([
                                      FirebaseAuth.FirebaseAuth.instance
                                          .currentUser!.uid
                                    ])
                                  });

                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(FirebaseAuth.FirebaseAuth.instance
                                          .currentUser!.uid)
                                      .update({
                                    'following': FieldValue.arrayUnion(
                                        [widget.user.userId])
                                  });
                                }
                              } catch (e) {
                                showSnackbar(context, e.toString());
                              }
                              setState(() {
                                isFollowing = true;
                                getData();
                              });
                              // var snap = await FirebaseFirestore.instance
                              //     .collection('posts')
                              //     .where(
                              //       'uid',
                              //       isEqualTo: widget.user.userId,
                              //     )
                              //     .get();
                              //
                              // print(snap.size);
                            },
                            child: Text(
                              'Follow',
                              style: subHeaderTextStyle,
                            ),
                            style:
                                ElevatedButton.styleFrom(primary: Colors.pink),
                          ),
                        ),
                      ],
                    ),
            ),
            TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.grid_3x3),
                ),
                Tab(
                  icon: Icon(Icons.bookmark),
                )
              ],
              controller: _tabController,
            ),
            Expanded(
              child: Container(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    Container(
                      // color: Colors.red,
                      child: FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('posts')
                            .where(
                              'uid',
                              isEqualTo: widget.user.userId,
                            )
                            .get(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return StaggeredGridView.countBuilder(
                            crossAxisCount: 3,
                            itemCount: (snapshot.data! as dynamic).docs.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => DetailedImageScreen(
                                        postId: (snapshot.data! as dynamic)
                                            .docs[index]['postPhotoUrl'],
                                      ),
                                    ),
                                  );
                                },
                                child: Image.network(
                                  (snapshot.data! as dynamic).docs[index]
                                      ['postPhotoUrl'],
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                            staggeredTileBuilder: (index) =>
                                StaggeredTile.count((index % 7 == 0) ? 2 : 1,
                                    (index % 7 == 0) ? 2 : 1),
                            mainAxisSpacing: 4,
                            crossAxisSpacing: 4,
                          );
                        },
                      ),
                    ),
                    Container(
                      color: backgroundColor,
                      child: Center(child: Text('Work in progress...',style: headerTextStyle,),),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
