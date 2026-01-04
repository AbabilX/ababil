import 'package:flutter/material.dart';
import 'package:ababil_flutter/data/repositories/http_repository.dart';
import 'package:ababil_flutter/domain/models/http_request.dart';
import 'package:ababil_flutter/domain/models/http_response.dart';
import 'package:ababil_flutter/domain/models/postman/request.dart';

class HomeViewModel extends ChangeNotifier {
  final HttpRepository _httpRepository;

  HomeViewModel({HttpRepository? httpRepository})
    : _httpRepository = httpRepository ?? HttpRepository();

  // State
  String _url = 'https://jsonplaceholder.typicode.com/posts';
  String _selectedMethod = 'GET';
  final Map<String, String> _headers = {};
  final Set<String> _disabledHeaders = {}; // Track disabled headers
  final Map<String, String> _params = {};
  String _body = '';
  HttpResponse? _response;
  bool _isLoading = false;
  String? _error;

  // Getters
  String get url => _url;
  String get selectedMethod => _selectedMethod;
  Map<String, String> get headers => _headers;
  Set<String> get disabledHeaders => _disabledHeaders;
  bool isHeaderEnabled(String key) => !_disabledHeaders.contains(key);
  Map<String, String> get params => _params;
  String get body => _body;
  HttpResponse? get response => _response;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Setters
  void setUrl(String value) {
    _url = value;
    notifyListeners();
  }

  void setMethod(String method) {
    _selectedMethod = method;
    notifyListeners();
  }

  void setBody(String value) {
    _body = value;
    notifyListeners();
  }

  void addHeader(String key, String value) {
    _headers[key] = value;
    // New headers are enabled by default
    _disabledHeaders.remove(key);
    notifyListeners();
  }

  void removeHeader(String key) {
    _headers.remove(key);
    _disabledHeaders.remove(key);
    notifyListeners();
  }

  void toggleHeaderEnabled(String key) {
    if (_disabledHeaders.contains(key)) {
      _disabledHeaders.remove(key);
    } else {
      _disabledHeaders.add(key);
    }
    notifyListeners();
  }

  void clearHeaders() {
    _headers.clear();
    notifyListeners();
  }

  void addParam(String key, String value) {
    _params[key] = value;
    notifyListeners();
  }

  void removeParam(String key) {
    _params.remove(key);
    notifyListeners();
  }

  void updateParam(String oldKey, String newKey, String newValue) {
    if (oldKey != newKey) {
      _params.remove(oldKey);
    }
    _params[newKey] = newValue;
    notifyListeners();
  }

  Future<void> sendRequest() async {
    if (_url.isEmpty) {
      _error = 'Please enter a URL';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    _response = null;
    notifyListeners();

    try {
      // Build query parameters list
      final queryParams = _params.entries
          .map((e) => QueryParam(key: e.key, value: e.value))
          .toList();

      // Build headers list (only enabled ones)
      final enabledHeaders = _headers.entries
          .where((e) => !_disabledHeaders.contains(e.key))
          .map((e) => RequestHeader(key: e.key, value: e.value))
          .toList();

      // Build body
      RequestBody? requestBody;
      if (_shouldIncludeBody() && _body.isNotEmpty) {
        requestBody = RequestBody(mode: 'raw', raw: _body);
      }

      // Build URL structure
      final requestUrl = RequestUrl(
        raw: _url,
        query: queryParams.isNotEmpty ? queryParams : null,
      );

      // Create full request structure
      final request = HttpRequest(
        method: _selectedMethod,
        url: requestUrl,
        header: enabledHeaders.isNotEmpty ? enabledHeaders : null,
        body: requestBody,
      );

      _response = await _httpRepository.sendRequest(request);
      _error = null;
    } catch (e) {
      _error = e.toString();
      _response = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool _shouldIncludeBody() {
    return _selectedMethod != 'GET' &&
        _selectedMethod != 'HEAD' &&
        _selectedMethod != 'OPTIONS';
  }

  void clearResponse() {
    _response = null;
    _error = null;
    notifyListeners();
  }

  void loadFromPostmanRequest(PostmanRequest postmanRequest) {
    // Set method
    if (postmanRequest.method != null) {
      _selectedMethod = postmanRequest.method!;
    }

    // Set URL
    if (postmanRequest.url != null) {
      if (postmanRequest.url!.raw != null) {
        _url = postmanRequest.url!.raw!;
      } else if (postmanRequest.url!.host != null &&
          postmanRequest.url!.path != null) {
        // Build URL from components
        final protocol = postmanRequest.url!.protocol ?? 'https';
        final host = postmanRequest.url!.host!.join('.');
        final path = postmanRequest.url!.path!.join('/');
        _url = '$protocol://$host/$path';
      }
    }

    // Set headers
    if (postmanRequest.header != null) {
      _headers.clear();
      _disabledHeaders.clear();
      for (final header in postmanRequest.header!) {
        if (header.disabled != true) {
          _headers[header.key] = header.value;
        } else {
          _disabledHeaders.add(header.key);
          _headers[header.key] = header.value;
        }
      }
    }

    // Set body
    if (postmanRequest.body != null) {
      if (postmanRequest.body!.raw != null) {
        _body = postmanRequest.body!.raw!;
      }
    }

    // Set query params
    if (postmanRequest.url != null && postmanRequest.url!.query != null) {
      _params.clear();
      for (final param in postmanRequest.url!.query!) {
        if (!(param.disabled ?? false) && param.value != null) {
          _params[param.key] = param.value!;
        }
      }
    }

    notifyListeners();
  }
}
