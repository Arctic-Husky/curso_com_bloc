import 'package:curso_com_bloc/domain/entities/entities.dart';

abstract class Authentication {
  Future<AccountEntity> auth({required String email, required String password});
}
