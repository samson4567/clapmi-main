import 'package:equatable/equatable.dart';

class BlokUserEntity extends Equatable {
  final String creator;

  const BlokUserEntity({required this.creator});

  @override
  List<Object?> get props => throw UnimplementedError();
}
