class LogEntry {
  final String id;
  final String type;
  final String username;
  final String? description;
  final DateTime createdAt;

  LogEntry(
      {required this.id,
      required this.type,
      required this.username,
      required this.description,
      required this.createdAt});

  factory LogEntry.fromMap(Map<String, dynamic> map) => LogEntry(
        id: map['id'],
        type: map['type'],
        username: map['actor']['login'],
        description: map['payload']['description'],
        createdAt: DateTime.parse(map['created_at']),
      );
}
