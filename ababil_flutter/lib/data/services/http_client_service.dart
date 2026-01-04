import 'dart:ffi';
import 'dart:convert';
import 'package:ffi/ffi.dart';
import 'package:ababil_flutter/domain/models/http_response.dart';
import 'package:ababil_flutter/domain/models/http_request.dart';
import 'package:ababil_flutter/data/services/native_library_service.dart';

typedef MakeHttpRequestNative =
    Pointer<Utf8> Function(Pointer<Utf8> requestJson);
typedef MakeHttpRequestDart = Pointer<Utf8> Function(Pointer<Utf8> requestJson);

class HttpClientService {
  static MakeHttpRequestDart? _makeHttpRequest;

  static Future<void> initialize() async {
    await NativeLibraryService.initialize();

    if (NativeLibraryService.isInitialized) {
      final dylib = NativeLibraryService.library;
      if (dylib != null) {
        _makeHttpRequest = dylib
            .lookupFunction<MakeHttpRequestNative, MakeHttpRequestDart>(
              'make_http_request',
            );
      }
    }
  }

  Future<HttpResponse> makeRequest(HttpRequest request) async {
    await initialize();

    if (_makeHttpRequest == null || !NativeLibraryService.isInitialized) {
      return HttpResponse(
        statusCode: 0,
        headers: {},
        body:
            'Error: Native library not loaded. Please build the Rust core first.',
        durationMs: 0,
      );
    }

    try {
      // Convert request to JSON
      final requestJson = jsonEncode(request.toJson());
      final requestPtr = requestJson.toNativeUtf8();

      final responsePtr = _makeHttpRequest!(requestPtr);

      if (responsePtr.address == 0) {
        malloc.free(requestPtr);
        return HttpResponse(
          statusCode: 0,
          headers: {},
          body: 'Error: Null response from native library',
          durationMs: 0,
        );
      }

      final responseJson = responsePtr.toDartString();
      NativeLibraryService.freeString(responsePtr);
      malloc.free(requestPtr);

      return _parseResponse(responseJson);
    } catch (e) {
      return HttpResponse(
        statusCode: 0,
        headers: {},
        body: 'Error: $e',
        durationMs: 0,
      );
    }
  }

  HttpResponse _parseResponse(String json) {
    try {
      final decoded = jsonDecode(json) as Map<String, dynamic>;
      final headers = <String, String>{};

      if (decoded['headers'] != null) {
        final headersList = decoded['headers'] as List;
        for (var header in headersList) {
          if (header is List && header.length == 2) {
            headers[header[0].toString()] = header[1].toString();
          }
        }
      }

      return HttpResponse(
        statusCode: decoded['status_code'] as int? ?? 0,
        headers: headers,
        body: decoded['body'] as String? ?? '',
        durationMs: decoded['duration_ms'] as int? ?? 0,
      );
    } catch (e) {
      return HttpResponse(
        statusCode: 0,
        headers: {},
        body: 'Error parsing response: $e\nRaw response: $json',
        durationMs: 0,
      );
    }
  }
}
