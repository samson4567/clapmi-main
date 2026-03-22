class PasswordUpdateEntity {
  PasswordUpdateEntity({
    required this.currentPassword,
    required this.newPassword,
    required this.passwordConfirmation,
  });

  final String currentPassword;
  final String newPassword;
  final String passwordConfirmation;
}
