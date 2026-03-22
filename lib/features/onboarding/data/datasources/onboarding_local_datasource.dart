import 'package:clapmi/core/db/app_preference_service.dart';

abstract class OnboardingLocalDatasource {}

class OnboardingLocalDatasourceImpl implements OnboardingLocalDatasource {
  OnboardingLocalDatasourceImpl({required this.appPreferenceService});
  final AppPreferenceService appPreferenceService;
}
