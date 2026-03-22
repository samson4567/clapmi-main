import 'dart:developer';
import 'package:clapmi/core/api/clapmi_network_client.dart';
import 'package:clapmi/core/constants/endpoint_constant.dart';
import 'package:clapmi/core/db/app_preference_service.dart';
import 'package:clapmi/features/app/data/models/user_model.dart';
import 'package:clapmi/features/user/data/models/user_model.dart';

abstract class AppRemoteDatasource {
  Future<UserModel> getUserProfile({required String userId});
  Future<ProfileModel> getMyProfile();
}

class AppRemoteDatasourceImpl implements AppRemoteDatasource {
  AppRemoteDatasourceImpl({
    required this.networkClient,
    required this.appPreferenceService,
  });
  final AppPreferenceService appPreferenceService;

  final ClapMiNetworkClient networkClient;

  @override
  Future<UserModel> getUserProfile({required String userId}) async {
    final response = await networkClient.get(
      endpoint: "${EndpointConstant.getUserProfile}/$userId",
      isAuthHeaderRequired: true,
    );
    print("debug_print_getProfile-result_fetched${[
      response.data,
      response.message
    ]}");

    if (response.success == 'true' || response.data != null) {
      log("Profile response ${response.data}");
      final data = response.data['userProfile'];
      return UserModel.fromJson(data);
    } else {
      // Handle error appropriately, maybe throw an exception
      throw Exception('Failed to load user profile');
    }
  }

  @override
  Future<ProfileModel> getMyProfile() async {
    print("---------This is call getMyProfile htthuwuhfu-----------------");
    try {
      final response = await networkClient.get(
          endpoint: EndpointConstant.getMyProfile, isAuthHeaderRequired: true);
      print("This is the response here ${response.data}");
      return ProfileModel.fromJson(
          response.data['user'] as Map<String, dynamic>);
    } catch (e) {
      print("An error coming from ${e.toString()}");
      rethrow;
    }
  }
}
