import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:not_instagram/model/user.dart';
import 'package:not_instagram/providers/user_provider.dart';
import 'package:not_instagram/utils/global_variables.dart';
import 'package:not_instagram/widgets/posts_card.dart';
import 'package:provider/provider.dart';

class DetailedImageScreen extends StatefulWidget {
  final postId;
  const DetailedImageScreen({Key? key, required this.postId}) : super(key: key);

  @override
  _DetailedImageScreenState createState() => _DetailedImageScreenState();
}

class _DetailedImageScreenState extends State<DetailedImageScreen> {
  var snapshot;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  void getData() async {
    snapshot = await FirebaseFirestore.instance
        .collection('posts')
        .where('postPhotoUrl', isEqualTo: widget.postId)
        .get();

    // print(snapshot.docs[0]['postPhotoUrl']);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    UserModel user = Provider.of<UserProvider>(context, listen: false).user;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Post',
          style: headerTextStyle,
        ),
        backgroundColor: backgroundColor,
        elevation: 0,
      ),
      backgroundColor: backgroundColor,
      body: snapshot == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PostCard(
                      snap: snapshot.docs[0],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
