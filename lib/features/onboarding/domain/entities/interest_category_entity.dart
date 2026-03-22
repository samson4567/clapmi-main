import 'package:clapmi/features/onboarding/domain/entities/interest_entity.dart';

class InterestCategoryEntity {
  final List<InterestEntity> interests;

  final String title;
  final String category;

  InterestCategoryEntity({
    required this.interests,
    required this.title,
    required this.category,
  });
}
