class PasswordUpdateRequest {
  final String currentPassword;
  final String newPassword;
  final String passwordConfirmation;

  PasswordUpdateRequest({
    required this.currentPassword,
    required this.newPassword,
    required this.passwordConfirmation,
  });

  Map<String, dynamic> toJson() {
    return {
      "current_password": currentPassword,
      "password": newPassword,
      "password_confirmation": passwordConfirmation,
    };
  }
}
