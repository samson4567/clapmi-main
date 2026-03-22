import 'package:equatable/equatable.dart';

class EditPostContentEntity extends Equatable {
  final String postId;
  final String content;

  const EditPostContentEntity({
    required this.postId,
    required this.content,
  });

  @override
  List<Object?> get props => [postId, content];
}
