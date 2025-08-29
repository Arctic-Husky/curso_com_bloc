import 'package:json_annotation/json_annotation.dart';

import 'package:curso_com_bloc/data/http/http.dart';
import 'package:curso_com_bloc/domain/helpers/helpers.dart';
import 'package:curso_com_bloc/domain/entities/entities.dart';
import 'package:curso_com_bloc/domain/usecases/authentication.dart';

part 'remote_authentication.g.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({required this.httpClient, required this.url});

  Future<AccountEntity> auth(AuthenticationParams params) async {
    try {
      final httpResponse = await httpClient.request(
        url: url,
        method: 'post',
        body: RemoteAuthenticationParams.fromDomain(params).toJson(),
      );

      return AccountEntity.fromJson(httpResponse);
    } on HttpError catch (error) {
      switch (error) {
        case HttpError.unauthorized:
          throw DomainError.invalidCredentials;
        default:
          throw DomainError.unexpected;
      }
    }
  }
}

@JsonSerializable()
class RemoteAuthenticationParams {
  @JsonKey(name: 'email')
  final String email;
  @JsonKey(name: 'password')
  final String password;

  RemoteAuthenticationParams({
    required this.email,
    required this.password,
  });

  factory RemoteAuthenticationParams.fromDomain(AuthenticationParams params) {
    return RemoteAuthenticationParams(
      email: params.email,
      password: params.secret,
    );
  }

  factory RemoteAuthenticationParams.fromJson(Map<String, dynamic> json) =>
      _$RemoteAuthenticationParamsFromJson(json);

  Map<String, dynamic> toJson() => _$RemoteAuthenticationParamsToJson(this);
}
