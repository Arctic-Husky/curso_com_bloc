import 'package:curso_com_bloc/data/http/http_client.dart';
import 'package:curso_com_bloc/domain/usecases/authentication.dart';
import 'package:json_annotation/json_annotation.dart';

part 'remote_authentication.g.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({required this.httpClient, required this.url});

  Future<void> auth(AuthenticationParams params) async {
    await httpClient.request(
      url: url,
      method: 'post',
      body: RemoteAuthenticationParams.fromDomain(params).toJson(),
    );
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
