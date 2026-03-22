// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class VideoUrlEntity extends Equatable {
  final String? url;
  final String? path;
  const VideoUrlEntity({
    this.url,
    this.path,
  });

  @override
  List<Object?> get props => [url, path];
}
