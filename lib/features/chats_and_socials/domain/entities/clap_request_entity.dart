class ClapRequestEntity {
  final String id;
  final String? senderName;
  final String? senderProfile;
  final String? senderImage;
  final String? occupation;
  bool switchButton;

  ClapRequestEntity({
    required this.id,
    this.senderName,
    this.senderProfile,
    this.senderImage,
    this.occupation,
    this.switchButton = false, // ✅ Added default value
  });
}
