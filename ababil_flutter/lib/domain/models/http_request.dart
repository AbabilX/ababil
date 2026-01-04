class HttpRequest {
  final String method;
  final String url;
  final Map<String, String> headers;
  final String? body;

  HttpRequest({
    required this.method,
    required this.url,
    this.headers = const {},
    this.body,
  });

  HttpRequest copyWith({
    String? method,
    String? url,
    Map<String, String>? headers,
    String? body,
  }) {
    return HttpRequest(
      method: method ?? this.method,
      url: url ?? this.url,
      headers: headers ?? this.headers,
      body: body ?? this.body,
    );
  }
}
