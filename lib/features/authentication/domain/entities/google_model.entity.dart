import 'package:clapmi/features/authentication/data/models/google_signup_model.dart';

class GoogleSignInModel extends GoogleSignInEntity {
  const GoogleSignInModel({required super.url});

  factory GoogleSignInModel.fromJson(Map<String, dynamic> json) {
    return GoogleSignInModel(
      url: json['url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': {
        'url': url,
      }
    };
  }

  GoogleSignInModel copyWith({String? url}) {
    return GoogleSignInModel(
      url: url ?? this.url,
    );
  }
}
