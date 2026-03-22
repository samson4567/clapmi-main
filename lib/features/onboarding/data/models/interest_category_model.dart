import 'dart:convert';

import 'package:clapmi/features/onboarding/domain/entities/interest_category_entity.dart';
import 'package:clapmi/features/onboarding/domain/entities/interest_entity.dart';
import 'package:equatable/equatable.dart';

class InterestCategoryModel extends InterestCategoryEntity with EquatableMixin {
  @override
  final List<InterestEntity> interests;
  @override
  final String category;
  @override
  final String title;

  InterestCategoryModel({
    required this.interests,
    required this.category,
    required this.title,
  }) : super(interests: [], title: title, category: category);

  Map<String, dynamic> toJson() {
    return {
      "interests": interests,
      "category": category,
      "title": title,
    };
  }

  factory InterestCategoryModel.fromJson(Map jsonMap) {
    return InterestCategoryModel(
      interests: [
        ...((jsonMap["interests"] as List?) ?? []).map(
          (e) => InterestEntity(
            interest: e['interest'],
            title: e['title'],
            category: jsonMap["category"],
          ),
        ),
      ],
      category: jsonMap["category"],
      title: jsonMap["title"],
    );
  }

  String serialize() {
    return json.encode(toJson());
  }

  factory InterestCategoryModel.deserialize(String serializedMap) {
    Map deserializedMap = jsonDecode(serializedMap);
    return InterestCategoryModel.fromJson(deserializedMap);
  }

  factory InterestCategoryModel.fromEntity(
      InterestCategoryEntity interestCategoryEntity) {
    return InterestCategoryModel(
      interests: interestCategoryEntity.interests,
      category: interestCategoryEntity.category,
      title: interestCategoryEntity.title,
    );
  }

  @override
  List<Object?> get props => [interests];
}
