// // AvatarEntity
// import 'package:clapmi/features/post/domain/entities/avatar_entity.dart';

// class AvatarModel extends AvatarEntity {
//   AvatarModel({
//     super.avatar,
//     super.url,
//   });

//   AvatarModel copyWith({
//     String? avatar,
//     String? url,
//   }) {
//     return AvatarModel(
//       avatar: avatar ?? this.avatar,
//       url: url ?? this.url,
//     );
//   }

//   factory AvatarModel.fromjson(Map json) {
//     return AvatarModel(
//       avatar: json['avatar'],
//       url: json['url'],
//     );
//   }

//   factory AvatarModel.dummy() {
//     return AvatarModel(
//       avatar: "ad468da6-bcd6-4259-8081-b85c540c3074",
//       url:
//           "https://objectstore.nyc1.civo.com/NW84I0EWMAQCFXYTYY3P/avatars/67e4ceba0f40a.svg",
//     );
//   }

//   Map toOnlineMap() {
//     return {
//       'avatar': avatar,
//       'url': url,
//     };
//   }

//   String toString() {
//     return "${super.toString()}>>> ${toOnlineMap()}";
//   }
// }
