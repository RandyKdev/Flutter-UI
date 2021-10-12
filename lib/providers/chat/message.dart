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
}
