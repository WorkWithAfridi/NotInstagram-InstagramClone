import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:not_instagram/widgets/posts_card.dart';

class MyFeedScreen extends StatelessWidget {
  const MyFeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Not Instagram'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.messenger_outline),
          ),
        ],
      ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.green,
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('posts').snapshots(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                return Container(
                  child: PostCard(
                    snap: snapshot.data!.docs[index],
                  ),
                );
              });
            },
          )),
    );
  }
}
