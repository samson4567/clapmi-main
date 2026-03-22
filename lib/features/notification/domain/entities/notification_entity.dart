// ignore_for_file: constant_identifier_names

class NotificationEntity {
  final String? title;
  final String? body;
  final String? createDate;
  final String? readAt;
  NotificationType? notificationType;
  Map? data;
  String? id;

  NotificationEntity({
    required this.title,
    required this.body,
    required this.createDate,
    required this.data,
    this.notificationType,
    this.id,
    this.readAt,
  }) {
    notificationType = getEnumType(data?['type']);
  }

  NotificationType getEnumType(String? typeInString) {
    NotificationType result;
    switch (typeInString) {
      case "live":
        result = NotificationType.LIVE;
        break;
      case "challenge-request":
        result = NotificationType.CHALLENGE_REQUEST;
        break;
      case "challenge-request-answer":
        result = NotificationType.CHALLENGE_REQUEST_ANSWER;
        break;
      case "clap-request":
        result = NotificationType.CLAP_REQUEST;
        break;
      case "clap-request-answer":
        result = NotificationType.CLAP_REQUEST_ANSWER;
        break;
      case "challenge-schedule":
        result = NotificationType.CHALLENGE_SCHEDULE;
        break;
      case "advertisment":
        result = NotificationType.ADVERTISMENT;
        break;
      case "Post":
        result = NotificationType.POST;
        break;
      case "account alert":
        result = NotificationType.Account_Alert;
      case "email verification":
        result = NotificationType.Email_Verification;
      case "password reset":
        result = NotificationType.Password_Reset;
      case "new login":
        result = NotificationType.New_Login;
      case "new message":
        result = NotificationType.New_Message;

      default:
        result = NotificationType.ORDINARY;
    }
    return result;
  }
}

enum NotificationType {
  LIVE,
  CHALLENGE_SCHEDULE,
  CHALLENGE_REQUEST,
  CHALLENGE_REQUEST_ANSWER,

  CLAP_REQUEST,
  CLAP_REQUEST_ANSWER,
  ADVERTISMENT,
  POST,
  ORDINARY,
  // neo
  Account_Alert,
  Email_Verification,
  Password_Reset,
  New_Login,
  New_Message,
}
