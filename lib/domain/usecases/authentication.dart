import 'package:curso_com_bloc/domain/entities/entities.dart';

abstract class Authentication {
  Future<AccountEntity> auth(AuthenticationParams params);
}

class AuthenticationParams {
  final String email;
  final String secret;

  AuthenticationParams({
    required this.email,
    required this.secret,
  });
}
