import 'package:clapmi/features/combo/domain/entities/combo_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:clapmi/core/error/failure.dart';

abstract class ComboRepository {
  Future<Either<Failure, List<ComboEntity>>> getLiveCombos();
  Future<Either<Failure, List<ComboEntity>>> getUpcomingCombos();
  Future<Either<Failure, ComboEntity>> getComboDetail(
      {required String comboID});
  Future<Either<Failure, String>> startCombo({required String comboID});
  Future<Either<Failure, String>> setReminderForCombo(
      {required String comboID, required String time});
  Future<Either<Failure, String>> joinComboGround({required String comboID});
  Future<Either<Failure, String>> leaveComboGround({required String comboID});
  Future<Either<Failure, String>> rescheduleChallenge(
      {required String postID, required String newTime});
  
  Future<Either<Failure, LiveComboEntity>> getSingleLiveCombo({required String comboId});

  // setRemindalForCombo
}
