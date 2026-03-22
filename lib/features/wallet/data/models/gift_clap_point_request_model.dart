import 'package:clapmi/features/wallet/domain/entities/gift_user.dart';

/// Data/model layer
class GiftUserModel extends GiftUserEntity {
  // final String debitWallet;

  const GiftUserModel(
      {required super.to,
      required super.amount,
      required super.password,
      required super.type
      // required this.debitWallet,
      });

  /// Deserialize from JSON (exclude password, include debitWallet)
  factory GiftUserModel.fromJson(Map<String, dynamic> json) => GiftUserModel(
        to: json['to'] as String,
        amount: (json['amount'] as num).toInt(),
        password: '', // Not returned by server
        type: '',
        // debitWallet: json['debit_wallet'] as String? ?? '',
      );

  /// Serialize to JSON for sending
  Map<String, dynamic> toJson() => {
        'to': to,
        'amount': amount,
        'password': password,
        'type': type,
      };

  /// Optional copyWith
  GiftUserModel copyWith({
    String? to,
    int? amount,
    String? password,
    String? debitWallet,
    String? type,
  }) {
    return GiftUserModel(
      to: to ?? this.to,
      amount: amount ?? this.amount,
      password: password ?? this.password,
      type: type ?? this.type,
      // debitWallet: debitWallet ?? this.debitWallet,
    );
  }
}
