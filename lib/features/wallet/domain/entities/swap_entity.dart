import 'package:equatable/equatable.dart';

class SwapEntity extends Equatable {
  final String from;
  final String to;
  final String amount;

  const SwapEntity({
    required this.from,
    required this.to,
    required this.amount,
  });

  @override
  List<Object?> get props => [from, to, amount];
}

class BuyPointEntity extends Equatable {
  final String amount;
  final String coin;
  final String paymentMethod;

  const BuyPointEntity(
      {required this.amount, required this.coin, required this.paymentMethod});

  @override
  List<Object?> get props => [amount, coin, paymentMethod];
}
