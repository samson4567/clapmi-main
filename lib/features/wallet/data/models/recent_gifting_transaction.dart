import 'package:clapmi/features/wallet/domain/entities/recentgifiting_enity.dart';

class RecentGiftingModel extends RecentGiftingEntity {
  const RecentGiftingModel({
    super.transaction,
    super.gifter,
    super.receiver,
    super.amount,
    super.metaData,
    super.gifterId,
    super.receiverId,
  });

  factory RecentGiftingModel.fromMap(Map<String, dynamic> map) {
    return RecentGiftingModel(
      transaction:
          map['transaction'] != null ? map['transaction'] as String : null,
      gifter: map['gifter'] != null && map['gifter'] is Map<String, dynamic>
          ? GifterModel.fromMap(map['gifter'] as Map<String, dynamic>)
          : null,
      receiver:
          map['receiver'] != null && map['receiver'] is Map<String, dynamic>
              ? ReceiverModel.fromMap(map['receiver'] as Map<String, dynamic>)
              : null,
      gifterId: map['gifter'] != null && map['gifter'] is String?
          ? map['gifter'] as String?
          : null,
      receiverId: map['receiver'] != null && map['receiver'] is String?
          ? map['receiver'] as String?
          : null,
      amount: map['amount'] != null ? map['amount'] as String : null,
      metaData: map['metadata'] != null
          ? TimeDataModel.fromMap(map['metadata'] as Map<String, dynamic>)
          : null,
    );
  }
}

class ReceiverModel extends ReceiverEntity {
  const ReceiverModel({
    required super.image,
    required super.user,
    required super.username,
  });
  factory ReceiverModel.fromMap(Map<String, dynamic> map) {
    return ReceiverModel(
      user: map['user'] != null ? map['user'] as String : null,
      username: map['username'] != null ? map['username'] as String : null,
      image: map['image'] != null ? map['image'] as String : null,
    );
  }
}

class GifterModel extends GifterEntity {
  const GifterModel({
    super.image,
    super.user,
    super.username,
  });

  factory GifterModel.fromMap(Map<String, dynamic> map) {
    return GifterModel(
      user: map['user'] != null ? map['user'] as String : null,
      username: map['username'] != null ? map['username'] as String : null,
      image: map['image'] != null ? map['image'] as String : null,
    );
  }
}

class TimeDataModel extends TimeData {
  const TimeDataModel({
    super.date,
    super.time,
  });

  factory TimeDataModel.fromMap(Map<String, dynamic> map) {
    return TimeDataModel(
      date: map['date'] != null ? map['date'] as String : null,
      time: map['time'] != null ? map['time'] as String : null,
    );
  }
}
