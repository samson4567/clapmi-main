import 'package:clapmi/core/mapper/failure_mapper.dart';
import 'package:clapmi/core/utils.dart';
import 'package:clapmi/features/combo/data/datasources/combo_local_datasource.dart';
import 'package:clapmi/features/combo/data/datasources/combo_remote_datasource.dart';
import 'package:clapmi/features/combo/domain/entities/combo_entity.dart';
import 'package:clapmi/features/combo/domain/repositories/combo_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:clapmi/core/error/failure.dart';

class ComboRepositoryImpl implements ComboRepository {
  ComboRepositoryImpl({
    required this.comboRemoteDatasource,
    required this.comboLocalDatasource,
  });

  final ComboRemoteDatasource comboRemoteDatasource;
  final ComboLocalDatasource comboLocalDatasource;

  @override
  Future<Either<Failure, List<ComboEntity>>> getLiveCombos() async {
    try {
      var result = await comboRemoteDatasource.getLiveCombos();
      for (var combo in result) {
        //**Check if combo challenger is not null */
        //-------------------------------------------
        if (combo.challenger != null) {
          if (combo.challenger!.avatar!.contains(".svg")) {
            combo.challenger?.avatarConvert =
                await fetchSvg(combo.challenger!.avatar!);
          }
        }
        //**Check if combo host is not null */
        //---------------------------------------
        if (combo.host != null) {
          if (combo.host!.avatar!.contains(".svg")) {
            combo.host?.avatarConvert = await fetchSvg(combo.host!.avatar!);
          }
        }
      }
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<ComboEntity>>> getUpcomingCombos() async {
    try {
      var result = await comboRemoteDatasource.getUpcomingCombos();
      for (var combo in result) {
        if (combo.challenger!.avatar!.contains(".svg")) {
          combo.challenger!.avatarConvert =
              await fetchSvg(combo.challenger!.avatar!);
        }
        if (combo.host!.avatar!.contains(".svg")) {
          combo.host!.avatarConvert = await fetchSvg(combo.host!.avatar!);
        }
      }
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, ComboEntity>> getComboDetail(
      {required String comboID}) async {
    try {
      var result = await comboRemoteDatasource.getComboDetail(comboID: comboID);
      if (result.challenger != null) {
        if (result.challenger!.avatar!.contains(".svg")) {
          result.challenger!.avatarConvert =
              await fetchSvg(result.challenger!.avatar ?? '');
        }
      }
      if (result.host != null) {
        if (result.host!.avatar!.contains(".svg")) {
          result.host!.avatarConvert =
              await fetchSvg(result.host!.avatar ?? '');
        }
      }
      return right(result);
    } catch (e) {
      print("An error being caught from repository level ${e.toString()}");
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> startCombo({required String comboID}) async {
    try {
      final result = await comboRemoteDatasource.startCombo(comboID: comboID);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> setReminderForCombo(
      {required String comboID, required String time}) async {
    try {
      final result = await comboRemoteDatasource.setReminderForCombo(
          comboID: comboID, time: time);

      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> joinComboGround(
      {required String comboID}) async {
    try {
      final result =
          await comboRemoteDatasource.joinComboGround(comboID: comboID);

      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> leaveComboGround(
      {required String comboID}) async {
    try {
      final result =
          await comboRemoteDatasource.leaveComboGround(comboID: comboID);

      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, String>> rescheduleChallenge(
      {required String postID, required String newTime}) async {
    try {
      final result = await comboRemoteDatasource.rescheduleChallenge(
          postID: postID, newTime: newTime);
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, SwitchDeviceResult>> switchDevice(
      {required String comboID, required String deviceId}) async {
    try {
      final result = await comboRemoteDatasource.switchDevice(
        comboID: comboID,
        deviceId: deviceId,
      );
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, JoinCompanionResult>> joinCompanion(
      {required String comboID, required String deviceId}) async {
    try {
      final result = await comboRemoteDatasource.joinCompanion(
        comboID: comboID,
        deviceId: deviceId,
      );
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, LiveComboEntity>> getSingleLiveCombo(
      {required String comboId}) async {
    try {
      final result =
          await comboRemoteDatasource.getSingleLiveCombo(comboId: comboId);
      if (result.host != null) {
        if (result.host!.avatar!.contains(".svg")) {
          result.host!.avatarConvert =
              await fetchSvg(result.host!.avatar ?? '');
        }
      }
      if (result.challenger != null) {
        if (result.challenger!.avatar!.contains('.svg')) {
          result.challenger!.avatarConvert =
              await fetchSvg(result.challenger!.avatar ?? '');
        }
      }
      return right(result);
    } catch (e) {
      return left(mapExceptionToFailure(e));
    }
  }
}
