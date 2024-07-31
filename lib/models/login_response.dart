import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

@JsonSerializable(explicitToJson: true)
class LoginResponse {
  String? sessionToken;
  Session? session;
  dynamic continueWith;

  LoginResponse({this.sessionToken, this.session, this.continueWith});

  factory LoginResponse.fromJson(Map<String, dynamic> json) => _$LoginResponseFromJson(json);
  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Session {
  String? id;
  bool? active;
  DateTime? expiresAt;
  DateTime? authenticatedAt;
  String? authenticatorAssuranceLevel;
  List<AuthenticationMethod>? authenticationMethods;
  DateTime? issuedAt;
  Identity? identity;
  List<Device>? devices;

  Session({
    this.id,
    this.active,
    this.expiresAt,
    this.authenticatedAt,
    this.authenticatorAssuranceLevel,
    this.authenticationMethods,
    this.issuedAt,
    this.identity,
    this.devices,
  });

  factory Session.fromJson(Map<String, dynamic> json) => _$SessionFromJson(json);
  Map<String, dynamic> toJson() => _$SessionToJson(this);
}

@JsonSerializable()
class AuthenticationMethod {
  String? method;
  String? aal;
  DateTime? completedAt;

  AuthenticationMethod({this.method, this.aal, this.completedAt});

  factory AuthenticationMethod.fromJson(Map<String, dynamic> json) => _$AuthenticationMethodFromJson(json);
  Map<String, dynamic> toJson() => _$AuthenticationMethodToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Identity {
  String? id;
  String? schemaId;
  String? schemaUrl;
  String? state;
  DateTime? stateChangedAt;
  Traits? traits;
  List<VerifiableAddress>? verifiableAddresses;
  List<RecoveryAddress>? recoveryAddresses;
  dynamic metadataPublic;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic organizationId;

  Identity({
    this.id,
    this.schemaId,
    this.schemaUrl,
    this.state,
    this.stateChangedAt,
    this.traits,
    this.verifiableAddresses,
    this.recoveryAddresses,
    this.metadataPublic,
    this.createdAt,
    this.updatedAt,
    this.organizationId,
  });

  factory Identity.fromJson(Map<String, dynamic> json) => _$IdentityFromJson(json);
  Map<String, dynamic> toJson() => _$IdentityToJson(this);
}

@JsonSerializable()
class Traits {
  Name? name;
  String? email;

  Traits({this.name, this.email});

  factory Traits.fromJson(Map<String, dynamic> json) => _$TraitsFromJson(json);
  Map<String, dynamic> toJson() => _$TraitsToJson(this);
}

@JsonSerializable()
class Name {
  String? first;
  String? last;

  Name({this.first, this.last});

  factory Name.fromJson(Map<String, dynamic> json) => _$NameFromJson(json);
  Map<String, dynamic> toJson() => _$NameToJson(this);
}

@JsonSerializable()
class VerifiableAddress {
  String? id;
  String? value;
  bool? verified;
  String? via;
  String? status;
  DateTime? verifiedAt;
  DateTime? createdAt;
  DateTime? updatedAt;

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

  factory VerifiableAddress.fromJson(Map<String, dynamic> json) => _$VerifiableAddressFromJson(json);
  Map<String, dynamic> toJson() => _$VerifiableAddressToJson(this);
}

@JsonSerializable()
class RecoveryAddress {
  String? id;
  String? value;
  String? via;
  DateTime? createdAt;
  DateTime? updatedAt;

  RecoveryAddress({this.id, this.value, this.via, this.createdAt, this.updatedAt});

  factory RecoveryAddress.fromJson(Map<String, dynamic> json) => _$RecoveryAddressFromJson(json);
  Map<String, dynamic> toJson() => _$RecoveryAddressToJson(this);
}

@JsonSerializable()
class Device {
  String? id;
  String? ipAddress;
  String? userAgent;
  String? location;

  Device({this.id, this.ipAddress, this.userAgent, this.location});

  factory Device.fromJson(Map<String, dynamic> json) => _$DeviceFromJson(json);
  Map<String, dynamic> toJson() => _$DeviceToJson(this);
}