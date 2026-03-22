// MODEL (data layer)
import 'package:clapmi/features/wallet/domain/entities/verify_order_entity.dart';

class VerifyOrderModel extends VerifyOrderEntity {
  const VerifyOrderModel({super.status});

  factory VerifyOrderModel.fromMap(Map<String, dynamic> map) {
    final data = map['data'] ?? map;
    return VerifyOrderModel(
      status: data['status']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data': {
        'status': status,
      },
    };
  }

  @override
  String toString() => 'VerifyOrderModel(status: $status)';
}
