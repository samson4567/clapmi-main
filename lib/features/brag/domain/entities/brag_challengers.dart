// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable

import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class BragChallengersEntity extends Equatable {
  final String challenge;
  final String status;
  final BragChallenger challenger;
  final String createdAt;
  final num stake;
  final String title;
  final String combo;
  final String start;
  final String duration;
  final String lifecycleStatus;

  const BragChallengersEntity({
    required this.stake,
    required this.title,
    required this.combo,
    required this.start,
    required this.duration,
    required this.lifecycleStatus,
    required this.challenge,
    required this.status,
    required this.challenger,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        challenge,
        status,
        createdAt,
        challenger,
        stake,
        title,
        combo,
        start,
        duration,
        lifecycleStatus,
      ];
}

class BragChallenger extends Equatable {
  final String pid;
  final String username;
  final String image;
  final String email;
  Uint8List? imageConvert;

  BragChallenger(
      {required this.pid,
      required this.username,
      required this.image,
      required this.email,
      this.imageConvert});

  @override
  List<Object?> get props => [pid, username, image, email, imageConvert];
}

//SingleLiveStreamEntity

class SingleLiveStreamBragChallengerEntity extends Equatable {
  final String challenge;
  final String stake;
  final String duration;
  final String status;
  final String createdAt;
  final String boostPoints;
  Uint8List? imageConvert;
  // Challenger
  final String challengerPid;
  final String challengerUsername;
  final String challengerImage;
  final String challengerEmail;
  // Lifecycle
  final String lifecycleStatus;
  SingleLiveStreamBragChallengerEntity(
      {required this.challenge,
      required this.stake,
      required this.duration,
      required this.status,
      required this.createdAt,
      required this.boostPoints,
      required this.challengerPid,
      required this.challengerUsername,
      required this.challengerImage,
      required this.challengerEmail,
      required this.lifecycleStatus,
      this.imageConvert});

  @override
  List<Object?> get props => [
        challenge,
        stake,
        duration,
        status,
        challengerPid,
        challengerUsername,
        challengerEmail,
        challengerImage,
        lifecycleStatus,
        createdAt,
        boostPoints,
        imageConvert
      ];
}
