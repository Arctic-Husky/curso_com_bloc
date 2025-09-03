import 'dart:convert';

import 'package:curso_com_bloc/data/http/http_client.dart';
import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

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
    test(
      'Should call post with correct values',
      () async {
        when(
          client.post(
            any,
            body: anyNamed('body'),
            headers: anyNamed('headers'),
          ),
        ).thenAnswer(
          (_) async => Response('{"any_key": "any_value"}', 200),
        );
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
        when(
          client.post(
            any,
            body: anyNamed('body'),
            headers: anyNamed('headers'),
          ),
        ).thenAnswer(
          (_) async => Response('{"any_key": "any_value"}', 200),
        );

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
        when(
          client.post(
            any,
            headers: anyNamed('headers'),
          ),
        ).thenAnswer(
          (_) async => Response('{"any_key": "any_value"}', 200),
        );

        // Etapa Act
        final response = await sut.request(
          url: url.toString(),
          method: 'post',
        );

        // Etapa Assert
        expect(response, {"any_key": "any_value"});
      },
    );
  });
}

class HttpAdapter implements HttpClient {
  final Client client;

  HttpAdapter(this.client);

  @override
  Future<Map> request({
    required String url,
    required String method,
    Map? body,
  }) async {
    final headers = {
      'content-type': 'application/json',
      'accept': 'application/json',
    };
    final jsonBody = body != null ? jsonEncode(body) : null;

    final response = await client.post(
      Uri.parse(url),
      headers: headers,
      body: jsonBody,
    );

    return jsonDecode(response.body);
  }
}
