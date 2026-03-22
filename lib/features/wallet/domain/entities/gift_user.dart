class GiftUserEntity {
  final String to;
  final int amount;
  final String password;
  final String type;

  const GiftUserEntity({
    required this.to,
    required this.amount,
    required this.password,
    required this.type,
    // required String debitWallet,
  });
}
