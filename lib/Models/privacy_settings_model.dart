class PrivacySettings {
  final String key;
  final String label;
  final String type;
  final String defaultValue;
  final String userValue;
  final String description;

  PrivacySettings({
    required this.key,
    required this.label,
    required this.type,
    required this.defaultValue,
    required this.userValue,
    required this.description,
  });

  factory PrivacySettings.fromJson(Map<String, dynamic> json) {
    return PrivacySettings(
      key: json['key'].toString(),
      label: json['label'].toString(),
      type: json['type'].toString(),
      defaultValue: json['default_value'].toString(),
      userValue: json['user_value'].toString(),
      description: json['description'].toString(),
    );
  }
}
