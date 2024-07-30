

import 'package:VetScholar/models/intialize_login_flow/node.dart';

class Ui {
  final String action;
  final String method;
  final List<Node> nodes;

  Ui({
    required this.action,
    required this.method,
    required this.nodes,
  });

  factory Ui.fromJson(Map<String, dynamic> json) {
    return Ui(
      action: json['action'],
      method: json['method'],
      nodes: (json['nodes'] as List).map((i) => Node.fromJson(i)).toList(),
    );
  }

}