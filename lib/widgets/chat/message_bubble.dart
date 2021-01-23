import 'dart:convert';

import 'package:chatapp/helpers/cache_userData_InMemory.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final String userId;
  final bool isMe;
  final Key key;
  const MessageBubble({this.message, this.isMe, this.key, this.userId});

  @override
  Widget build(BuildContext context) {
    print('bb');
    Widget usernameWidget(String username) {
      return Text(username,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isMe
                ? Colors.black
                : Theme.of(context).accentTextTheme.headline1.color,
          ));
    }

    final userData = Provider.of<CasheduserData>(context, listen: false)
        .findUsernameByUid(userId);
    Widget userImage() {
      return FutureBuilder(
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print('wait');
            return CircularProgressIndicator();
          }
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              print(snapshot.data);
              print('hasData');

              return Container(
                child: CircleAvatar(
                  backgroundImage: NetworkImage(snapshot.data.imageurl),
                ),
              );
            }
          }
          print('other');

          return Container();
        },
        future: userData,
      );
    }

    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Row(
          children: [
            if (!isMe) userImage(),
            Container(
              decoration: BoxDecoration(
                color: isMe ? Colors.grey[300] : Theme.of(context).accentColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomLeft: isMe ? Radius.circular(0) : Radius.circular(12),
                  bottomRight: isMe ? Radius.circular(0) : Radius.circular(12),
                ),
              ),
              width: 140,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  FutureBuilder(
                    builder: (ctx, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        print('wait');
                        return usernameWidget('Loading..');
                      }
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData) {
                          print(snapshot.data);
                          print('hasData');

                          return usernameWidget(snapshot.data.username);
                        }
                      }
                      print('other');

                      return Container();
                    },
                    future: userData,
                  ),
                  Text(
                    message,
                    style: TextStyle(
                      color: isMe
                          ? Colors.black
                          : Theme.of(context).accentTextTheme.headline1.color,
                    ),
                    textAlign: isMe ? TextAlign.end : TextAlign.start,
                  ),
                ],
              ),
            ),
            if (isMe) userImage()
          ],
          //   clipBehavior: Clip.antiAlias,
          //   overflow: Overflow.visible,
        )
      ],
    );
  }
}
