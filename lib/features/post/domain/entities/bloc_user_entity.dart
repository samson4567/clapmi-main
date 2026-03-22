import 'package:equatable/equatable.dart';

class BlockUserPostEntity extends Equatable {
  final String creator;

  const BlockUserPostEntity({required this.creator});

  @override
  List<Object?> get props => [creator];
}
