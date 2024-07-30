import 'package:VetScholar/models/intialize_login_flow/UI.dart';

class IntializeLoginFlow {
  final String id;
 // final String organizationId;
  final String type;
  final DateTime expiresAt;
  final DateTime issuedAt;
  final String requestUrl;
  final Ui ui;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool refresh;
  final String requestedAal;
  final String state;

  IntializeLoginFlow({
    required this.id,
    //required this.organizationId,
    required this.type,
    required this.expiresAt,
    required this.issuedAt,
    required this.requestUrl,
    required this.ui,
    required this.createdAt,
    required this.updatedAt,
    required this.refresh,
    required this.requestedAal,
    required this.state,
  });

  factory IntializeLoginFlow.fromJson(Map<String, dynamic> json) {
    return IntializeLoginFlow(
      id: json['id'],
     // organizationId: json['organization_id'],
      type: json['type'],
      expiresAt: DateTime.parse(json['expires_at']),
      issuedAt: DateTime.parse(json['issued_at']),
      requestUrl: json['request_url'],
      ui: Ui.fromJson(json['ui']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      refresh: json['refresh'],
      requestedAal: json['requested_aal'],
      state: json['state'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
     // 'organization_id': organizationId,
      'type': type,
      'expires_at': expiresAt.toIso8601String(),
      'issued_at': issuedAt.toIso8601String(),
      'request_url': requestUrl,
      //'ui': ui.toJson(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'refresh': refresh,
      'requested_aal': requestedAal,
      'state': state,
    };
  }
}
