import 'dart:convert';
import 'variable.dart';
import 'request.dart';
import 'url.dart';

class PostmanCollection {
  final PostmanCollectionInfo info;
  final List<PostmanCollectionItem> item;
  final List<PostmanVariable>? variable;
  final List<PostmanEvent>? event;
  final PostmanAuth? auth;

  PostmanCollection({
    required this.info,
    required this.item,
    this.variable,
    this.event,
    this.auth,
  });

  factory PostmanCollection.fromJson(Map<String, dynamic> json) {
    return PostmanCollection(
      info: PostmanCollectionInfo.fromJson(
        json['info'] as Map<String, dynamic>,
      ),
      item: (json['item'] as List)
          .map((e) => PostmanCollectionItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      variable: json['variable'] != null
          ? (json['variable'] as List)
                .map((e) => PostmanVariable.fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
      event: json['event'] != null
          ? (json['event'] as List)
                .map((e) => PostmanEvent.fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
      auth: json['auth'] != null
          ? PostmanAuth.fromJson(json['auth'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'info': info.toJson(),
      'item': item.map((e) => e.toJson()).toList(),
      if (variable != null)
        'variable': variable!.map((e) => e.toJson()).toList(),
      if (event != null) 'event': event!.map((e) => e.toJson()).toList(),
      if (auth != null) 'auth': auth!.toJson(),
    };
  }

  static PostmanCollection fromJsonString(String jsonString) {
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    return PostmanCollection.fromJson(json);
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }
}

class PostmanCollectionInfo {
  final String name;
  final String? description;
  final String? schema;
  final String? postmanId;
  final String? exporterId;

  PostmanCollectionInfo({
    required this.name,
    this.description,
    this.schema,
    this.postmanId,
    this.exporterId,
  });

  factory PostmanCollectionInfo.fromJson(Map<String, dynamic> json) {
    return PostmanCollectionInfo(
      name: json['name'] as String,
      description: json['description'] as String?,
      schema: json['schema'] as String?,
      postmanId: json['_postman_id'] as String?,
      exporterId: json['_exporter_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (description != null) 'description': description,
      if (schema != null) 'schema': schema,
      if (postmanId != null) '_postman_id': postmanId,
      if (exporterId != null) '_exporter_id': exporterId,
    };
  }
}

class PostmanCollectionItem {
  final String name;
  final List<PostmanCollectionItem>? item;
  final PostmanRequest? request;
  final List<PostmanResponse>? response;
  final List<PostmanEvent>? event;
  final String? description;
  final List<PostmanVariable>? variable;

  PostmanCollectionItem({
    required this.name,
    this.item,
    this.request,
    this.response,
    this.event,
    this.description,
    this.variable,
  });

  factory PostmanCollectionItem.fromJson(Map<String, dynamic> json) {
    return PostmanCollectionItem(
      name: json['name'] as String,
      item: json['item'] != null
          ? (json['item'] as List)
                .map(
                  (e) =>
                      PostmanCollectionItem.fromJson(e as Map<String, dynamic>),
                )
                .toList()
          : null,
      request: json['request'] != null
          ? PostmanRequest.fromJson(json['request'] as Map<String, dynamic>)
          : null,
      response: json['response'] != null
          ? (json['response'] as List)
                .map((e) => PostmanResponse.fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
      event: json['event'] != null
          ? (json['event'] as List)
                .map((e) => PostmanEvent.fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
      description: json['description'] as String?,
      variable: json['variable'] != null
          ? (json['variable'] as List)
                .map((e) => PostmanVariable.fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (item != null) 'item': item!.map((e) => e.toJson()).toList(),
      if (request != null) 'request': request!.toJson(),
      if (response != null)
        'response': response!.map((e) => e.toJson()).toList(),
      if (event != null) 'event': event!.map((e) => e.toJson()).toList(),
      if (description != null) 'description': description,
      if (variable != null)
        'variable': variable!.map((e) => e.toJson()).toList(),
    };
  }
}

class PostmanResponse {
  final String? name;
  final PostmanRequest? originalRequest;
  final String? status;
  final int? code;
  final String? postmanPreviewLanguage;
  final List<PostmanHeader>? header;
  final List<PostmanCookie>? cookie;
  final String? body;
  final String? responseTime;
  final Map<String, dynamic>? timings;

  PostmanResponse({
    this.name,
    this.originalRequest,
    this.status,
    this.code,
    this.postmanPreviewLanguage,
    this.header,
    this.cookie,
    this.body,
    this.responseTime,
    this.timings,
  });

  factory PostmanResponse.fromJson(Map<String, dynamic> json) {
    return PostmanResponse(
      name: json['name'] as String?,
      originalRequest: json['originalRequest'] != null
          ? PostmanRequest.fromJson(
              json['originalRequest'] as Map<String, dynamic>,
            )
          : null,
      status: json['status'] as String?,
      code: json['code'] as int?,
      postmanPreviewLanguage: json['_postman_previewlanguage'] as String?,
      header: json['header'] != null
          ? (json['header'] as List)
                .map((e) => PostmanHeader.fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
      cookie: json['cookie'] != null
          ? (json['cookie'] as List)
                .map((e) => PostmanCookie.fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
      body: json['body'] as String?,
      responseTime: json['responseTime'] as String?,
      timings: json['timings'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (name != null) 'name': name,
      if (originalRequest != null) 'originalRequest': originalRequest!.toJson(),
      if (status != null) 'status': status,
      if (code != null) 'code': code,
      if (postmanPreviewLanguage != null)
        '_postman_previewlanguage': postmanPreviewLanguage,
      if (header != null) 'header': header!.map((e) => e.toJson()).toList(),
      if (cookie != null) 'cookie': cookie!.map((e) => e.toJson()).toList(),
      if (body != null) 'body': body,
      if (responseTime != null) 'responseTime': responseTime,
      if (timings != null) 'timings': timings,
    };
  }
}

class PostmanCookie {
  final String? name;
  final String? value;
  final String? domain;
  final String? path;
  final String? expires;
  final bool? httpOnly;
  final bool? secure;

  PostmanCookie({
    this.name,
    this.value,
    this.domain,
    this.path,
    this.expires,
    this.httpOnly,
    this.secure,
  });

  factory PostmanCookie.fromJson(Map<String, dynamic> json) {
    return PostmanCookie(
      name: json['name'] as String?,
      value: json['value'] as String?,
      domain: json['domain'] as String?,
      path: json['path'] as String?,
      expires: json['expires'] as String?,
      httpOnly: json['httpOnly'] as bool?,
      secure: json['secure'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (name != null) 'name': name,
      if (value != null) 'value': value,
      if (domain != null) 'domain': domain,
      if (path != null) 'path': path,
      if (expires != null) 'expires': expires,
      if (httpOnly != null) 'httpOnly': httpOnly,
      if (secure != null) 'secure': secure,
    };
  }
}

class PostmanEvent {
  final String? listen;
  final PostmanScript? script;

  PostmanEvent({this.listen, this.script});

  factory PostmanEvent.fromJson(Map<String, dynamic> json) {
    return PostmanEvent(
      listen: json['listen'] as String?,
      script: json['script'] != null
          ? PostmanScript.fromJson(json['script'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (listen != null) 'listen': listen,
      if (script != null) 'script': script!.toJson(),
    };
  }
}

class PostmanScript {
  final String? type;
  final List<String>? exec;
  final PostmanUrl? src;

  PostmanScript({this.type, this.exec, this.src});

  factory PostmanScript.fromJson(Map<String, dynamic> json) {
    return PostmanScript(
      type: json['type'] as String?,
      exec: json['exec'] != null
          ? List<String>.from(json['exec'] as List)
          : null,
      src: json['src'] != null
          ? PostmanUrl.fromJson(json['src'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (type != null) 'type': type,
      if (exec != null) 'exec': exec,
      if (src != null) 'src': src!.toJson(),
    };
  }
}
