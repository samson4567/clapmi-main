import 'package:clapmi/core/error/failure.dart';
import 'package:clapmi/features/settings/data/datasources/settings_remote_datasource.dart';
import 'package:clapmi/models/notification_settings_model.dart';
import 'package:clapmi/models/privacy_settings_model.dart';
import 'package:dartz/dartz.dart';

abstract class SettingsRepository {
  Future<Either<Failure, List<PrivacySettings>>> getPrivacySettings();
  // Keep old method signature for compatibility or remove if unused elsewhere
  // Future<Either<Failure, String>> updatePrivacySetting(String visibility);

  // New method for updating visibility settings by key
  Future<Either<Failure, String>> updateVisibilitySetting(
      String key, String value);

  // New method for updating boolean settings by key
  Future<Either<Failure, String>> updateBooleanSetting(String key, bool value);

  Future<Either<Failure, List<NotificationSettings>>> getNotificationSettings();
  Future<Either<Failure, String>> updateNotificationSettings({
    required int networkRequestAlert,
    required int emailAlert,
  });
}

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsDataSource _dataSource;

  SettingsRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, List<PrivacySettings>>> getPrivacySettings() async {
    try {
      final result = await _dataSource.getPrivacySettings();
      return Right(result);
    } catch (e) {
      return Left(
          ServerFailure(message: 'Failed to load privacy settings: $e'));
    }
  }

  // Keep old method implementation for compatibility or remove if unused elsewhere
  // @override
  // Future<Either<Failure, String>> updatePrivacySetting(String visibility) async {
  //   try {
  //    final result = await _dataSource.updatePrivacySettings(visibility);
  //    return Right(result);
  //   } catch (e) {
  //     return Left(ServerFailure(message: 'Failed to update privacy settings: $e'));
  //   }
  // }

  // Implementation for updating visibility settings by key
  @override
  Future<Either<Failure, String>> updateVisibilitySetting(
      String key, String value) async {
    try {
      // Assuming dataSource has a method that takes key and value
      final result = await _dataSource.updatePrivacySettingByKey(key, value);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(
          message: 'Failed to update visibility setting $key: $e'));
    }
  }

  // Implementation for updating boolean settings by key
  @override
  Future<Either<Failure, String>> updateBooleanSetting(
      String key, bool value) async {
    try {
      // Assuming dataSource has a method that takes key and boolean value
      final result = await _dataSource.updatePrivacySettingByKey(key, value);
      return Right(result);
    } catch (e) {
      return Left(
          ServerFailure(message: 'Failed to update boolean setting $key: $e'));
    }
  }

  @override
  Future<Either<Failure, List<NotificationSettings>>>
      getNotificationSettings() async {
    try {
      final result = await _dataSource.getNotificationSettings();
      return Right(result);
    } catch (e) {
      return Left(
          ServerFailure(message: 'Failed to load notification settings: $e'));
    }
  }

  @override
  Future<Either<Failure, String>> updateNotificationSettings({
    required int networkRequestAlert,
    required int emailAlert,
  }) async {
    try {
      final result = await _dataSource.updateNotificationSettings(
          networkRequestAlert: networkRequestAlert, emailAlert: emailAlert);
      return Right(result);
    } catch (e) {
      return Left(
          ServerFailure(message: 'Failed to update notification settings: $e'));
    }
  }
}
