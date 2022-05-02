import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:not_instagram/constants/cacheManager.dart';
import 'package:not_instagram/constants/layout_constraints.dart';
import 'package:not_instagram/model/user.dart';
import 'package:not_instagram/providers/user_provider.dart';
import 'package:not_instagram/resources/firestore_method.dart';
import 'package:not_instagram/screens/comments_screen.dart';
import 'package:not_instagram/screens/edit_post_screen.dart';
import 'package:not_instagram/screens/user_profile_screen.dart';
import 'package:not_instagram/screens/visitor_user_profile.dart';
import 'package:not_instagram/utils/colors.dart';
import 'package:not_instagram/utils/global_variables.dart';
import 'package:not_instagram/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  int noOfComments = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  late UserProvider userProvider;

  void getData() async {
    userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      QuerySnapshot querySnap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();

      setState(() {
        noOfComments = querySnap.docs.length;
      });
    } catch (e) {}
  }

  void deletePost() async {
    String res =
        await FireStoreMethods().deletePost(widget.snap['postId'], context);
    showSnackbar(context, res);
    Navigator.pop(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final UserModel user = Provider.of<UserProvider>(context).user;
    return SizedBox(
      // padding: EdgeInsets.symmetric(vertical: 0, horizontal: ),
      // color: Colors.black38,
      height: getHeight(context) * .8 < 500 ? 600 : getHeight(context) * .8,
      width: double.infinity,
      child: Card(
        color: backgroundColor,
        elevation: 0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      String postUserId = widget.snap['uid'];
                      var snapshot = await FirebaseFirestore.instance
                          .collection('users')
                          .where(
                            'uid',
                            isEqualTo: postUserId,
                          )
                          .get();

                      if (snapshot.docs[0]['uid'] == user.userId) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const UserProfileScreen(),
                          ),
                        );
                      } else {
                        UserModel tempUser = UserModel.name(
                          email: snapshot.docs[0]['email'],
                          userName: snapshot.docs[0]['username'],
                          userId: snapshot.docs[0]['uid'],
                          bio: snapshot.docs[0]['bio'],
                          photoUrl: snapshot.docs[0]['photoUrl'],
                          followers: [],
                          following: [],
                          chatRooms: [],
                        );

                        Navigator.of(context)
                            .push(
                          MaterialPageRoute(
                            builder: (context) =>
                                VisitorProfileScreen(user: tempUser),
                          ),
                        )
                            .then((value) async {
                          await userProvider.refreshUser();
                          setState(() {});
                        });
                      }
                    },
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: CircleAvatar(
                            backgroundColor: Colors.black12,
                            backgroundImage:
                                NetworkImage(widget.snap['profilePhotoUrl']),
                          ),
                        ),
                        Text(
                          widget.snap['username'],
                          style: headerTextStyle,
                        ),
                        userProvider.user.following
                                    .contains(widget.snap['uid']) ||
                                userProvider.user.userId == widget.snap['uid']
                            ? SizedBox.shrink()
                            : Text(
                                ' Follow',
                                style: headerTextStyle.copyWith(
                                    color: Colors.pink),
                              )
                      ],
                    ),
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
                            children: widget.snap['uid'] == user.userId
                                ? [
                                    'Delete',
                                    'Edit',
                                  ]
                                    .map(
                                      (e) => InkWell(
                                        onTap: () async {
                                          if (e == 'Delete') {
                                            deletePost();
                                          }
                                          if (e == 'Edit') {
                                            if (widget.snap['uid'] ==
                                                user.userId) {
                                              Navigator.of(context).pop();
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditPostScreen(
                                                    snap: widget.snap,
                                                  ),
                                                ),
                                              );
                                            } else {
                                              Navigator.of(context).pop();
                                              showSnackbar(context,
                                                  'You are not the owner of this post!');
                                            }
                                          }
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 16),
                                          child: Text(
                                            e,
                                            style: subHeaderTextStyle,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList()
                                : [
                                    'Report',
                                  ]
                                    .map(
                                      (e) => InkWell(
                                        onTap: () async {
                                          if (e == 'Report') {
                                            print(widget.snap['postId']);
                                            String res =
                                                await FireStoreMethods()
                                                    .reportPost(
                                                        widget.snap['postId'],
                                                        widget.snap['uid'],
                                                        widget
                                                            .snap['username']);

                                            Navigator.of(context).pop();
                                            showSnackbar(context, res);
                                          }
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 16),
                                          child: Text(
                                            e,
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
                    icon: const Icon(
                      Icons.more_vert,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.black26,
                width: double.infinity,
                height: double.infinity,
                child: Hero(
                    tag: widget.snap['postPhotoUrl'],
                    child: CachedNetworkImage(
                      cacheManager: cacheManager,
                      imageUrl: widget.snap['postPhotoUrl'],
                      fit: BoxFit.cover,
                      alignment: FractionalOffset.center,
                      placeholder: (context, url) => Container(
                        color: backgroundColor,
                        // alignment: Alignment.center,
                        // child: CircularProgressIndicator(
                        //   color: Colors.pink,
                        // ),
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
                    //   widget.snap['postPhotoUrl'],
                    //   fit: BoxFit.cover,
                    //   alignment: FractionalOffset.center,
                    // ),
                    ),
              ),
            ),
            Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 0),
              // color: Colors.purple,
              child: Row(
                children: [
                  SizedBox(
                    width: 40,
                    // color: Colors.blue,
                    child: IconButton(
                        onPressed: () async {
                          await FireStoreMethods().likePost(
                              widget.snap['postId'],
                              user.userId,
                              widget.snap['likes']);
                          setState(() {});
                        },
                        icon: Icon(
                          widget.snap['likes'].contains(user.userId)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: widget.snap['likes'].contains(user.userId)
                              ? Colors.red
                              : Colors.white,
                        )),
                  ),
                  SizedBox(
                    width: 40,
                    // color: Colors.green,
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context)
                            .push(
                          MaterialPageRoute(
                            builder: (context) => CommentsScreen(
                              snap: widget.snap,
                            ),
                          ),
                        )
                            .then((value) async {
                          //TODO: implement refresh future
                          // print('refreshing');
                          // await Future.delayed(const Duration(seconds: 1));
                          // setState(() {});
                        });
                      },
                      icon: const Icon(
                        FontAwesomeIcons.commentDots,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 40,
                    // color: Colors.red,
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.bookmark_add_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              // height: 100,
              // color: Colors.purple,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.snap['likes'].length > 0
                      ? (widget.snap['likes'].length > 1
                          ? Text(
                              '${widget.snap['likes'].length} likes.',
                              style: subHeaderTextStyle,
                            )
                          : Text(
                              '${widget.snap['likes'].length} like.',
                              style: subHeaderTextStyle,
                            ))
                      : Container(),
                  Text(
                    widget.snap['username'],
                    style: headerTextStyle,
                  ),
                  widget.snap['description'].toString().isNotEmpty
                      ? Text(
                          '${widget.snap['description']}',
                          maxLines: 2,
                          style: headerTextStyle.copyWith(
                              fontWeight: FontWeight.w400, fontSize: 15),
                          overflow: TextOverflow.ellipsis,
                        )
                      : Container(),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CommentsScreen(
                            snap: widget.snap,
                          ),
                        ),
                      );
                    },
                    child: noOfComments > 0
                        ? Text(
                            'View all $noOfComments comments...',
                            style: subHeaderNotHighlightedTextStyle,
                          )
                        : Container(),
                  ),
                  Text(
                    timeago.format(widget.snap['datePublished'].toDate()),
                    style: subHeaderNotHighlightedTextStyle,
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
