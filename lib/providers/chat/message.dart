class Message {
  final String message, sender, receiver, id;
  final DateTime createdAt;
  final bool delivered, seen;

  Message({
    this.id,
    this.message,
    this.sender,
    this.receiver,
    this.createdAt,
    this.delivered,
    this.seen,
  });

  bool get getSeenStatus {
    return seen;
  }

  bool get getDeliveredStatus {
    return delivered;
  }

  String get getMessage {
    return message;
  }
}
