import 'dart:convert';

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
  });
}

class HttpAdapter {
  final Client client;

  HttpAdapter(this.client);

  Future<void> request({
    required String url,
    required String method,
    Map? body,
  }) async {
    final headers = {
      'content-type': 'application/json',
      'accept': 'application/json',
    };
    await client.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );
  }
}
