import 'dart:convert';

// Main model class
class UserSession {
  final String id;
  final bool? active;
  final DateTime? expiresAt;
  final DateTime? authenticatedAt;
  final String? authenticatorAssuranceLevel;
  final List<AuthenticationMethod>? authenticationMethods;
  final DateTime? issuedAt;
  final Identity? identity;


  UserSession({
    required this.id,
    this.active,
    this.expiresAt,
    this.authenticatedAt,
    this.authenticatorAssuranceLevel,
    this.authenticationMethods,
    this.issuedAt,
    this.identity,

  });

  factory UserSession.fromJson(Map<String, dynamic> json) {
    return UserSession(
      id: json['id'] ?? '',
      active: json['active'],
      expiresAt: json['expires_at'] != null ? DateTime.parse(json['expires_at']) : null,
      authenticatedAt: json['authenticated_at'] != null ? DateTime.parse(json['authenticated_at']) : null,
      authenticatorAssuranceLevel: json['authenticator_assurance_level'],
      authenticationMethods: json['authentication_methods'] != null
          ? (json['authentication_methods'] as List)
          .map((item) => AuthenticationMethod.fromJson(item))
          .toList()
          : null,
      issuedAt: json['issued_at'] != null ? DateTime.parse(json['issued_at']) : null,
      identity: json['identity'] != null ? Identity.fromJson(json['identity']) : null,

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'active': active,
      'expires_at': expiresAt?.toIso8601String(),
      'authenticated_at': authenticatedAt?.toIso8601String(),
      'authenticator_assurance_level': authenticatorAssuranceLevel,
      'authentication_methods': authenticationMethods?.map((item) => item.toJson()).toList(),
      'issued_at': issuedAt?.toIso8601String(),
      'identity': identity?.toJson(),

    };
  }
}

// AuthenticationMethod class
class AuthenticationMethod {
  final String? method;
  final String? aal;
  final DateTime? completedAt;

  AuthenticationMethod({
    this.method,
    this.aal,
    this.completedAt,
  });

  factory AuthenticationMethod.fromJson(Map<String, dynamic> json) {
    return AuthenticationMethod(
      method: json['method'],
      aal: json['aal'],
      completedAt: json['completed_at'] != null ? DateTime.parse(json['completed_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'method': method,
      'aal': aal,
      'completed_at': completedAt?.toIso8601String(),
    };
  }
}

// Identity class
class Identity {
  final String? id;
  final String? schemaId;
  final String? schemaUrl;
  final String? state;
  final DateTime? stateChangedAt;
  final Traits? traits;
  final List<VerifiableAddress>? verifiableAddresses;
  final List<RecoveryAddress>? recoveryAddresses;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? organizationId;

  Identity({
    this.id,
    this.schemaId,
    this.schemaUrl,
    this.state,
    this.stateChangedAt,
    this.traits,
    this.verifiableAddresses,
    this.recoveryAddresses,
    this.createdAt,
    this.updatedAt,
    this.organizationId,
  });

  factory Identity.fromJson(Map<String, dynamic> json) {
    return Identity(
      id: json['id'],
      schemaId: json['schema_id'],
      schemaUrl: json['schema_url'],
      state: json['state'],
      stateChangedAt: json['state_changed_at'] != null ? DateTime.parse(json['state_changed_at']) : null,
      traits: json['traits'] != null ? Traits.fromJson(json['traits']) : null,
      verifiableAddresses: json['verifiable_addresses'] != null
          ? (json['verifiable_addresses'] as List)
          .map((item) => VerifiableAddress.fromJson(item))
          .toList()
          : null,
      recoveryAddresses: json['recovery_addresses'] != null
          ? (json['recovery_addresses'] as List)
          .map((item) => RecoveryAddress.fromJson(item))
          .toList()
          : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      organizationId: json['organization_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'schema_id': schemaId,
      'schema_url': schemaUrl,
      'state': state,
      'state_changed_at': stateChangedAt?.toIso8601String(),
      'traits': traits?.toJson(),
      'verifiable_addresses': verifiableAddresses?.map((item) => item.toJson()).toList(),
      'recovery_addresses': recoveryAddresses?.map((item) => item.toJson()).toList(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'organization_id': organizationId,
    };
  }
}

// Traits class
class Traits {
  final Name? name;
  final String? email;

  Traits({
    this.name,
    this.email,
  });

  factory Traits.fromJson(Map<String, dynamic> json) {
    return Traits(
      name: json['name'] != null ? Name.fromJson(json['name']) : null,
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name?.toJson(),
      'email': email,
    };
  }
}

// Name class
class Name {
  final String? last;
  final String? first;

  Name({
    this.last,
    this.first,
  });

  factory Name.fromJson(Map<String, dynamic> json) {
    return Name(
      last: json['last'],
      first: json['first'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'last': last,
      'first': first,
    };
  }
}

// VerifiableAddress class
class VerifiableAddress {
  final String? id;
  final String? value;
  final bool? verified;
  final String? via;
  final String? status;
  final DateTime? verifiedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  VerifiableAddress({
    this.id,
    this.value,
    this.verified,
    this.via,
    this.status,
    this.verifiedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory VerifiableAddress.fromJson(Map<String, dynamic> json) {
    return VerifiableAddress(
      id: json['id'],
      value: json['value'],
      verified: json['verified'],
      via: json['via'],
      status: json['status'],
      verifiedAt: json['verified_at'] != null ? DateTime.parse(json['verified_at']) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'value': value,
      'verified': verified,
      'via': via,
      'status': status,
      'verified_at': verifiedAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

// RecoveryAddress class
class RecoveryAddress {
  final String? id;
  final String? value;
  final String? via;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  RecoveryAddress({
    this.id,
    this.value,
    this.via,
    this.createdAt,
    this.updatedAt,
  });

  factory RecoveryAddress.fromJson(Map<String, dynamic> json) {
    return RecoveryAddress(
      id: json['id'],
      value: json['value'],
      via: json['via'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'value': value,
      'via': via,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

