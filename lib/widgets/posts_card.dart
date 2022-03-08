import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:not_instagram/model/user.dart';
import 'package:not_instagram/providers/user_provider.dart';
import 'package:not_instagram/resources/firestore_method.dart';
import 'package:not_instagram/screens/comments_screen.dart';
import 'package:not_instagram/screens/edit_post_screen.dart';
import 'package:not_instagram/screens/user_profile_screen.dart';
import 'package:not_instagram/screens/visitor_user_profile.dart';
import 'package:not_instagram/utils/global_variables.dart';
import 'package:not_instagram/utils/utils.dart';
import 'package:provider/provider.dart';

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

  void getData() async {
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

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).user;
    return SizedBox(
      // padding: EdgeInsets.symmetric(vertical: 0, horizontal: ),
      // color: Colors.black38,
      height: 500,
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
                        User tempUser = User.name(
                          email: snapshot.docs[0]['email'],
                          userName: snapshot.docs[0]['username'],
                          userId: snapshot.docs[0]['uid'],
                          bio: snapshot.docs[0]['bio'],
                          photoUrl: snapshot.docs[0]['photoUrl'],
                          followers: [],
                          following: [],
                          chatRooms: [],
                        );

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                VisitorProfileScreen(user: tempUser),
                          ),
                        );
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
                                            String res =
                                                await FireStoreMethods()
                                                    .deletePost(
                                                        widget.snap['postId'],
                                                        context);
                                            showSnackbar(context, res);
                                            Navigator.pop(context);
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
                  child: Image.network(
                    widget.snap['postPhotoUrl'],
                    fit: BoxFit.cover,
                    alignment: FractionalOffset.center,
                  ),
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
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CommentsScreen(
                              snap: widget.snap,
                            ),
                          ),
                        );
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
                    DateFormat.yMMMd().format(
                      DateTime.parse(
                        widget.snap['datePublished'],
                      ),
                    ),
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
