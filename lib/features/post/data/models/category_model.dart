// CategoryEntity

import 'package:clapmi/features/post/domain/entities/category_entity.dart';

class CategoryModel extends CategoryEntity {
  CategoryModel({
    super.uuid,
    super.name,
  });

  CategoryModel copyWith({
    String? uuid,
    String? name,
  }) {
    return CategoryModel(
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
    );
  }

  factory CategoryModel.fromjson(Map json) {
    return CategoryModel(
      uuid: json['uuid'],
      name: json['name'],
    );
  }

  factory CategoryModel.dummy() {
    return CategoryModel(
      uuid: "da446335-29ff-4840-ae5a-94788aba332a",
      name: "ClapMI",
    );
  }

  Map toOnlineMap() {
    return {
      'uuid': uuid,
      'name': name,
    };
  }

  @override
  String toString() {
    return "${super.toString()}>>> ${toOnlineMap()}";
  }
}
