import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommentCard extends StatefulWidget {
  final snap;
  const CommentCard({Key? key, required this.snap}) : super(key: key);

  @override
  _CommentCardState createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black26,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 18, horizontal: 10),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(
                widget.snap['profilePic'],
              ),
              radius: 18,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text: '${widget.snap['name']}\n',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                          TextSpan(
                              text: '${widget.snap['text']}',
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(
                        '${DateFormat.yMMMd().format(
                          widget.snap['datePublished'].toDate(),
                        )}',
                        style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
                      ),
                    )
                  ],
                ),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.favorite, color: Colors.white,),
            ),
          ],
        ),
      ),
    );
  }
}
