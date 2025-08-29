// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authentication.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthenticationParams _$AuthenticationParamsFromJson(
  Map<String, dynamic> json,
) => AuthenticationParams(
  email: json['email'] as String,
  secret: json['password'] as String,
);

Map<String, dynamic> _$AuthenticationParamsToJson(
  AuthenticationParams instance,
) => <String, dynamic>{'email': instance.email, 'password': instance.secret};
