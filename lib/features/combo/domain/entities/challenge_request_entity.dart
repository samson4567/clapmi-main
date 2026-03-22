import 'dart:typed_data';

class ChallengeRequestEntity {
  final String? hostAvatar;
  final String? challengerAvatar;
  final String? challengerName;
  final String? hostName;
  final String? postPid;
  final Uint8List? hostImageAvatar;
  final Uint8List? challengerImageAvatar;

  ChallengeRequestEntity({
    this.challengerAvatar,
    this.challengerName,
    this.hostAvatar,
    this.hostName,
    this.postPid,
    this.hostImageAvatar,
    this.challengerImageAvatar,
  });
}
