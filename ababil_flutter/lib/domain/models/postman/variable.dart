class PostmanVariable {
  final String key;
  final String value;
  final String? type;
  final bool? disabled;

  PostmanVariable({
    required this.key,
    required this.value,
    this.type,
    this.disabled,
  });

  factory PostmanVariable.fromJson(Map<String, dynamic> json) {
    return PostmanVariable(
      key: json['key'] as String,
      value: json['value'] as String,
      type: json['type'] as String?,
      disabled: json['disabled'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'value': value,
      if (type != null) 'type': type,
      if (disabled != null) 'disabled': disabled,
    };
  }
}
