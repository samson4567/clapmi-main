
import 'package:clapmi/features/settings/repositories/settings_repository.dart';
import 'package:clapmi/models/notification_settings_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class NotificationSettingsEvent {}

class GetNotificationSettings extends NotificationSettingsEvent {}

class UpdateNotificationSettings extends NotificationSettingsEvent {
  final int networkRequestAlert;
  final int emailAlert;

  UpdateNotificationSettings({
    required this.networkRequestAlert,
    required this.emailAlert,
  });
}

abstract class NotificationSettingsState {}

class NotificationSettingsLoading extends NotificationSettingsState {}

class NotificationSettingsLoaded extends NotificationSettingsState {
  final List<NotificationSettings> settings;
  NotificationSettingsLoaded(this.settings);
}

class NotificationSettingsError extends NotificationSettingsState {
  final String message;
  NotificationSettingsError(this.message);
}

class NotificationSettingsBloc
    extends Bloc<NotificationSettingsEvent, NotificationSettingsState> {
  final SettingsRepository repository;

  NotificationSettingsBloc(this.repository)
      : super(NotificationSettingsLoading()) {
    on<GetNotificationSettings>(_onGetSettings);
    on<UpdateNotificationSettings>(_onUpdateSettings);
  }

  Future<void> _onGetSettings(
    GetNotificationSettings event,
    Emitter<NotificationSettingsState> emit,
  ) async {
    try {
      emit(NotificationSettingsLoading());
      final settings = await repository.getNotificationSettings();
      settings.fold((error) {
        emit(NotificationSettingsError(error.message));
      }, (items) {
        emit(NotificationSettingsLoaded(items));
      });
    } catch (e) {
      emit(NotificationSettingsError(e.toString()));
    }
  }

  Future<void> _onUpdateSettings(
    UpdateNotificationSettings event,
    Emitter<NotificationSettingsState> emit,
  ) async {
    try {
      emit(NotificationSettingsLoading());
      await repository.updateNotificationSettings(
        networkRequestAlert: event.networkRequestAlert,
        emailAlert: event.emailAlert,
      );
      final settings = await repository.getNotificationSettings();
      settings.fold((error) {
        emit(NotificationSettingsError(error.message));
      }, (items) {
        emit(NotificationSettingsLoaded(items));
      });
    } catch (e) {
      emit(NotificationSettingsError(e.toString()));
    }
  }
}
