class PostEntity {
  final int id;
  final String name;
  final String email;
  final String? emailVerifiedAt;
  final String pid;
  final String username;
  final bool verified;
  final int isBanned;
  final String slug;
  final String? image;
  final String? banner;
  final String? occupation;
  final int hasInterests;
  final String? bio;
  final String? dateOfBirth;
  final String? country;
  final String? state;
  final String authProvider;
  final String? mobile;
  final String ipAddress;
  final String? location;
  final String? language;
  final String? google2faSecret;
  final int twoFactorPassed;
  final String? referredBy;
  final String walletAddress;
  final String bragWalletBalance;
  final String createdAt;
  final String updatedAt;

  PostEntity({
    required this.id,
    required this.name,
    required this.email,
    this.emailVerifiedAt,
    required this.pid,
    required this.username,
    required this.verified,
    required this.isBanned,
    required this.slug,
    this.image,
    this.banner,
    this.occupation,
    required this.hasInterests,
    this.bio,
    this.dateOfBirth,
    this.country,
    this.state,
    required this.authProvider,
    this.mobile,
    required this.ipAddress,
    this.location,
    this.language,
    this.google2faSecret,
    required this.twoFactorPassed,
    this.referredBy,
    required this.walletAddress,
    required this.bragWalletBalance,
    required this.createdAt,
    required this.updatedAt,
  });
}
