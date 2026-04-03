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
    final gifterData = map['gifter'];
    final receiverData = map['receiver'];

    return RecentGiftingModel(
      transaction: map['transaction']?.toString(),
      gifter: gifterData is Map
          ? GifterModel.fromMap(Map<String, dynamic>.from(gifterData))
          : null,
      receiver: receiverData is Map
          ? ReceiverModel.fromMap(Map<String, dynamic>.from(receiverData))
          : null,
      gifterId: gifterData is String
          ? gifterData
          : map['gifter_id']?.toString(),
      receiverId: receiverData is String
          ? receiverData
          : map['receiver_id']?.toString(),
      amount: _readAmount(map),
      metaData: map['metadata'] != null
          ? TimeDataModel.fromMap(
              Map<String, dynamic>.from(map['metadata'] as Map),
            )
          : null,
    );
  }

  static String? _readAmount(Map<String, dynamic> map) {
    const amountKeys = [
      'amount',
      'coin_amount',
      'coins',
      'points',
      'gift_amount',
      'value',
    ];

    for (final key in amountKeys) {
      final value = map[key];
      if (value != null && value.toString().trim().isNotEmpty) {
        return value.toString();
      }
    }

    final metadata = map['metadata'];
    if (metadata is Map) {
      for (final key in amountKeys) {
        final value = metadata[key];
        if (value != null && value.toString().trim().isNotEmpty) {
          return value.toString();
        }
      }
    }

    return null;
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
      user: map['user']?.toString(),
      username: (map['username'] ?? map['name'])?.toString(),
      image: (map['image'] ?? map['avatar'] ?? map['profile_picture'])
          ?.toString(),
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
      user: map['user']?.toString(),
      username: (map['username'] ?? map['name'])?.toString(),
      image: (map['image'] ?? map['avatar'] ?? map['profile_picture'])
          ?.toString(),
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
      date: map['date']?.toString(),
      time: map['time']?.toString(),
    );
  }
}
