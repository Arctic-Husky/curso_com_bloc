import 'package:faker/faker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:curso_com_bloc/data/http/http_error.dart';
import 'package:curso_com_bloc/domain/helpers/helpers.dart';
import 'package:curso_com_bloc/domain/usecases/usecases.dart';
import 'package:curso_com_bloc/data/http/http_client.dart';
import 'package:curso_com_bloc/data/usecases/remote_authentication.dart';

import 'remote_authentication_test.mocks.dart';

@GenerateNiceMocks([MockSpec<HttpClient>()])
void main() {
  late RemoteAuthentication sut;
  late MockHttpClient httpClient;

  /// sut = System Unit Test
  late String url;

  late AuthenticationParams params;

  setUp(
    () {
      httpClient = MockHttpClient();
      url = faker.internet.httpUrl();
      sut = RemoteAuthentication(httpClient: httpClient, url: url);
      params = AuthenticationParams(
        email: faker.internet.email(),
        secret: faker.internet.password(),
      );
    },
  );

  // Pattern de testes '3A'. Arrange, Act, Assert
  test(
    'Should call HttpClient with correct values',
    () async {
      await sut.auth(params);

      verify(
        httpClient.request(
          url: url,
          method: 'post',
          body: {'email': params.email, 'password': params.secret},
        ),
      );
    },
  );

  test(
    'Should throw UnexpectedError if HttpClient returns 400',
    () async {
      when(
        httpClient.request(
          url: anyNamed('url'),
          method: anyNamed('method'),
          body: anyNamed('body'),
        ),
      ).thenThrow(HttpError.badRequest);

      final future = sut.auth(params);

      expect(
        future,
        throwsA(DomainError.unexpected),
      );
    },
  );

  test(
    'Should throw UnexpectedError if HttpClient returns 404',
    () async {
      when(
        httpClient.request(
          url: anyNamed('url'),
          method: anyNamed('method'),
          body: anyNamed('body'),
        ),
      ).thenThrow(HttpError.notFound);

      final future = sut.auth(params);

      expect(
        future,
        throwsA(DomainError.unexpected),
      );
    },
  );

  test(
    'Should throw UnexpectedError if HttpClient returns 500',
    () async {
      when(
        httpClient.request(
          url: anyNamed('url'),
          method: anyNamed('method'),
          body: anyNamed('body'),
        ),
      ).thenThrow(HttpError.serverError);

      final future = sut.auth(params);

      expect(
        future,
        throwsA(DomainError.unexpected),
      );
    },
  );
}
