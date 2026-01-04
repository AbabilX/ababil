import 'package:ababil_flutter/data/services/http_client_service.dart';
import 'package:ababil_flutter/domain/models/http_request.dart';
import 'package:ababil_flutter/domain/models/http_response.dart';

class HttpRepository {
  final HttpClientService _httpClientService;

  HttpRepository({HttpClientService? httpClientService})
    : _httpClientService = httpClientService ?? HttpClientService();

  Future<HttpResponse> sendRequest(HttpRequest request) async {
    return await _httpClientService.makeRequest(request);
  }

  Future<HttpResponse> sendRequestWithParams({
    required String method,
    required String url,
    Map<String, String> headers = const {},
    String? body,
  }) async {
    final request = HttpRequest.simple(
      method: method,
      url: url,
      headers: headers,
      body: body,
    );
    return await sendRequest(request);
  }
}
