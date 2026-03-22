import 'package:clapmi/core/app_variables.dart';
import 'package:clapmi/features/app/presentation/blocs/app/app_bloc.dart';
import 'package:clapmi/features/notification/domain/repositories/notification_repository.dart';
import 'package:clapmi/features/notification/presentation/blocs/user_bloc/notification_event.dart';
import 'package:clapmi/features/notification/presentation/blocs/user_bloc/notification_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository notificationRepository;
  final AppBloc appBloc;

  NotificationBloc(
      {required this.appBloc, required this.notificationRepository})
      : super(NotificationInitial()) {
    on<GetNotificationListEvent>(_onGetNotificationListEvent);
    on<MarkNotificationAsReadEvent>(_onMarkNotificationAsReadEvent);
    on<MarkAllNotificationAsReadEvent>(_onMarkAllNotificationAsReadEvent);
    on<ClearNotificationEvent>(_onClearNotificationEvent);
    on<ClearAllNotificationsEvent>(_onClearAllNotificationsEvent);

    // ClearAllNotifications
  }

  Future<void> _onGetNotificationListEvent(
      GetNotificationListEvent event, Emitter<NotificationState> emit) async {
    emit(GetNotificationListLoadingState());
    final result = await notificationRepository.getNotificationList();

    result.fold(
        (error) =>
            emit(GetNotificationListErrorState(errorMessage: error.message)),
        (listOfNotificationEntity) {
      listOfNotificationEntityG = listOfNotificationEntity;
      notificationCountG = listOfNotificationEntity
          .where(
            (element) => element.readAt == null,
          )
          .toList()
          .length;
      emit(
        GetNotificationListSuccessState(
            listOfNotificationEntity: listOfNotificationEntity),
      );
    });
  }

  Future<void> _onMarkNotificationAsReadEvent(MarkNotificationAsReadEvent event,
      Emitter<NotificationState> emit) async {
    emit(MarkNotificationAsReadLoadingState());
    final result = await notificationRepository.markNotificationAsRead(
        notificationID: event.notificationID);

    result.fold(
        (error) =>
            emit(MarkNotificationAsReadErrorState(errorMessage: error.message)),
        (message) {
      emit(
        MarkNotificationAsReadSuccessState(message: message),
      );
    });
  }

  Future<void> _onMarkAllNotificationAsReadEvent(
      MarkAllNotificationAsReadEvent event,
      Emitter<NotificationState> emit) async {
    emit(MarkAllNotificationAsReadLoadingState());
    final result = await notificationRepository.markAllNotificationAsRead();

    result.fold(
        (error) => emit(
            MarkAllNotificationAsReadErrorState(errorMessage: error.message)),
        (message) {
      emit(
        MarkAllNotificationAsReadSuccessState(message: message),
      );
    });
  }

  Future<void> _onClearNotificationEvent(
      ClearNotificationEvent event, Emitter<NotificationState> emit) async {
    emit(ClearNotificationLoadingState());
    final result = await notificationRepository.clearNotification(
        notificationID: event.notificationID);

    result.fold(
        (error) =>
            emit(ClearNotificationErrorState(errorMessage: error.message)),
        (message) {
      emit(
        ClearNotificationSuccessState(message: message),
      );
    });
  }

  Future<void> _onClearAllNotificationsEvent(
      ClearAllNotificationsEvent event, Emitter<NotificationState> emit) async {
    emit(ClearAllNotificationsLoadingState());
    final result = await notificationRepository.clearAllNotifications();

    result.fold(
        (error) =>
            emit(ClearAllNotificationsErrorState(errorMessage: error.message)),
        (message) {
      emit(
        ClearAllNotificationsSuccessState(message: message),
      );
    });
  }

  // _onClearAllNotificationsEvent
}
