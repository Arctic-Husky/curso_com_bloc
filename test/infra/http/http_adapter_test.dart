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
  group('post', () {
    test(
      'Should call post with correct values',
      () async {
        // Etapa Arrange
        final client = MockClient();
        final sut = HttpAdapter(client);
        final url = faker.internet.httpUrl();

        // Etapa Act
        await sut.request(url: url, method: 'post');

        // Etapa Assert
        verify(
          client.post(
            Uri.parse(url),
            headers: {
              'content-type': 'application/json',
              'accept': 'application/json',
            },
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
    await client.post(Uri.parse(url), headers: headers);
  }
}
