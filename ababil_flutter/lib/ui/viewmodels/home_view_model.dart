import 'package:flutter/material.dart';
import 'package:ababil_flutter/data/repositories/http_repository.dart';
import 'package:ababil_flutter/domain/models/http_request.dart';
import 'package:ababil_flutter/domain/models/http_response.dart';

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
      // Build URL with query params
      String finalUrl = _url;
      if (_params.isNotEmpty) {
        final queryString = _params.entries
            .map(
              (e) =>
                  '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
            )
            .join('&');
        finalUrl = '$finalUrl?$queryString';
      }

      // Only include enabled headers in the request
      final enabledHeaders = Map<String, String>.fromEntries(
        _headers.entries.where((e) => !_disabledHeaders.contains(e.key)),
      );

      final request = HttpRequest(
        method: _selectedMethod,
        url: finalUrl,
        headers: enabledHeaders,
        body: _shouldIncludeBody() ? _body : null,
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
}
