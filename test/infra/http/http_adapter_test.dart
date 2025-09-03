import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:curso_com_bloc/data/http/http.dart';
import 'package:curso_com_bloc/infra/http/http.dart';

// group('post', () {
//   test('', () {});
// });

import 'http_adapter_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Client>()])
void main() {
  late MockClient client;
  late HttpAdapter sut;
  late Uri url;

  setUp(() {
    // Etapa Arrange
    client = MockClient();
    sut = HttpAdapter(client);
    url = Uri.parse(faker.internet.httpUrl());
  });

  group('post', () {
    PostExpectation mockRequest() => when(
      client.post(
        any,
        body: anyNamed('body'),
        headers: anyNamed('headers'),
      ),
    );

    void mockResponse(
      int statusCode, {
      String body = '{"any_key": "any_value"}',
    }) {
      mockRequest().thenAnswer(
        (_) async => Response(body, statusCode),
      );
    }

    setUp(() {
      mockResponse(200);
    });

    test(
      'Should call post with correct values',
      () async {
        // Etapa Act
        await sut.request(
          url: url.toString(),
          method: 'post',
          body: {"any_key": "any_value"},
        );

        // Etapa Assert
        verify(
          client.post(
            url,
            headers: {
              'content-type': 'application/json',
              'accept': 'application/json',
            },
            body: jsonEncode(
              {"any_key": "any_value"},
            ),
          ),
        );
      },
    );

    test(
      'Should call post without body',
      () async {
        // Etapa Act
        await sut.request(
          url: url.toString(),
          method: 'post',
        );

        // Etapa Assert
        verify(
          client.post(
            any,
            headers: anyNamed('headers'),
          ),
        );
      },
    );

    test(
      'Should return data if post returns 200',
      () async {
        // Etapa Act
        final response = await sut.request(
          url: url.toString(),
          method: 'post',
        );

        // Etapa Assert
        expect(response, {"any_key": "any_value"});
      },
    );

    test(
      'Should return null if post returns 200 with no data',
      () async {
        mockResponse(200, body: '');

        // Etapa Act
        final response = await sut.request(
          url: url.toString(),
          method: 'post',
        );

        // Etapa Assert
        expect(response, null);
      },
    );

    test(
      'Should return null if post returns 204',
      () async {
        mockResponse(204, body: '');

        // Etapa Act
        final response = await sut.request(
          url: url.toString(),
          method: 'post',
        );

        // Etapa Assert
        expect(response, null);
      },
    );

    test(
      'Should return null if post returns 204 with data',
      () async {
        mockResponse(204);

        // Etapa Act
        final response = await sut.request(
          url: url.toString(),
          method: 'post',
        );

        // Etapa Assert
        expect(response, null);
      },
    );

    test(
      'Should return BadRequestError if post returns 400',
      () async {
        mockResponse(400, body: '');

        // Etapa Act
        final future = sut.request(
          url: url.toString(),
          method: 'post',
        );

        // Etapa Assert
        expect(future, throwsA(HttpError.badRequest));
      },
    );

    test(
      'Should return BadRequestError if post returns 400',
      () async {
        mockResponse(400);

        // Etapa Act
        final future = sut.request(
          url: url.toString(),
          method: 'post',
        );

        // Etapa Assert
        expect(future, throwsA(HttpError.badRequest));
      },
    );

    test(
      'Should return ServerError if post returns 500',
      () async {
        mockResponse(500);

        // Etapa Act
        final future = sut.request(
          url: url.toString(),
          method: 'post',
        );

        // Etapa Assert
        expect(future, throwsA(HttpError.serverError));
      },
    );
  });
}
