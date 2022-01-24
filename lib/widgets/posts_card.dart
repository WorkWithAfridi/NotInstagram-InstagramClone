import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:not_instagram/model/user.dart';
import 'package:not_instagram/providers/user_provider.dart';
import 'package:not_instagram/resources/firestore_method.dart';
import 'package:not_instagram/screens/comments_screen.dart';
import 'package:not_instagram/widgets/like_animation.dart';
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
    return Container(
      // padding: EdgeInsets.symmetric(vertical: 0, horizontal: ),
      color: Colors.black38,
      height: MediaQuery.of(context).size.height * .6,
      width: double.infinity,
      child: Card(
        color: Colors.black38,
        elevation: 6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 60,
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: CircleAvatar(
                          backgroundImage:
                              NetworkImage(widget.snap['profilePhotoUrl']),
                        ),
                      ),
                      Text(
                        widget.snap['username'],
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w800),
                      )
                    ],
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
                                'Delete',
                                'Edit',
                              ]
                                  .map(
                                    (e) => InkWell(
                                      onTap: () {},
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 12, horizontal: 16),
                                        child: Text(e),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.more_vert,
                        color: Colors.white,
                      ))
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.black26,
                width: double.infinity,
                child: GestureDetector(
                  onDoubleTap: () async {
                    // await FireStoreMethods().likePost(
                    //     widget.snap['postId'], user.userId, widget.snap['likes']);
                    // setState(() {
                    //   isLikeAnimating = true;
                    // });
                  },
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
              padding: EdgeInsets.symmetric(horizontal: 0),
              // color: Colors.purple,
              child: Row(
                children: [
                  Container(
                    width: 40,
                    // color: Colors.blue,
                    child: IconButton(
                      onPressed: () async {
                        await FireStoreMethods().likePost(widget.snap['postId'],
                            user.userId, widget.snap['likes']);
                      },
                      icon: LikeAnimation(
                        isAnimating: widget.snap['likes'].contains(user.userId),
                        smallLike: true,
                        child: Icon(
                          widget.snap['likes'].contains(user.userId)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: widget.snap['likes'].contains(user.userId)
                              ? Colors.red
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Container(
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
                      icon: Icon(
                        Icons.comment_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    width: 40,
                    // color: Colors.red,
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.symmetric(horizontal: 3),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(
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
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.snap['likes'].length > 0
                      ? Text(
                          '${widget.snap['likes'].length} likes',
                          style: TextStyle(color: Colors.white),
                        )
                      : Container(),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: '${widget.snap['username']} \n',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 17)),
                        TextSpan(
                          text: '${DateFormat.yMMMd().format(
                            DateTime.parse(
                              widget.snap['datePublished'],
                            ),
                          )} \n',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                        TextSpan(
                            text: '${widget.snap['description']}',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400)),
                      ],
                    ),
                  ),
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
                        ? Text('View all ${noOfComments} comments...',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400))
                        : Container(),
                  ),
                  SizedBox(
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
