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
        child: Column(
          children: [
            PostCard(),
          ],
        ),
      ),
    );
  }
}
