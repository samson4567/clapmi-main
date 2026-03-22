import 'package:clapmi/features/wallet/domain/entities/swap_entity.dart';

class SwapModel extends SwapEntity {
  const SwapModel({
    required super.from,
    required super.to,
    required super.amount,
  });

  factory SwapModel.fromJson(Map<String, dynamic> json) {
    // If the API really returns a List for each key, grab the first item.
    // Add fall-backs so the factory never feeds nulls to the constructor.
    return SwapModel(
      from: (json['from'] as List?)?.first ?? '',
      to: (json['to'] as List?)?.first ?? '',
      amount: (json['amount'] as List?)?.first ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'from': from,
        'to': to,
        'amount': amount,
      };
}
