import 'package:bloc/bloc.dart';
import 'package:clapmi/features/settings/repositories/settings_repository.dart';
import 'package:clapmi/models/privacy_settings_model.dart';
import 'package:equatable/equatable.dart'; // Import Equatable

abstract class PrivacySettingsEvent extends Equatable {
  // Extend Equatable
  const PrivacySettingsEvent(); // Add const constructor

  @override
  List<Object?> get props => []; // Implement props
}

class GetPrivacySettings extends PrivacySettingsEvent {}

// Event for updating visibility settings (posts/stories)
class UpdateVisibilitySetting extends PrivacySettingsEvent {
  final String key; // e.g., 'who_can_see_my_post', 'who_can_view_my_stories'
  final String value;

  const UpdateVisibilitySetting(
      {required this.key, required this.value}); // Add const

  @override
  List<Object?> get props => [key, value];
}

// Event for updating boolean settings (switches)
class UpdateBooleanSetting extends PrivacySettingsEvent {
  final String key; // e.g., 'show_number', 'private_account'
  final bool value;

  const UpdateBooleanSetting(
      {required this.key, required this.value}); // Add const

  @override
  List<Object?> get props => [key, value];
}

abstract class PrivacySettingsState extends Equatable {
  // Extend Equatable
  const PrivacySettingsState(); // Add const constructor

  @override
  List<Object?> get props => []; // Implement props
}

class PrivacySettingsInitial
    extends PrivacySettingsState {} // Add Initial state

class PrivacySettingsLoading extends PrivacySettingsState {
  // Optionally add a key to indicate which setting is loading
  final String? loadingKey;
  const PrivacySettingsLoading({this.loadingKey});

  @override
  List<Object?> get props => [loadingKey];
}

class PrivacySettingsLoaded extends PrivacySettingsState {
  final List<PrivacySettings> settings;
  // Store settings as a map for easier access by key
  final Map<String, PrivacySettings> settingsMap;

  PrivacySettingsLoaded(this.settings)
      : settingsMap = {for (var s in settings) s.key: s};

  @override
  List<Object> get props => [settingsMap]; // Use map in props for comparison
}

class PrivacySettingsError extends PrivacySettingsState {
  final String message;
  const PrivacySettingsError(this.message); // Add const

  @override
  List<Object> get props => [message];
}

class PrivacySettingsBloc
    extends Bloc<PrivacySettingsEvent, PrivacySettingsState> {
  final SettingsRepository repository;

  PrivacySettingsBloc(this.repository) : super(PrivacySettingsInitial()) {
    // Start with Initial
    on<GetPrivacySettings>(_onGetSettings);
    on<UpdateVisibilitySetting>(_onUpdateVisibilitySetting);
    on<UpdateBooleanSetting>(_onUpdateBooleanSetting);
  }

  // Helper to get current settings if state is loaded
  List<PrivacySettings> _getCurrentSettings(PrivacySettingsState state) {
    if (state is PrivacySettingsLoaded) {
      return state.settings;
    }
    return []; // Return empty list if not loaded
  }

  Future<void> _onGetSettings(
    GetPrivacySettings event,
    Emitter<PrivacySettingsState> emit,
  ) async {
    try {
      emit(const PrivacySettingsLoading());
      final settings = await repository.getPrivacySettings();
      settings.fold((error) {
        emit(PrivacySettingsError(error.message));
      }, (items) {
        emit(PrivacySettingsLoaded(items));
      });
    } catch (e) {
      emit(PrivacySettingsError(e.toString()));
    }
  }

  Future<void> _onUpdateVisibilitySetting(
    UpdateVisibilitySetting event,
    Emitter<PrivacySettingsState> emit,
  ) async {
    final previousSettings = _getCurrentSettings(state);
    try {
      // Emit loading state, optionally indicating which key is loading
      emit(PrivacySettingsLoading(loadingKey: event.key));
      // Assume repository has a method to update specific visibility setting by key
      // This needs modification in repository and data source
      await repository.updateVisibilitySetting(event.key, event.value);
      // Reload all settings after update
      final settings = await repository.getPrivacySettings();

      settings.fold((error) {
        emit(PrivacySettingsError(error.message));
      }, (items) {
        emit(PrivacySettingsLoaded(items));
      });
    } catch (e) {
      emit(PrivacySettingsError(e.toString()));
      // Re-emit previous loaded state on error if desired
      if (previousSettings.isNotEmpty) {
        emit(PrivacySettingsLoaded(previousSettings));
      }
    }
  }

  Future<void> _onUpdateBooleanSetting(
    UpdateBooleanSetting event,
    Emitter<PrivacySettingsState> emit,
  ) async {
    final previousSettings = _getCurrentSettings(state);
    try {
      // Emit loading state, optionally indicating which key is loading
      emit(PrivacySettingsLoading(loadingKey: event.key));
      // Assume repository has a method to update specific boolean setting by key
      // This needs modification in repository and data source
      await repository.updateBooleanSetting(event.key, event.value);
      // Reload all settings after update
      final settings = await repository.getPrivacySettings();
      settings.fold((error) {
        emit(PrivacySettingsError(error.message));
      }, (items) {
        emit(PrivacySettingsLoaded(items));
      });
    } catch (e) {
      emit(PrivacySettingsError(e.toString()));
      // Re-emit previous loaded state on error if desired
      if (previousSettings.isNotEmpty) {
        emit(PrivacySettingsLoaded(previousSettings));
      }
    }
  }
}
