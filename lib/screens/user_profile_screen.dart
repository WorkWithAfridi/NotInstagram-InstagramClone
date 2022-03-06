import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:not_instagram/model/user.dart';
import 'package:not_instagram/providers/user_provider.dart';
import 'package:not_instagram/screens/edit_profile_screen.dart';
import 'package:not_instagram/utils/global_variables.dart';
import 'package:provider/provider.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

import 'detailed_post_screen.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  var postSnap = null;

  void getData() async {
    Provider.of<UserProvider>(context, listen: false).refreshUser();
    User _user = Provider.of<UserProvider>(context, listen: false).user;
    postSnap = await FirebaseFirestore.instance
        .collection('posts')
        .where(
          'uid',
          isEqualTo: _user.userId,
        )
        .get();

    print(_user.following);
    setState(() {
      print('setting state');
    });
  }

  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 2, vsync: this);
    Provider.of<UserProvider>(context, listen: false).refreshUser();
    User _user = Provider.of<UserProvider>(context, listen: false).user;
    print(_user.followers.length);
    print(_user.userId);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _user.userName,
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
                      _user.photoUrl,
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
                              _user.followers.length.toString(),
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
                              _user.following.length.toString(),
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
                _user.userName,
                style: headerTextStyle,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                _user.bio,
                style: subHeaderNotHighlightedTextStyle.copyWith(fontSize: 17),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EditProfileScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Edit Profile',
                        style: subHeaderTextStyle,
                      ),
                      style: ElevatedButton.styleFrom(primary: Colors.pink),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    // width: 30,
                    // color: Colors.pink,
                    child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.keyboard_arrow_down_sharp,
                          color: Colors.white,
                        )),
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
                              isEqualTo: _user.userId,
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
                            physics: BouncingScrollPhysics(),
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
                                child: Hero(
                                  tag: (snapshot.data! as dynamic).docs[index]
                                      ['postPhotoUrl'],
                                  child: Image.network(
                                    (snapshot.data! as dynamic).docs[index]
                                        ['postPhotoUrl'],
                                    fit: BoxFit.cover,
                                  ),
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
                      // color: Colors.yellow,
                      alignment: Alignment.center,
                      child: Text(
                        'No bookmarks found',
                        style: subTitleTextStyle,
                      ),
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
