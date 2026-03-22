import 'package:clapmi/core/error/failure.dart';
import 'package:clapmi/features/onboarding/domain/entities/interest_category_entity.dart';
import 'package:clapmi/features/onboarding/domain/entities/other_user_entity.dart';
import 'package:dartz/dartz.dart';

abstract class OnboardingRepository {
  Future<Either<Failure, List<InterestCategoryEntity>>> loadInterests();
  Future<Either<Failure, List<OtherUserEntity>>> getRandomUserList();
  Future<Either<Failure, String>> sendClapRequestToUsers(
      {required List<String> userPids});
  Future<Either<Failure, String>> saveInterests(
      {required List<String> interestIDs});
}
