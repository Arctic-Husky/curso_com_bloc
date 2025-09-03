import 'dart:convert';

import 'package:http/http.dart';

import 'package:curso_com_bloc/data/http/http.dart';

class HttpAdapter implements HttpClient {
  final Client client;

  HttpAdapter(this.client);

  @override
  Future<Map?> request({
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

    return _handleResponse(response);
  }

  Map? _handleResponse(Response response) {
    if (response.statusCode != 200) {
      return null;
    }

    final responseBody = response.body;

    if (responseBody.isEmpty || responseBody.trim() == '') {
      return null;
    }

    return jsonDecode(response.body);
  }
}
