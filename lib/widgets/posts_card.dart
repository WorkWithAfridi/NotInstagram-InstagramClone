import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:not_instagram/model/user.dart';
import 'package:not_instagram/providers/user_provider.dart';
import 'package:not_instagram/resources/firestore_method.dart';
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

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).user;
    return Container(
      // color: Colors.black38,
      height: 350,
      width: double.infinity,
      child: Card(
        elevation: 0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
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
                      Text(widget.snap['username'])
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
                      icon: Icon(Icons.more_vert))
                ],
              ),
            ),
            Expanded(
              child: GestureDetector(
                onDoubleTap: () async {
                  await FireStoreMethods().likePost(
                      widget.snap['postId'], user.userId, widget.snap['likes']);
                  setState(() {
                    isLikeAnimating = true;
                  });
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      // height: 200,
                      width: double.infinity,
                      child: Image.network(
                        widget.snap['postPhotoUrl'],
                        fit: BoxFit.fitWidth,
                        alignment: FractionalOffset.center,
                      ),
                    ),
                    AnimatedOpacity(
                      duration: Duration(milliseconds: 200),
                      opacity: isLikeAnimating ? 1 : 0,
                      child: LikeAnimation(
                        child: Icon(
                          Icons.favorite,
                          color: Colors.white,
                          size: 120,
                        ),
                        isAnimating: isLikeAnimating,
                        duration: Duration(milliseconds: 400),
                        onEnd: () {
                          setState(() {
                            isLikeAnimating = false;
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              height: 25,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () async {
                      await FireStoreMethods().likePost(widget.snap['postId'],
                          user.userId, widget.snap['likes']);
                    },
                    icon: LikeAnimation(
                      isAnimating: widget.snap['likes'].contains(user.userId),
                      smallLike: true,
                      child: Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.comment_outlined,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.send,
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
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${widget.snap['likes'].length} likes'),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: widget.snap['username'],
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600)),
                        TextSpan(
                            text: ' ${widget.snap['description']}',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400)),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Text('View all 12 comments...'),
                  ),
                  Text(
                    DateFormat.yMMMd().format(
                      DateTime.parse(widget.snap['datePublished']),
                    ),
                  ),
                  SizedBox(
                    height: 5,
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
