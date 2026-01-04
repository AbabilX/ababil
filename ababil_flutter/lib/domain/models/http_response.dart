class HttpResponse {
  final int statusCode;
  final Map<String, String> headers;
  final String body;
  final int durationMs;

  HttpResponse({
    required this.statusCode,
    required this.headers,
    required this.body,
    required this.durationMs,
  });

  bool get isSuccess => statusCode >= 200 && statusCode < 300;
  bool get isError => statusCode >= 400;
}
