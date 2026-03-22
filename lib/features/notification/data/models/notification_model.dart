import 'package:clapmi/features/notification/domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  NotificationModel({
    super.title,
    super.body,
    super.createDate,
    super.data,
    super.notificationType,
    super.id,
    super.readAt,
  }) {
    notificationType ??= getEnumType(data?['type']);
  }

  factory NotificationModel.fromJson({required Map json}) {
    return NotificationModel(
        title: json['data']['title'],
        body: json['data']['message'],
        createDate: json['date'],
        id: json['id'],
        data: json['data'],
        readAt: json['read_at']);
  }

  NotificationModel copyWith(
      {String? title,
      String? body,
      String? date,
      String? id,
      Map? data,
      String? readAt}) {
    return NotificationModel(
      title: title ?? this.title,
      body: body ?? this.body,
      data: data ?? this.data,
      id: id ?? this.id,
      readAt: readAt ?? this.readAt,
    );
  }

  factory NotificationModel.fromEntity(NotificationEntity notificationEntity) {
    return NotificationModel(
      title: notificationEntity.title,
      body: notificationEntity.body,
      createDate: notificationEntity.createDate,
      id: notificationEntity.id,
      data: notificationEntity.data,
    );
  }
}
