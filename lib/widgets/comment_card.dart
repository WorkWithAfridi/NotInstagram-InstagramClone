import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:not_instagram/model/user.dart';
import 'package:not_instagram/providers/user_provider.dart';
import 'package:not_instagram/screens/user_profile_screen.dart';
import 'package:not_instagram/screens/visitor_user_profile.dart';
import 'package:not_instagram/utils/global_variables.dart';
import 'package:provider/provider.dart';

class CommentCard extends StatefulWidget {
  final snap;
  const CommentCard({Key? key, required this.snap}) : super(key: key);

  @override
  _CommentCardState createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).user;
    return Card(
      color: backgroundColor,
      elevation: 0,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 18, horizontal: 10),
        child: Row(
          children: [
            GestureDetector(
              onTap: () async {
                String postUserId = widget.snap['uid'];
                var snapshot = (await FirebaseFirestore.instance
                    .collection('users')
                    .where(
                      'uid',
                      isEqualTo: postUserId,
                    )
                    .get());
                print(snapshot.docs[0]['username']);

                if (snapshot.docs[0]['uid'] == user.userId) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => UserProfileScreen(),
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
                    following: [], chatRooms: [],
                  );

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          VisitorProfileScreen(user: tempUser),
                    ),
                  );
                }
              },
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                  widget.snap['profilePic'],
                ),
                radius: 18,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        String postUserId = widget.snap['uid'];
                        var snapshot = (await FirebaseFirestore.instance
                            .collection('users')
                            .where(
                          'uid',
                          isEqualTo: postUserId,
                        )
                            .get());
                        print(snapshot.docs[0]['username']);

                        if (snapshot.docs[0]['uid'] == user.userId) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => UserProfileScreen(),
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
                            following: [], chatRooms: [],
                          );

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  VisitorProfileScreen(user: tempUser),
                            ),
                          );
                        }
                      },
                      child: Text(
                        '${widget.snap['name']}',
                        style: headerTextStyle,
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '${widget.snap['text']}',
                            style: headerTextStyle.copyWith(
                                fontWeight: FontWeight.w400, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(
                          '${DateFormat.yMMMd().format(
                            widget.snap['datePublished'].toDate(),
                          )}',
                          style: subHeaderNotHighlightedTextStyle),
                    )
                  ],
                ),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.favorite,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
