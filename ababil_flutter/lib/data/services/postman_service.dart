import 'dart:convert';
import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import '../../domain/models/postman/collection.dart';
import '../../domain/models/postman/environment.dart';
import 'native_library_service.dart';

typedef ParsePostmanCollectionNative = Pointer<Utf8> Function(Pointer<Utf8>);
typedef ParsePostmanCollectionDart = Pointer<Utf8> Function(Pointer<Utf8>);

typedef CollectionToJsonNative = Pointer<Utf8> Function(Pointer<Utf8>);
typedef CollectionToJsonDart = Pointer<Utf8> Function(Pointer<Utf8>);

typedef ParsePostmanEnvironmentNative = Pointer<Utf8> Function(Pointer<Utf8>);
typedef ParsePostmanEnvironmentDart = Pointer<Utf8> Function(Pointer<Utf8>);

typedef EnvironmentToJsonNative = Pointer<Utf8> Function(Pointer<Utf8>);
typedef EnvironmentToJsonDart = Pointer<Utf8> Function(Pointer<Utf8>);

class PostmanService {
  static ParsePostmanCollectionDart? _parseCollection;
  static CollectionToJsonDart? _collectionToJson;
  static ParsePostmanEnvironmentDart? _parseEnvironment;
  static EnvironmentToJsonDart? _environmentToJson;

  static Future<void> initialize() async {
    await NativeLibraryService.initialize();

    if (NativeLibraryService.isInitialized) {
      final dylib = NativeLibraryService.library;
      if (dylib != null) {
        _parseCollection = dylib
            .lookupFunction<
              ParsePostmanCollectionNative,
              ParsePostmanCollectionDart
            >('parse_postman_collection');
        _collectionToJson = dylib
            .lookupFunction<CollectionToJsonNative, CollectionToJsonDart>(
              'collection_to_json',
            );
        _parseEnvironment = dylib
            .lookupFunction<
              ParsePostmanEnvironmentNative,
              ParsePostmanEnvironmentDart
            >('parse_postman_environment');
        _environmentToJson = dylib
            .lookupFunction<EnvironmentToJsonNative, EnvironmentToJsonDart>(
              'environment_to_json',
            );
      }
    }
  }

  static PostmanCollection? parseCollection(String jsonString) {
    if (_parseCollection == null) {
      if (kDebugMode) {
        print('PostmanService: Library not initialized');
      }
      // Fallback to Dart parsing
      try {
        return PostmanCollection.fromJsonString(jsonString);
      } catch (e) {
        if (kDebugMode) {
          print('PostmanService: Error parsing collection: $e');
        }
        return null;
      }
    }

    try {
      final jsonPtr = jsonString.toNativeUtf8();
      final resultPtr = _parseCollection!(jsonPtr);
      final result = resultPtr.toDartString();
      malloc.free(jsonPtr);
      NativeLibraryService.freeString(resultPtr);
      // Note: The Rust function returns the parsed collection as JSON
      // We need to parse it again in Dart
      final json = jsonDecode(result) as Map<String, dynamic>;
      if (json.containsKey('error')) {
        if (kDebugMode) {
          print('PostmanService: Error from Rust: ${json['error']}');
        }
        return null;
      }
      return PostmanCollection.fromJson(json);
    } catch (e) {
      if (kDebugMode) {
        print('PostmanService: Error parsing collection: $e');
      }
      return null;
    }
  }

  static String? collectionToJson(PostmanCollection collection) {
    if (_collectionToJson == null) {
      // Fallback to Dart serialization
      return collection.toJsonString();
    }

    try {
      final jsonString = collection.toJsonString();
      final jsonPtr = jsonString.toNativeUtf8();
      final resultPtr = _collectionToJson!(jsonPtr);
      final result = resultPtr.toDartString();
      malloc.free(jsonPtr);
      NativeLibraryService.freeString(resultPtr);
      return result;
    } catch (e) {
      if (kDebugMode) {
        print('PostmanService: Error converting collection to JSON: $e');
      }
      return null;
    }
  }

  static PostmanEnvironment? parseEnvironment(String jsonString) {
    if (_parseEnvironment == null) {
      // Fallback to Dart parsing
      try {
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        return PostmanEnvironment.fromJson(json);
      } catch (e) {
        if (kDebugMode) {
          print('PostmanService: Error parsing environment: $e');
        }
        return null;
      }
    }

    try {
      final jsonPtr = jsonString.toNativeUtf8();
      final resultPtr = _parseEnvironment!(jsonPtr);
      final result = resultPtr.toDartString();
      malloc.free(jsonPtr);
      NativeLibraryService.freeString(resultPtr);
      final json = jsonDecode(result) as Map<String, dynamic>;
      if (json.containsKey('error')) {
        if (kDebugMode) {
          print('PostmanService: Error from Rust: ${json['error']}');
        }
        return null;
      }
      return PostmanEnvironment.fromJson(json);
    } catch (e) {
      if (kDebugMode) {
        print('PostmanService: Error parsing environment: $e');
      }
      return null;
    }
  }

  static String? environmentToJson(PostmanEnvironment environment) {
    if (_environmentToJson == null) {
      // Fallback to Dart serialization
      return jsonEncode(environment.toJson());
    }

    try {
      final jsonString = jsonEncode(environment.toJson());
      final jsonPtr = jsonString.toNativeUtf8();
      final resultPtr = _environmentToJson!(jsonPtr);
      final result = resultPtr.toDartString();
      malloc.free(jsonPtr);
      NativeLibraryService.freeString(resultPtr);
      return result;
    } catch (e) {
      if (kDebugMode) {
        print('PostmanService: Error converting environment to JSON: $e');
      }
      return null;
    }
  }
}
