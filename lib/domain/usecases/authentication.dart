import 'package:curso_com_bloc/domain/entities/entities.dart';
import 'package:json_annotation/json_annotation.dart';

part 'authentication.g.dart';

abstract class Authentication {
  Future<AccountEntity> auth(AuthenticationParams params);
}

@JsonSerializable()
class AuthenticationParams {
  @JsonKey(name: 'email')
  final String email;
  @JsonKey(name: 'password')
  final String secret;

  AuthenticationParams({
    required this.email,
    required this.secret,
  });

  factory AuthenticationParams.fromJson(Map<String, dynamic> json) =>
      _$AuthenticationParamsFromJson(json);

  Map<String, dynamic> toJson() => _$AuthenticationParamsToJson(this);
}
