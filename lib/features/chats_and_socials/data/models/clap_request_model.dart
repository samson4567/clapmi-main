import 'package:clapmi/features/chats_and_socials/domain/entities/clap_request_entity.dart';

class ClapRequestModel extends ClapRequestEntity {
  ClapRequestModel({
    required super.id,
    super.occupation,
    super.senderImage,
    super.senderName,
    super.senderProfile,
    super.switchButton = false,
  });

  factory ClapRequestModel.fromJson(Map<String, dynamic> json) {
    // ✅ FIX: Safely cast sender to Map and handle null
    final sender = json["sender"] as Map<String, dynamic>?;

    return ClapRequestModel(
      id: json["request"] ?? "",
      occupation:
          sender?["occupation"]?.toString() ?? "", // ✅ Convert to string safely
      senderImage: sender?["image"]?.toString() ?? "",
      senderName: sender?["name"]?.toString() ?? "",
      senderProfile: sender?["profile"]?.toString() ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "request": id,
      "sender": {
        "occupation": occupation,
        "image": senderImage,
        "name": senderName,
        "profile": senderProfile,
      }
    };
  }

  factory ClapRequestModel.empty() {
    return ClapRequestModel(
      id: "",
      occupation: "",
      senderImage: "",
      senderName: "",
      senderProfile: "",
    );
  }

  factory ClapRequestModel.fromEntity(ClapRequestEntity entity) {
    return ClapRequestModel(
      id: entity.id,
      occupation: entity.occupation,
      senderImage: entity.senderImage,
      senderName: entity.senderName,
      senderProfile: entity.senderProfile,
      switchButton: entity.switchButton,
    );
  }
}
