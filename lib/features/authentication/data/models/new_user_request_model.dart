class NewUserRequestModel {
  final String name;
  final String username;
  final String email;
  final String password;
  final String passwordConfirmation;

  NewUserRequestModel({
    required this.name,
    required this.username,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "username": username,
      "email": email,
      "password": password,
      "password_confirmation": passwordConfirmation,
    };
  }
}
