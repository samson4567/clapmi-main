import 'package:clapmi/features/post/domain/entities/video_url.dart';

class VideoUrlModel extends VideoUrlEntity {
  const VideoUrlModel({super.path, super.url});

  factory VideoUrlModel.fromMap(Map<String, dynamic> map) {
    return VideoUrlModel(
      url: map['url'] != null ? map['url'] as String : null,
      path: map['path'] != null ? map['path'] as String : null,
    );
  }
}
