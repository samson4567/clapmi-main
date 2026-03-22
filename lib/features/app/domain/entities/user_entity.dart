// ignore_for_file: must_be_immutable

import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String pid;
  final String? name;
  final String email;
  final String username;
  final String country;
  final String mobile;
  final String? state;
  final String? image;
  Uint8List? myAvatar;

  ProfileEntity({
    required this.pid,
    this.name,
    required this.email,
    required this.username,
    required this.country,
    required this.mobile,
    required this.image,
    this.state,
    this.myAvatar,
  });

  @override
  List<Object?> get props =>
      [pid, name, email, username, country, mobile, state, image, myAvatar];
}
