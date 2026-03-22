// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserSearch {
  final String username;
  final String name;
  final String image;
  final String pid;

  UserSearch({
    required this.username,
    required this.name,
    required this.image,
    required this.pid,
  });

  UserSearch copyWith({
    String? username,
    String? name,
    String? image,
    String? pid,
  }) {
    return UserSearch(
      username: username ?? this.username,
      name: name ?? this.name,
      image: image ?? this.image,
      pid: pid ?? this.pid,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'name': name,
      'image': image,
      'pid': pid,
    };
  }

  factory UserSearch.fromMap(Map<String, dynamic> map) {
    return UserSearch(
      username: map['username'] ?? "",
      name: map['name'] ?? "",
      image: map['image'] ?? "",
      pid: map['pid'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory UserSearch.fromJson(String source) =>
      UserSearch.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'UserSearch(username: $username, name: $name, image: $image, pid: $pid)';

  @override
  bool operator ==(covariant UserSearch other) {
    if (identical(this, other)) return true;

    return other.username == username &&
        other.name == name &&
        other.image == image;
  }

  @override
  int get hashCode => username.hashCode ^ name.hashCode ^ image.hashCode;
}
