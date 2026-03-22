import 'dart:convert';

class TagModel {
  final String? name;
  final String? color;
  final int? hits;
  final int? categoryID;

  TagModel({
    required this.categoryID,
    required this.color,
    required this.hits,
    required this.name,
  });

  TagModel copyWith({
    String? name,
    String? color,
    int? hits,
    int? categoryID,
  }) {
    return TagModel(
      categoryID: categoryID ?? this.categoryID,
      color: color ?? this.color,
      hits: hits ?? this.hits,
      name: name ?? this.name,
    );
  }

  factory TagModel.fromjson(Map json) {
    return TagModel(
      categoryID: json['category_id'],
      color: json['color'],
      hits: json['hits'],
      name: json['name'],
    );
  }

  factory TagModel.fromOnlineJson(Map json) {
    return TagModel(
      categoryID: json['category_id'],
      color: json['color'],
      hits: json['hits'],
      name: json['name'],
    );
  }

  factory TagModel.dummy() {
    return TagModel(
      categoryID: 3,
      color: "rgba(192, 199, 185, 1)",
      hits: 2,
      name: "#GIFTME",
    );
  }

  Map toMap() {
    return {
      'category_id': categoryID,
      'color': color,
      'hits': hits,
      'name': name,
    };
  }

  @override
  String toString() {
    return "${super.toString()}>>> ${toMap()}";
  }
}

class TagCategoryModel {
  final String? name;
  final String? createdAt;
  final String? updatedAt;
  final int? id;

  final List<Map>? tags;

  TagCategoryModel({
    required this.createdAt,
    required this.updatedAt,
    required this.id,
    required this.tags,
    required this.name,
  });

  TagCategoryModel copyWith({
    final String? name,
    final String? createdAt,
    final String? updatedAt,
    final int? id,
    final List<Map>? tags,
  }) {
    return TagCategoryModel(
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      id: id ?? this.id,
      tags: tags ?? this.tags,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory TagCategoryModel.fromjsonSqlite(Map json) {
    return TagCategoryModel(
      name: json['name'],
      createdAt: json['created_at'],
      id: json['id'],
      tags: jsonDecode(json['tags']),
      updatedAt: json['updated_at'],
    );
  }

  factory TagCategoryModel.fromjsonOnline(Map json) {
    return TagCategoryModel(
      name: json['name'],
      createdAt: json['created_at'],
      id: json['id'],
      tags: [...(json['tags'] ?? [])],
      updatedAt: json['updated_at'],
    );
  }

  factory TagCategoryModel.dummy() {
    return TagCategoryModel(
      createdAt: DateTime.now().toString(),
      updatedAt: DateTime.now().toString(),
      id: DateTime.now().microsecondsSinceEpoch,
      tags: [],
      name: "ClapMI",
    );
  }

  Map toMapOnline() {
    return {
      'name': name,
      'created_at': createdAt,
      'id': id,
      'tags': tags,
      'updated_at': updatedAt,
    };
  }

  Map toMapSqlite() {
    return {
      'name': name,
      'created_at': createdAt,
      'Unique_ID': id,
      'tags': jsonEncode(tags),
      'updated_at': updatedAt,
    };
  }

  @override
  String toString() {
    return "${super.toString()}>>> ${toMapOnline()}";
  }
}
