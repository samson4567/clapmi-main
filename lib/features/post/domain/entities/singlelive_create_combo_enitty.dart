import 'package:equatable/equatable.dart';

class SingleLiveCreateEntity extends Equatable {
  final String type;
  final String duration;
  final String challenge;
  final String contextType;
  final String boostPoints;
  final String stake;
  final String? startTime;

  const SingleLiveCreateEntity({
    required this.type,
    required this.duration,
    required this.challenge,
    required this.contextType,
    required this.boostPoints,
    required this.stake,
    this.startTime,
  });

  @override
  List<Object?> get props =>
      [type, duration, challenge, contextType, boostPoints, stake, startTime];
}
