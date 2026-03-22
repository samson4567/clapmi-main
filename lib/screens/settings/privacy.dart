import 'package:clapmi/features/settings/presentation/bloc/privacy_settings_bloc.dart';
// Remove GetIt if Bloc is provided via context
// import 'package:get_it/get_it.dart';
import 'package:clapmi/models/privacy_settings_model.dart'; // Import the model
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PrivacySettingsScreen extends StatefulWidget {
  const PrivacySettingsScreen({super.key});

  @override
  _PrivacySettingsScreenState createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen> {
  @override
  void initState() {
    super.initState();
    // Dispatch the initial event to load settings
    context.read<PrivacySettingsBloc>().add(GetPrivacySettings());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Privacy'),
      ),
      body: BlocConsumer<PrivacySettingsBloc, PrivacySettingsState>(
        // Use BlocConsumer for listening to side effects like errors
        listener: (context, state) {
          if (state is PrivacySettingsError) {
            // Show a snackbar or dialog for errors
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('Error updating settings: ${state.message}')),
            );
          }
        },
        builder: (context, state) {
          // Determine if loading is happening (globally or for a specific key)
          final bool isLoading = state is PrivacySettingsLoading;
          final String? loadingKey = isLoading ? (state).loadingKey : null;

          // Show initial loading indicator or error
          if (state is PrivacySettingsInitial ||
              (isLoading &&
                  state is! PrivacySettingsLoaded &&
                  loadingKey == null)) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is PrivacySettingsError &&
              state is! PrivacySettingsLoaded) {
            // Show error only if not falling back to loaded state
            return Center(
                child: Text('Error loading settings: ${state.message}'));
          }

          // Extract settings map from loaded state (or keep previous if loading update)
          Map<String, PrivacySettings> settingsMap = {};
          if (state is PrivacySettingsLoaded) {
            settingsMap = state.settingsMap;
          } else if (context.read<PrivacySettingsBloc>().state
              is PrivacySettingsLoaded) {
            // If loading an update, use the previous loaded state's data
            settingsMap = (context.read<PrivacySettingsBloc>().state
                    as PrivacySettingsLoaded)
                .settingsMap;
          }

          // Helper function to get setting value or default
          dynamic getSettingValue(String key, dynamic defaultValue) {
            // Convert string 'true'/'false' to bool for boolean settings
            if (defaultValue is bool) {
              return settingsMap[key]?.userValue.toLowerCase() == 'true' ??
                  defaultValue;
            }
            return settingsMap[key]?.userValue ?? defaultValue;
          }

          // Extract specific settings using keys (ensure keys match backend)
          bool showNumber = getSettingValue('show_number', false);
          bool showEmail = getSettingValue('show_email_address', false);
          bool showLingoModal = getSettingValue('show_lingo_modal', false);
          bool privateAccount = getSettingValue('private_account', false);
          String postVisibility =
              getSettingValue('who_can_see_my_post', 'everyone');
          String storyVisibility = getSettingValue(
              'who_can_view_my_stories', 'everyone'); // Assuming key

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Manage your account security to keep your data safe',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    color: Color(0xFF8C8C8C),
                  ),
                ),
                // Pass current state values and dispatch update events
                _buildSwitchSetting('Show Number', 'show_number', showNumber,
                    isLoading && loadingKey == 'show_number', (value) {
                  context.read<PrivacySettingsBloc>().add(
                      UpdateBooleanSetting(key: 'show_number', value: value));
                }),
                _buildSwitchSetting(
                    'Show Email Address',
                    'show_email_address',
                    showEmail,
                    isLoading && loadingKey == 'show_email_address', (value) {
                  context.read<PrivacySettingsBloc>().add(UpdateBooleanSetting(
                      key: 'show_email_address', value: value));
                }),
                _buildSwitchSetting(
                    'Show Lingo Modal',
                    'show_lingo_modal',
                    showLingoModal,
                    isLoading && loadingKey == 'show_lingo_modal', (value) {
                  context.read<PrivacySettingsBloc>().add(UpdateBooleanSetting(
                      key: 'show_lingo_modal', value: value));
                }),
                _buildSwitchSetting(
                    'Private Account',
                    'private_account',
                    privateAccount,
                    isLoading && loadingKey == 'private_account', (value) {
                  context.read<PrivacySettingsBloc>().add(UpdateBooleanSetting(
                      key: 'private_account', value: value));
                }),
                SizedBox(height: 20),
                Text(
                  'Who Can See My Posts',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                _buildVisibilityRadio(
                    'Everyone',
                    'everyone',
                    'who_can_see_my_post',
                    postVisibility,
                    isLoading && loadingKey == 'who_can_see_my_post', (value) {
                  if (value != null) {
                    context.read<PrivacySettingsBloc>().add(
                        UpdateVisibilitySetting(
                            key: 'who_can_see_my_post', value: value));
                  }
                }),
                _buildVisibilityRadio(
                    'People I Clapped',
                    'people_i_clapped',
                    'who_can_see_my_post',
                    postVisibility,
                    isLoading && loadingKey == 'who_can_see_my_post', (value) {
                  if (value != null) {
                    context.read<PrivacySettingsBloc>().add(
                        UpdateVisibilitySetting(
                            key: 'who_can_see_my_post', value: value));
                  }
                }),
                _buildVisibilityRadio(
                    'People Who Clapped Me',
                    'people_who_clapped_me',
                    'who_can_see_my_post',
                    postVisibility,
                    isLoading && loadingKey == 'who_can_see_my_post', (value) {
                  if (value != null) {
                    context.read<PrivacySettingsBloc>().add(
                        UpdateVisibilitySetting(
                            key: 'who_can_see_my_post', value: value));
                  }
                }),
                _buildVisibilityRadio(
                    'None',
                    'none',
                    'who_can_see_my_post',
                    postVisibility,
                    isLoading && loadingKey == 'who_can_see_my_post', (value) {
                  if (value != null) {
                    context.read<PrivacySettingsBloc>().add(
                        UpdateVisibilitySetting(
                            key: 'who_can_see_my_post', value: value));
                  }
                }),
                SizedBox(height: 20),
                Text(
                  'Who Can View My Stories',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                _buildVisibilityRadio(
                    'Everyone',
                    'everyone',
                    'who_can_view_my_stories',
                    storyVisibility,
                    isLoading && loadingKey == 'who_can_view_my_stories',
                    (value) {
                  if (value != null) {
                    context.read<PrivacySettingsBloc>().add(
                        UpdateVisibilitySetting(
                            key: 'who_can_view_my_stories', value: value));
                  }
                }),
                _buildVisibilityRadio(
                    'People I Clapped',
                    'people_i_clapped',
                    'who_can_view_my_stories',
                    storyVisibility,
                    isLoading && loadingKey == 'who_can_view_my_stories',
                    (value) {
                  if (value != null) {
                    context.read<PrivacySettingsBloc>().add(
                        UpdateVisibilitySetting(
                            key: 'who_can_view_my_stories', value: value));
                  }
                }),
                _buildVisibilityRadio(
                    'People Who Clapped Me',
                    'people_who_clapped_me',
                    'who_can_view_my_stories',
                    storyVisibility,
                    isLoading && loadingKey == 'who_can_view_my_stories',
                    (value) {
                  if (value != null) {
                    context.read<PrivacySettingsBloc>().add(
                        UpdateVisibilitySetting(
                            key: 'who_can_view_my_stories', value: value));
                  }
                }),
                _buildVisibilityRadio(
                    'None',
                    'none',
                    'who_can_view_my_stories',
                    storyVisibility,
                    isLoading && loadingKey == 'who_can_view_my_stories',
                    (value) {
                  if (value != null) {
                    context.read<PrivacySettingsBloc>().add(
                        UpdateVisibilitySetting(
                            key: 'who_can_view_my_stories', value: value));
                  }
                }),
              ],
            ),
          );
        },
      ),
    );
  }

  // Update helper methods to accept loading state and key
  Widget _buildSwitchSetting(String title, String key, bool value,
      bool isLoading, Function(bool) onChanged) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: isLoading
          ? null
          : onChanged, // Disable switch while loading this specific setting
      secondary: isLoading
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2))
          : null,
    );
  }

  Widget _buildVisibilityRadio(String title, String value, String key,
      String groupValue, bool isLoading, Function(String?) onChanged) {
    return ListTile(
      title: Text(title),
      trailing: isLoading
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2))
          : Radio(
              value: value,
              groupValue: groupValue,
              onChanged: isLoading
                  ? null
                  : onChanged, // Disable radio while loading this group
            ),
      onTap: isLoading ? null : () => onChanged(value),
    );
  }
}

// Remove helper extension if not used
// extension BlocAccess on BuildContext {
//   PrivacySettingsBloc get privacySettingsBloc => read<PrivacySettingsBloc>();
// }
