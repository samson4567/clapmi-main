import 'package:clapmi/core/error/failure.dart';
import 'package:clapmi/core/mapper/failure_mapper.dart';
import 'package:clapmi/features/onboarding/data/datasources/onboarding_local_datasource.dart';
import 'package:clapmi/features/onboarding/data/datasources/onboarding_remote_datasource.dart';
import 'package:clapmi/features/onboarding/domain/entities/interest_category_entity.dart';
import 'package:clapmi/features/onboarding/domain/entities/other_user_entity.dart';

import 'package:clapmi/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:dartz/dartz.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  OnboardingRepositoryImpl(
      {required this.onboardingRemoteDatasource,
      required this.onboardingLocalDatasource});
  final OnboardingRemoteDatasource onboardingRemoteDatasource;
  final OnboardingLocalDatasource onboardingLocalDatasource;

  @override
  Future<Either<Failure, List<InterestCategoryEntity>>> loadInterests() async {
    try {
      final result = await onboardingRemoteDatasource.loadInterests();
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<OtherUserEntity>>> getRandomUserList() async {
    try {
      final result = await onboardingRemoteDatasource.getRandomUserList();
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> sendClapRequestToUsers(
      {required List<String> userPids}) async {
    try {
      final result = await onboardingRemoteDatasource.sendClapRequestToUsers(
          userPids: userPids);

      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> saveInterests(
      {required List<String> interestIDs}) async {
    try {
      final result = await onboardingRemoteDatasource.saveInterests(
          interestIDs: interestIDs);

      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }
}
