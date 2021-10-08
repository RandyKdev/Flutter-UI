import 'package:books_app/providers/chat/message.dart';

class Chat {
  final String id;
  final List<String> users;
  final DateTime createdAt;
  final Message lastMessage;

  Chat({
    this.id,
    this.users,
    this.createdAt,
    this.lastMessage,
  });
}
