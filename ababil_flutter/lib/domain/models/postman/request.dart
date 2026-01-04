import 'variable.dart';
import 'url.dart';

class PostmanRequest {
  final String? method;
  final List<PostmanHeader>? header;
  final PostmanBody? body;
  final PostmanUrl? url;
  final String? description;
  final PostmanAuth? auth;

  PostmanRequest({
    this.method,
    this.header,
    this.body,
    this.url,
    this.description,
    this.auth,
  });

  factory PostmanRequest.fromJson(Map<String, dynamic> json) {
    return PostmanRequest(
      method: json['method'] as String?,
      header: json['header'] != null
          ? (json['header'] as List)
                .map((e) => PostmanHeader.fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
      body: json['body'] != null
          ? PostmanBody.fromJson(json['body'] as Map<String, dynamic>)
          : null,
      url: json['url'] != null
          ? PostmanUrl.fromJson(json['url'] as Map<String, dynamic>)
          : null,
      description: json['description'] as String?,
      auth: json['auth'] != null
          ? PostmanAuth.fromJson(json['auth'] as Map<String, dynamic>)
          : null,
    );
  }

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
}

class PostmanHeader {
  final String key;
  final String value;
  final bool? disabled;
  final String? description;

  PostmanHeader({
    required this.key,
    required this.value,
    this.disabled,
    this.description,
  });

  factory PostmanHeader.fromJson(Map<String, dynamic> json) {
    return PostmanHeader(
      key: json['key'] as String,
      value: json['value'] as String,
      disabled: json['disabled'] as bool?,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'value': value,
      if (disabled != null) 'disabled': disabled,
      if (description != null) 'description': description,
    };
  }
}

class PostmanBody {
  final String? mode;
  final String? raw;
  final List<PostmanFormData>? urlencoded;
  final List<PostmanFormData>? formdata;
  final PostmanFileBody? file;
  final PostmanGraphQLBody? graphql;

  PostmanBody({
    this.mode,
    this.raw,
    this.urlencoded,
    this.formdata,
    this.file,
    this.graphql,
  });

  factory PostmanBody.fromJson(Map<String, dynamic> json) {
    return PostmanBody(
      mode: json['mode'] as String?,
      raw: json['raw'] as String?,
      urlencoded: json['urlencoded'] != null
          ? (json['urlencoded'] as List)
                .map((e) => PostmanFormData.fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
      formdata: json['formdata'] != null
          ? (json['formdata'] as List)
                .map((e) => PostmanFormData.fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
      file: json['file'] != null
          ? PostmanFileBody.fromJson(json['file'] as Map<String, dynamic>)
          : null,
      graphql: json['graphql'] != null
          ? PostmanGraphQLBody.fromJson(json['graphql'] as Map<String, dynamic>)
          : null,
    );
  }

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

class PostmanFormData {
  final String key;
  final String? value;
  final String? type;
  final bool? disabled;
  final String? description;

  PostmanFormData({
    required this.key,
    this.value,
    this.type,
    this.disabled,
    this.description,
  });

  factory PostmanFormData.fromJson(Map<String, dynamic> json) {
    return PostmanFormData(
      key: json['key'] as String,
      value: json['value'] as String?,
      type: json['type'] as String?,
      disabled: json['disabled'] as bool?,
      description: json['description'] as String?,
    );
  }

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

class PostmanFileBody {
  final String? src;

  PostmanFileBody({this.src});

  factory PostmanFileBody.fromJson(Map<String, dynamic> json) {
    return PostmanFileBody(src: json['src'] as String?);
  }

  Map<String, dynamic> toJson() {
    return {if (src != null) 'src': src};
  }
}

class PostmanGraphQLBody {
  final String? query;
  final String? variables;

  PostmanGraphQLBody({this.query, this.variables});

  factory PostmanGraphQLBody.fromJson(Map<String, dynamic> json) {
    return PostmanGraphQLBody(
      query: json['query'] as String?,
      variables: json['variables'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (query != null) 'query': query,
      if (variables != null) 'variables': variables,
    };
  }
}

class PostmanAuth {
  final String? type;
  final List<PostmanVariable>? bearer;
  final List<PostmanVariable>? basic;
  final List<PostmanVariable>? digest;
  final List<PostmanVariable>? awsv4;
  final List<PostmanVariable>? hawk;
  final Map<String, dynamic>? noauth;
  final List<PostmanVariable>? oauth1;
  final List<PostmanVariable>? oauth2;
  final List<PostmanVariable>? ntlm;

  PostmanAuth({
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

  factory PostmanAuth.fromJson(Map<String, dynamic> json) {
    return PostmanAuth(
      type: json['type'] as String?,
      bearer: json['bearer'] != null
          ? (json['bearer'] as List)
                .map((e) => PostmanVariable.fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
      basic: json['basic'] != null
          ? (json['basic'] as List)
                .map((e) => PostmanVariable.fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
      digest: json['digest'] != null
          ? (json['digest'] as List)
                .map((e) => PostmanVariable.fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
      awsv4: json['awsv4'] != null
          ? (json['awsv4'] as List)
                .map((e) => PostmanVariable.fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
      hawk: json['hawk'] != null
          ? (json['hawk'] as List)
                .map((e) => PostmanVariable.fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
      noauth: json['noauth'] as Map<String, dynamic>?,
      oauth1: json['oauth1'] != null
          ? (json['oauth1'] as List)
                .map((e) => PostmanVariable.fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
      oauth2: json['oauth2'] != null
          ? (json['oauth2'] as List)
                .map((e) => PostmanVariable.fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
      ntlm: json['ntlm'] != null
          ? (json['ntlm'] as List)
                .map((e) => PostmanVariable.fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
    );
  }

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
