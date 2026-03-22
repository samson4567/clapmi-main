import 'dart:convert';

import 'package:clapmi/features/onboarding/domain/entities/interest_entity.dart';
import 'package:equatable/equatable.dart';

class InterestModel extends InterestEntity with EquatableMixin {
  @override
  final String interest;
  @override
  final String category;
  @override
  final String title;

  InterestModel({
    required this.interest,
    required this.category,
    required this.title,
  }) : super(interest: interest, title: title, category: category);

  Map<String, dynamic> toJson() {
    return {
      "interest": interest,
      "category": category,
      "title": title,
    };
  }

  factory InterestModel.fromJson(Map jsonMap) {
    return InterestModel(
      interest: jsonMap["interest"],
      category: jsonMap["category"],
      title: jsonMap["title"],
    );
  }

  String serialize() {
    return json.encode(toJson());
  }

  factory InterestModel.deserialize(String serializedMap) {
    Map deserializedMap = jsonDecode(serializedMap);
    return InterestModel.fromJson(deserializedMap);
  }

  @override
  List<Object?> get props => [interest];
}
