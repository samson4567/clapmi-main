import 'package:clapmi/features/combo/domain/entities/challenge_request_entity.dart';

// ChallengeRequestEntity

class ChallengeRequestModel extends ChallengeRequestEntity {
  ChallengeRequestModel({
    super.challengerAvatar,
    super.hostAvatar,
  });

  factory ChallengeRequestModel.fromJson(Map<String, dynamic> json) {
    return ChallengeRequestModel(
      challengerAvatar: json["challengerAvatar"],
      hostAvatar: json["hostAvatar"],
    );
  }
  factory ChallengeRequestModel.fromEntity(ChallengeRequestEntity comboEntity) {
    return ChallengeRequestModel(
      challengerAvatar: comboEntity.challengerAvatar,
      hostAvatar: comboEntity.hostAvatar,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "challengerAvatar": challengerAvatar,
      "hostAvatar": hostAvatar,
    };
  }

  factory ChallengeRequestModel.empty() {
    return ChallengeRequestModel();
  }
}




//  {
//             "combo": "e4d66cbd-3cb3-406d-8ab0-7918d47c6477",
//             "about": "Apple vs Samsung",
//             "waiting": 100,
//             "brag": "a5783253-6d42-449d-8d79-282dee8bdb56",
//             "duration": "30 minutes",
//             "start": "2025-04-12 12:08:11",
//             "status": "UPCOMING",
//             "host": {
//                 "profile": "XYnMApLWqnm9dwqD",
//                 "avatar": "http://localhost:9000/clapmi/avatars/67f0525d6be8d.svg"
//             },
//             "challenger": {
//                 "profile": "7f1yhaIBMTBhDz4t",
//                 "avatar": "http://localhost:9000/clapmi/avatars/67f0525d6be8d.svg"
//             }
//         }