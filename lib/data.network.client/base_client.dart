import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class KoException implements Exception {
  final int httpCode;

  KoException(this.httpCode);

  @override
  String toString() => '[KoException|http-code:$httpCode';
}

abstract class BaseClient {
  @protected
  final Logger log;

  late final http.Client _client;

  BaseClient({required this.log}) {
    _client = http.Client();
  }

  @protected
  Future<http.Response> get(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    String queryParams = '';
    if (queryParameters != null) {
      queryParams += '?';
      queryParameters.forEach((key, value) {
        queryParams += '$key=$value&';
      });
      queryParams = queryParams.substring(0, queryParams.length - 1);
    }
    final uri = Uri.parse('$url$queryParams');
    return _client.get(uri, headers: headers);
  }

  @protected
  void checkKo(http.Response response, String caller, {String? body}) {
    final trace = '''
    $caller:
      url: ${response.request?.url}
      headers: ${response.request?.headers ?? '-'}
      request: ${body ?? '-'}
      code: ${response.statusCode}
      response: ${response.body}
    ''';
    
    log.i(trace);

    if (response.statusCode >= 400) {
      throw KoException(response.statusCode);
    }
  }
}
