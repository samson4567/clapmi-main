// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class RecentGiftingEntity extends Equatable {
  final String? transaction;
  final GifterEntity? gifter; // Made nullable and specific
  final ReceiverEntity? receiver;
  final String? gifterId;
  final String? receiverId;
  final String? amount;
  final TimeData? metaData;

  const RecentGiftingEntity({
    required this.transaction,
    required this.gifter,
    required this.receiver,
    required this.amount,
    required this.metaData,
    required this.gifterId,
    required this.receiverId,
  });

  @override
  List<Object?> get props => [
        transaction,
        gifter,
        receiver,
        amount,
        metaData,
        gifterId,
        receiverId,
      ];

}

class ReceiverEntity extends Equatable {
  final String? user;
  final String? username;
  final String? image;

  const ReceiverEntity({
    required this.user,
    required this.username,
    required this.image,
  });

  @override
  List<Object?> get props => [user, username, image];
}

class GifterEntity extends Equatable {
  final String? user;
  final String? username;
  final String? image;

  const GifterEntity({
    required this.user,
    required this.username,
    required this.image,
  });

  @override
  List<Object?> get props => [user, username, image];
}

class TimeData extends Equatable {
  final String? date;
  final String? time;
  const TimeData({
    required this.date,
    required this.time,
  });

  @override
  List<Object?> get props => [date, time];
}
