// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse(
      sessionToken: json['sessionToken'] as String?,
      session: json['session'] == null
          ? null
          : Session.fromJson(json['session'] as Map<String, dynamic>),
      continueWith: json['continueWith'],
    );

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'sessionToken': instance.sessionToken,
      'session': instance.session?.toJson(),
      'continueWith': instance.continueWith,
    };

Session _$SessionFromJson(Map<String, dynamic> json) => Session(
      id: json['id'] as String?,
      active: json['active'] as bool?,
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      authenticatedAt: json['authenticatedAt'] == null
          ? null
          : DateTime.parse(json['authenticatedAt'] as String),
      authenticatorAssuranceLevel:
          json['authenticatorAssuranceLevel'] as String?,
      authenticationMethods: (json['authenticationMethods'] as List<dynamic>?)
          ?.map((e) => AuthenticationMethod.fromJson(e as Map<String, dynamic>))
          .toList(),
      issuedAt: json['issuedAt'] == null
          ? null
          : DateTime.parse(json['issuedAt'] as String),
      identity: json['identity'] == null
          ? null
          : Identity.fromJson(json['identity'] as Map<String, dynamic>),
      devices: (json['devices'] as List<dynamic>?)
          ?.map((e) => Device.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SessionToJson(Session instance) => <String, dynamic>{
      'id': instance.id,
      'active': instance.active,
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'authenticatedAt': instance.authenticatedAt?.toIso8601String(),
      'authenticatorAssuranceLevel': instance.authenticatorAssuranceLevel,
      'authenticationMethods':
          instance.authenticationMethods?.map((e) => e.toJson()).toList(),
      'issuedAt': instance.issuedAt?.toIso8601String(),
      'identity': instance.identity?.toJson(),
      'devices': instance.devices?.map((e) => e.toJson()).toList(),
    };

AuthenticationMethod _$AuthenticationMethodFromJson(
        Map<String, dynamic> json) =>
    AuthenticationMethod(
      method: json['method'] as String?,
      aal: json['aal'] as String?,
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
    );

Map<String, dynamic> _$AuthenticationMethodToJson(
        AuthenticationMethod instance) =>
    <String, dynamic>{
      'method': instance.method,
      'aal': instance.aal,
      'completedAt': instance.completedAt?.toIso8601String(),
    };

Identity _$IdentityFromJson(Map<String, dynamic> json) => Identity(
      id: json['id'] as String?,
      schemaId: json['schemaId'] as String?,
      schemaUrl: json['schemaUrl'] as String?,
      state: json['state'] as String?,
      stateChangedAt: json['stateChangedAt'] == null
          ? null
          : DateTime.parse(json['stateChangedAt'] as String),
      traits: json['traits'] == null
          ? null
          : Traits.fromJson(json['traits'] as Map<String, dynamic>),
      verifiableAddresses: (json['verifiableAddresses'] as List<dynamic>?)
          ?.map((e) => VerifiableAddress.fromJson(e as Map<String, dynamic>))
          .toList(),
      recoveryAddresses: (json['recoveryAddresses'] as List<dynamic>?)
          ?.map((e) => RecoveryAddress.fromJson(e as Map<String, dynamic>))
          .toList(),
      metadataPublic: json['metadataPublic'],
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      organizationId: json['organizationId'],
    );

Map<String, dynamic> _$IdentityToJson(Identity instance) => <String, dynamic>{
      'id': instance.id,
      'schemaId': instance.schemaId,
      'schemaUrl': instance.schemaUrl,
      'state': instance.state,
      'stateChangedAt': instance.stateChangedAt?.toIso8601String(),
      'traits': instance.traits?.toJson(),
      'verifiableAddresses':
          instance.verifiableAddresses?.map((e) => e.toJson()).toList(),
      'recoveryAddresses':
          instance.recoveryAddresses?.map((e) => e.toJson()).toList(),
      'metadataPublic': instance.metadataPublic,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'organizationId': instance.organizationId,
    };

Traits _$TraitsFromJson(Map<String, dynamic> json) => Traits(
      name: json['name'] == null
          ? null
          : Name.fromJson(json['name'] as Map<String, dynamic>),
      email: json['email'] as String?,
    );

Map<String, dynamic> _$TraitsToJson(Traits instance) => <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
    };

Name _$NameFromJson(Map<String, dynamic> json) => Name(
      first: json['first'] as String?,
      last: json['last'] as String?,
    );

Map<String, dynamic> _$NameToJson(Name instance) => <String, dynamic>{
      'first': instance.first,
      'last': instance.last,
    };

VerifiableAddress _$VerifiableAddressFromJson(Map<String, dynamic> json) =>
    VerifiableAddress(
      id: json['id'] as String?,
      value: json['value'] as String?,
      verified: json['verified'] as bool?,
      via: json['via'] as String?,
      status: json['status'] as String?,
      verifiedAt: json['verifiedAt'] == null
          ? null
          : DateTime.parse(json['verifiedAt'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$VerifiableAddressToJson(VerifiableAddress instance) =>
    <String, dynamic>{
      'id': instance.id,
      'value': instance.value,
      'verified': instance.verified,
      'via': instance.via,
      'status': instance.status,
      'verifiedAt': instance.verifiedAt?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

RecoveryAddress _$RecoveryAddressFromJson(Map<String, dynamic> json) =>
    RecoveryAddress(
      id: json['id'] as String?,
      value: json['value'] as String?,
      via: json['via'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$RecoveryAddressToJson(RecoveryAddress instance) =>
    <String, dynamic>{
      'id': instance.id,
      'value': instance.value,
      'via': instance.via,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

Device _$DeviceFromJson(Map<String, dynamic> json) => Device(
      id: json['id'] as String?,
      ipAddress: json['ipAddress'] as String?,
      userAgent: json['userAgent'] as String?,
      location: json['location'] as String?,
    );

Map<String, dynamic> _$DeviceToJson(Device instance) => <String, dynamic>{
      'id': instance.id,
      'ipAddress': instance.ipAddress,
      'userAgent': instance.userAgent,
      'location': instance.location,
    };
