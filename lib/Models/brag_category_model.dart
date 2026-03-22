class BragCategoryModel {
  final int? wierdID;
  final String? name;
  final String? createdAt;
  final String? updatedAt;

  BragCategoryModel({
    required this.wierdID,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });
  BragCategoryModel copyWith({
    int? wierdID,
    String? name,
    String? createdAt,
    String? updatedAt,
  }) {
    return BragCategoryModel(
      wierdID: wierdID ?? this.wierdID,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory BragCategoryModel.fromjson(Map json) {
    return BragCategoryModel(
      wierdID: json['wierdID'],
      name: json['name'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  factory BragCategoryModel.fromOnlinejson(Map json) {
    return BragCategoryModel(
      wierdID: json['id'],
      name: json['name'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  factory BragCategoryModel.dummy() {
    return BragCategoryModel(
      wierdID: 12,
      name: " Testing 123",
      createdAt: DateTime.now().toString(),
      updatedAt: DateTime.now().toString(),
    );
  }

  Map toMapforInternet() {
    return {
      'id': wierdID,
      'name': name,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  Map toMapforsqlite() {
    return {
      'wierdID': wierdID,
      'name': name,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  @override
  String toString() {
    return "${super.toString()}>>> ${toMapforInternet()}";
  }
}
