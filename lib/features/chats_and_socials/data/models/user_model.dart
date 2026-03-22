import 'package:equatable/equatable.dart';

class UserNearLocationEntity extends Equatable {
  final String? pid;
  final String? username;
  final String? name;
  final String? occupation;
  final String? image;

  const UserNearLocationEntity({
    this.pid,
    this.username,
    this.name,
    this.occupation,
    this.image,
  });

  @override
  List<Object?> get props => [pid, username, name, occupation, image];

  factory UserNearLocationEntity.fromMap(Map<String, dynamic> map) {
    return UserNearLocationEntity(
      pid: map['pid'] != null ? map['pid'] as String : null,
      username: map['username'] != null ? map['username'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      occupation:
          map['occupation'] != null ? map['occupation'] as String : null,
      image: map['image'] != null ? map['image'] as String : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "pid":pid,
      "username":username,
      "name":name,
      "occupation":
          occupation,
      "image":image,
    };
  }
}
