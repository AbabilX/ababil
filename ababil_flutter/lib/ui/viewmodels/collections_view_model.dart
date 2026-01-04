import 'package:flutter/material.dart';
import 'package:ababil_flutter/domain/models/postman/collection.dart';
import 'package:ababil_flutter/domain/models/postman/environment.dart';
import 'package:ababil_flutter/domain/models/postman/request.dart';
import 'package:ababil_flutter/data/services/postman_service.dart';

class CollectionsViewModel extends ChangeNotifier {
  final List<PostmanCollection> _collections = [];
  final List<PostmanEnvironment> _environments = [];
  String? _selectedCollectionId;
  String? _selectedRequestId;

  List<PostmanCollection> get collections => _collections;
  List<PostmanEnvironment> get environments => _environments;
  String? get selectedCollectionId => _selectedCollectionId;
  String? get selectedRequestId => _selectedRequestId;

  CollectionsViewModel() {
    _initializeService();
  }

  Future<void> _initializeService() async {
    await PostmanService.initialize();
  }

  Future<bool> importCollection(String jsonString) async {
    try {
      // Ensure service is initialized before parsing
      await PostmanService.initialize();
      final collection = PostmanService.parseCollection(jsonString);
      if (collection != null) {
        _collections.add(collection);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error importing collection: $e');
      return false;
    }
  }

  Future<String?> exportCollection(PostmanCollection collection) async {
    try {
      return PostmanService.collectionToJson(collection);
    } catch (e) {
      debugPrint('Error exporting collection: $e');
      return null;
    }
  }

  Future<bool> importEnvironment(String jsonString) async {
    try {
      // Ensure service is initialized before parsing
      await PostmanService.initialize();
      final environment = PostmanService.parseEnvironment(jsonString);
      if (environment != null) {
        _environments.add(environment);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error importing environment: $e');
      return false;
    }
  }

  Future<String?> exportEnvironment(PostmanEnvironment environment) async {
    try {
      return PostmanService.environmentToJson(environment);
    } catch (e) {
      debugPrint('Error exporting environment: $e');
      return null;
    }
  }

  void removeCollection(PostmanCollection collection) {
    _collections.remove(collection);
    if (_selectedCollectionId == collection.info.name) {
      _selectedCollectionId = null;
    }
    notifyListeners();
  }

  void removeEnvironment(PostmanEnvironment environment) {
    _environments.remove(environment);
    notifyListeners();
  }

  void selectCollection(String? collectionId) {
    _selectedCollectionId = collectionId;
    notifyListeners();
  }

  void selectRequest(String? requestId) {
    _selectedRequestId = requestId;
    notifyListeners();
  }

  PostmanCollection? findCollectionByName(String name) {
    try {
      return _collections.firstWhere((c) => c.info.name == name);
    } catch (e) {
      return null;
    }
  }

  PostmanRequest? findRequestById(String collectionName, String requestName) {
    final collection = findCollectionByName(collectionName);
    if (collection == null) return null;

    return _findRequestInItems(collection.item, requestName);
  }

  PostmanRequest? _findRequestInItems(
    List<PostmanCollectionItem> items,
    String requestName,
  ) {
    for (final item in items) {
      if (item.request != null && item.name == requestName) {
        return item.request;
      }
      if (item.item != null) {
        final found = _findRequestInItems(item.item!, requestName);
        if (found != null) return found;
      }
    }
    return null;
  }
}
