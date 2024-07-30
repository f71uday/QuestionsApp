
class Node {
  final String type;
  final String group;
  final List<dynamic> messages;
  final Map<String, dynamic> meta;

  Node({
    required this.type,
    required this.group,

    required this.messages,
    required this.meta,
  });

  factory Node.fromJson(Map<String, dynamic> json) {
    return Node(
      type: json['type'],
      group: json['group'],
      messages: json['messages'],
      meta: json['meta'],
    );
  }

}