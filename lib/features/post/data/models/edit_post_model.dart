import 'package:clapmi/features/post/domain/entities/edit_post_entity.dart';

class EditPostContentModel extends EditPostContentEntity {
  const EditPostContentModel({
    required super.postId,
    required super.content,
  });

  factory EditPostContentModel.fromJson(Map<String, dynamic> json) {
    return EditPostContentModel(
      postId: json['postId'] ?? '',
      content: json['content'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
    };
  }

  factory EditPostContentModel.fromEntity(EditPostContentEntity entity) {
    return EditPostContentModel(
      postId: entity.postId,
      content: entity.content,
    );
  }
}
