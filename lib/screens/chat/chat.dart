import 'package:books_app/providers/chat/chat.dart';
import 'package:books_app/screens/chat/chat_item.dart';
import 'package:books_app/widgets/empty_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:books_app/services/database_service.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final DatabaseService _db = DatabaseService();
    return StreamBuilder(
      stream: _db.getAllChats(),
      builder: (BuildContext ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
        // return Column(
        //   children: <Widget>[
        //     ChatItem(Chat(
        //       createdAt: DateTime(2020),
        //       updatedAt: DateTime(2021),
        //       id: 'id',
        //       users: <String>['user1', 'user2'],
        //     )),
        //     const Divider(color: Colors.grey, height: 0),
        //     ChatItem(Chat(
        //       createdAt: DateTime(2020),
        //       updatedAt: DateTime(2021),
        //       id: 'id',
        //       users: <String>['user1', 'user2'],
        //     )),
        //   ],
        // );

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData ||
            snapshot.connectionState == ConnectionState.none) {
          return const EmptyPageWidget(headline: 'No chats available');
        }

        final List<Chat> _chats =
            snapshot.data.docs.map((QueryDocumentSnapshot chat) {
          return Chat(
            id: chat.id,
            createdAt: chat.data()['createdAt'] as DateTime,
            updatedAt: chat.data()['updatedAt'] as DateTime,
            users: chat.data()['users'] as List<String>,
          );
        }).toList();

        return ListView.separated(
          itemBuilder: (BuildContext ctx, int index) {
            return ChatItem(_chats[index]);
          },
          separatorBuilder: (_, __) {
            return const Divider(
              color: Colors.grey,
              height: 0,
            );
          },
          itemCount: snapshot.data.docs.length,
        );
      },
    );
  }
}
