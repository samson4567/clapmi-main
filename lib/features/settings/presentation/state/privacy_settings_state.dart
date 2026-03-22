import 'package:equatable/equatable.dart';

abstract class PrivacySettingsState extends Equatable {
  const PrivacySettingsState();

  @override
  List<Object> get props => [];
}

class PrivacySettingsInitial extends PrivacySettingsState {}

class PrivacySettingsLoading extends PrivacySettingsState {}

class PrivacySettingsLoaded extends PrivacySettingsState {
  final Map<String, dynamic> settings;

  const PrivacySettingsLoaded(this.settings);

  @override
  List<Object> get props => [settings];
}

class PrivacySettingsError extends PrivacySettingsState {
  final String message;

  const PrivacySettingsError(this.message);

  @override
  List<Object> get props => [message];
}
