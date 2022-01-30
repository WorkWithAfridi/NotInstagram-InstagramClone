import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:not_instagram/model/user.dart';
import 'package:not_instagram/providers/user_provider.dart';
import 'package:not_instagram/screens/detailed_post_screen.dart';
import 'package:not_instagram/screens/user_profile_screen.dart';
import 'package:not_instagram/screens/visitor_user_profile.dart';
import 'package:not_instagram/utils/global_variables.dart';
import 'package:provider/provider.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _showUsers = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              height: kToolbarHeight,
              // color: Colors.white30,
              child: TextFormField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search',
                  border: InputBorder.none,
                  labelStyle: subHeaderTextStyle,
                ),
                style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 1),
                cursorColor: Colors.white,
                onFieldSubmitted: (String value) {
                  setState(() {
                    _showUsers = true;
                  });
                  print(value);
                },
                // onChanged: (value) {
                //   print(value);
                // },
              ),
            ),
            Expanded(
              child: Container(
                // color: Colors.purple,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: _showUsers
                    ? FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .where(
                              'username',
                              isGreaterThanOrEqualTo: _searchController.text,
                            )
                            .get(),
                        builder: (context, snapshot) {
                          print(_searchController.text);
                          if (!snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return ListView.builder(
                            itemCount: (snapshot.data! as dynamic).docs.length,
                            itemBuilder: (context, index) {
                              return Card(
                                color: backgroundColor,
                                elevation: 0,
                                child: GestureDetector(
                                  onTap: () async {
                                    if ((snapshot.data! as dynamic).docs[index]
                                            ['uid'] ==
                                        user.userId) {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              UserProfileScreen(),
                                        ),
                                      );
                                      return;
                                    }

                                    // DocumentSnapshot documentSnapshot = (await FirebaseFirestore.instance.collection('users').where('uid', isEqualTo: (snapshot.data! as dynamic).docs[0]
                                    // ['uid'] ).get()) as DocumentSnapshot<Object?>;

                                    // User tempUserTwo= await User.fromSnap(documentSnapshot);
                                    User tempUser = User.name(
                                      email: (snapshot.data! as dynamic)
                                          .docs[index]['email'],
                                      userName: (snapshot.data! as dynamic)
                                          .docs[index]['username'],
                                      userId: (snapshot.data! as dynamic)
                                          .docs[index]['uid'],
                                      bio: (snapshot.data! as dynamic)
                                          .docs[index]['bio'],
                                      photoUrl: (snapshot.data! as dynamic)
                                          .docs[index]['photoUrl'],
                                      followers: [],
                                      following: [],
                                    );

                                    // tempUser
                                    //
                                    // print((snapshot.data! as dynamic)
                                    //     .docs[index]['followers']);

                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            VisitorProfileScreen(
                                                user: tempUser),
                                      ),
                                    );
                                  },
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.black12,
                                      backgroundImage: NetworkImage(
                                          (snapshot.data! as dynamic)
                                              .docs[index]['photoUrl']),
                                    ),
                                    title: Text(
                                      (snapshot.data! as dynamic).docs[index]
                                          ['username'],
                                      style: headerTextStyle,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      )
                    : Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: FutureBuilder(
                          future: FirebaseFirestore.instance
                              .collection('posts')
                              .get(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return StaggeredGridView.countBuilder(
                              physics: BouncingScrollPhysics(),
                              crossAxisCount: 3,
                              itemCount:
                                  (snapshot.data! as dynamic).docs.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DetailedImageScreen(
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
              ),
            )
          ],
        ),
      ),
    );
  }
}
