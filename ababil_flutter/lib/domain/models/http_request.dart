// Request structure matching the Rust Request model
class HttpRequest {
  final String? method;
  final List<RequestHeader>? header;
  final RequestBody? body;
  final RequestUrl? url;
  final String? description;
  final RequestAuth? auth;

  HttpRequest({
    this.method,
    this.header,
    this.body,
    this.url,
    this.description,
    this.auth,
  });

  // Helper constructor for simple requests (backward compatibility)
  HttpRequest.simple({
    required String method,
    required String url,
    Map<String, String> headers = const {},
    String? body,
  }) : this(
         method: method,
         url: RequestUrl(raw: url),
         header: headers.entries
             .map((e) => RequestHeader(key: e.key, value: e.value))
             .toList(),
         body: body != null ? RequestBody(mode: 'raw', raw: body) : null,
       );

  Map<String, dynamic> toJson() {
    return {
      if (method != null) 'method': method,
      if (header != null) 'header': header!.map((e) => e.toJson()).toList(),
      if (body != null) 'body': body!.toJson(),
      if (url != null) 'url': url!.toJson(),
      if (description != null) 'description': description,
      if (auth != null) 'auth': auth!.toJson(),
    };
  }

  HttpRequest copyWith({
    String? method,
    List<RequestHeader>? header,
    RequestBody? body,
    RequestUrl? url,
    String? description,
    RequestAuth? auth,
  }) {
    return HttpRequest(
      method: method ?? this.method,
      header: header ?? this.header,
      body: body ?? this.body,
      url: url ?? this.url,
      description: description ?? this.description,
      auth: auth ?? this.auth,
    );
  }
}

class RequestHeader {
  final String key;
  final String value;
  final bool? disabled;
  final String? description;

  RequestHeader({
    required this.key,
    required this.value,
    this.disabled,
    this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'value': value,
      if (disabled != null) 'disabled': disabled,
      if (description != null) 'description': description,
    };
  }
}

class RequestUrl {
  final String? raw;
  final String? protocol;
  final List<String>? host;
  final List<String>? path;
  final List<QueryParam>? query;
  final List<RequestVariable>? variable;

  RequestUrl({
    this.raw,
    this.protocol,
    this.host,
    this.path,
    this.query,
    this.variable,
  });

  Map<String, dynamic> toJson() {
    return {
      if (raw != null) 'raw': raw,
      if (protocol != null) 'protocol': protocol,
      if (host != null) 'host': host,
      if (path != null) 'path': path,
      if (query != null) 'query': query!.map((e) => e.toJson()).toList(),
      if (variable != null)
        'variable': variable!.map((e) => e.toJson()).toList(),
    };
  }
}

class QueryParam {
  final String key;
  final String? value;
  final bool? disabled;
  final String? description;

  QueryParam({required this.key, this.value, this.disabled, this.description});

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      if (value != null) 'value': value,
      if (disabled != null) 'disabled': disabled,
      if (description != null) 'description': description,
    };
  }
}

class RequestVariable {
  final String key;
  final String value;
  final String? type;
  final bool? disabled;

  RequestVariable({
    required this.key,
    required this.value,
    this.type,
    this.disabled,
  });

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'value': value,
      if (type != null) 'type': type,
      if (disabled != null) 'disabled': disabled,
    };
  }
}

class RequestBody {
  final String? mode;
  final String? raw;
  final List<FormData>? urlencoded;
  final List<FormData>? formdata;
  final FileBody? file;
  final GraphQLBody? graphql;

  RequestBody({
    this.mode,
    this.raw,
    this.urlencoded,
    this.formdata,
    this.file,
    this.graphql,
  });

  Map<String, dynamic> toJson() {
    return {
      if (mode != null) 'mode': mode,
      if (raw != null) 'raw': raw,
      if (urlencoded != null)
        'urlencoded': urlencoded!.map((e) => e.toJson()).toList(),
      if (formdata != null)
        'formdata': formdata!.map((e) => e.toJson()).toList(),
      if (file != null) 'file': file!.toJson(),
      if (graphql != null) 'graphql': graphql!.toJson(),
    };
  }
}

class FormData {
  final String key;
  final String? value;
  final String? type;
  final bool? disabled;
  final String? description;

  FormData({
    required this.key,
    this.value,
    this.type,
    this.disabled,
    this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      if (value != null) 'value': value,
      if (type != null) 'type': type,
      if (disabled != null) 'disabled': disabled,
      if (description != null) 'description': description,
    };
  }
}

class FileBody {
  final String? src;

  FileBody({this.src});

  Map<String, dynamic> toJson() {
    return {if (src != null) 'src': src};
  }
}

class GraphQLBody {
  final String? query;
  final String? variables;

  GraphQLBody({this.query, this.variables});

  Map<String, dynamic> toJson() {
    return {
      if (query != null) 'query': query,
      if (variables != null) 'variables': variables,
    };
  }
}

class RequestAuth {
  final String? type;
  final List<RequestVariable>? bearer;
  final List<RequestVariable>? basic;
  final List<RequestVariable>? digest;
  final List<RequestVariable>? awsv4;
  final List<RequestVariable>? hawk;
  final dynamic noauth;
  final List<RequestVariable>? oauth1;
  final List<RequestVariable>? oauth2;
  final List<RequestVariable>? ntlm;

  RequestAuth({
    this.type,
    this.bearer,
    this.basic,
    this.digest,
    this.awsv4,
    this.hawk,
    this.noauth,
    this.oauth1,
    this.oauth2,
    this.ntlm,
  });

  Map<String, dynamic> toJson() {
    return {
      if (type != null) 'type': type,
      if (bearer != null) 'bearer': bearer!.map((e) => e.toJson()).toList(),
      if (basic != null) 'basic': basic!.map((e) => e.toJson()).toList(),
      if (digest != null) 'digest': digest!.map((e) => e.toJson()).toList(),
      if (awsv4 != null) 'awsv4': awsv4!.map((e) => e.toJson()).toList(),
      if (hawk != null) 'hawk': hawk!.map((e) => e.toJson()).toList(),
      if (noauth != null) 'noauth': noauth,
      if (oauth1 != null) 'oauth1': oauth1!.map((e) => e.toJson()).toList(),
      if (oauth2 != null) 'oauth2': oauth2!.map((e) => e.toJson()).toList(),
      if (ntlm != null) 'ntlm': ntlm!.map((e) => e.toJson()).toList(),
    };
  }
}
