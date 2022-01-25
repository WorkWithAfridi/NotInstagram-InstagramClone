import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:not_instagram/model/user.dart';
import 'package:not_instagram/providers/user_provider.dart';
import 'package:not_instagram/resources/firestore_method.dart';
import 'package:not_instagram/utils/global_variables.dart';
import 'package:not_instagram/utils/utils.dart';
import 'package:not_instagram/widgets/comment_card.dart';
import 'package:not_instagram/widgets/text_field_input.dart';
import 'package:provider/provider.dart';

class CommentsScreen extends StatefulWidget {
  final snap;
  const CommentsScreen({Key? key, required this.snap}) : super(key: key);

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  TextEditingController commentTextEditingController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    commentTextEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      appBar: AppBar(
        title: Text('Comments', style: headerTextStyle,),
        centerTitle: false,
        backgroundColor: backgroundColor,
        elevation: 6,
      ),
      backgroundColor: backgroundColor,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('posts')
                            .doc(widget.snap['postId'])
                            .collection('comments').orderBy('datePublished', descending: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Container(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                          return ListView.builder(
                            itemBuilder: (context, index) => CommentCard(
                              snap: (snapshot.data! as dynamic).docs[index],
                            ),
                            itemCount: (snapshot.data! as dynamic).docs.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: kToolbarHeight,
              // color: Colors.black87,
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      user.photoUrl,
                    ),
                    radius: 18,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Container(
                      child: CustomTextField(
                          textEditingController: commentTextEditingController,
                          hintText: 'Comment as ${user.userName}',
                          textInputType: TextInputType.text),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  IconButton(
                      onPressed: () async {
                        String res = await FireStoreMethods().postComment(
                            postId: widget.snap['postId'],
                            text: commentTextEditingController.text,
                            uid: user.userId,
                            name: user.userName,
                            profilePic: user.photoUrl);
                        commentTextEditingController.text='';
                        print(res);
                        showSnackbar(context, res);
                      },
                      icon: Icon(Icons.send, color: Colors.white,)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
