import 'package:clapmi/core/api/base_response.dart';
import 'package:clapmi/core/api/clapmi_network_client.dart';
import 'package:clapmi/core/constants/endpoint_constant.dart';
import 'package:clapmi/core/db/app_preference_service.dart';
import 'package:clapmi/features/user/data/models/user_model.dart';
import 'package:clapmi/features/user/domain/entities/user_entity.dart';
import "package:dio/dio.dart" as dio;

abstract class UserRemoteDatasource {
  Future<String> updatePassword({
    required String currentPassword,
    required String newPassword,
    required String passwordConfirmation,
  });
  Future<String> updateUser({
    required Map userDetails,
  });
  Future<String> deleteAccount({
    required String password,
  });
  Future<UserEntity> getUserDetails();
}

class UserRemoteDatasourceImpl implements UserRemoteDatasource {
  UserRemoteDatasourceImpl({
    required this.networkClient,
    required this.appPreferenceService,
  });
  final AppPreferenceService appPreferenceService;

  final ClapMiNetworkClient networkClient;

  @override
  Future<String> updatePassword(
      {required String currentPassword,
      required String newPassword,
      required String passwordConfirmation}) async {
    final response = await networkClient.post(
      endpoint: EndpointConstant.updatePassword,
      data: {
        'current_password': currentPassword,
        'password': newPassword,
        'password_confirmation': passwordConfirmation,
      },
    );
    return response.message;
  }

  @override
  Future<String> updateUser({
    required Map userDetails,
  }) async {
    BaseResponse responseOne =
        BaseResponse(message: "null", success: 'false', data: null);
    if (userDetails['profile_picture'] != null) {
      responseOne = await _updateUserProfileImages(userDetails: userDetails);
    }
    final responseTwo =
        await _updateOtherUserProfileDetails(userDetails: userDetails);
    if (responseOne.message == "null") {
      //* It means there is no uploading of picture
      //* Proceed to update other details
      // if (responseTwo.success == "true") {
      return responseTwo.message;
      // }
    } else {
      if (responseTwo.success == "true" && responseOne.success == "true") {
        return responseOne.message;
      } else {
        return responseOne.message;
      }
    }
    // throw "An Error has occured";
  }

  Future<BaseResponse> _updateOtherUserProfileDetails(
      {required Map userDetails}) async {
    userDetails.remove("banner");
    userDetails.remove("profile_picture");

    final response = await networkClient.post(
      endpoint: EndpointConstant.updateUserDetails,
      isAuthHeaderRequired: true,
      data: userDetails,
    );
    return response;
  }

  Future<BaseResponse> _updateUserProfileImages(
      {required Map userDetails}) async {
    print("debug_print_updateUser-_updateUserProfileImages-start");
    print(
        "debug_print_updateUser-_updateUserProfileImages-before_userDetails_is_$userDetails ");
    dio.MultipartFile? profilePicture;
    try {
      print(
          "debug_print_updateUser-_updateUserProfileImages-profile_picture_creation-start ");
      profilePicture = await dio.MultipartFile.fromFile(
          userDetails['profile_picture'],
          filename: (userDetails['profile_picture'].split("/") as List<String>)
              .lastOrNull);
      print(
          "debug_print_updateUser-_updateUserProfileImages-profile_picture_creation-success");
    } catch (e) {
      print(
          "debug_print_updateUser-_updateUserProfileImages-profile_picture_creation-failed_with_error $e");
    }
    userDetails = {
      "profile_picture": profilePicture,
      "banner": await dio.MultipartFile.fromFile(userDetails['banner'],
          filename:
              (userDetails['banner'].split("/") as List<String>).lastOrNull),
    };
    print(
        "debug_print_updateUser-_updateUserProfileImages-after_userDetails_is_$userDetails ");
    dio.FormData formData = dio.FormData.fromMap({...userDetails});
    final response = await networkClient.post(
        endpoint: EndpointConstant.buildProfile,
        isAuthHeaderRequired: true,
        options: dio.Options(headers: {
          "Content-Type":
              "multipart/form-data; boundary=--------------------------660649622858918291819953",
          "Accept": "application/json"
        }),
        data: formData);
    print("debug_print_updateUser-_updateUserProfileImages-response_fetched ${[
      response.data,
      response.message,
      response.success,
    ]}");
    return response;
  }

  @override
  Future<String> deleteAccount({
    required String password,
  }) async {
    final response = await networkClient.post(
      endpoint: EndpointConstant.deleteAccount,
      isAuthHeaderRequired: true,
      data: {"password": password},
    );
    return response.message;
  }

  @override
  Future<UserEntity> getUserDetails() async {
    print("debug_print-UserRemoteDatasourceImpl-getUserDetails-start");
    final response = await networkClient.get(
      endpoint: EndpointConstant.getUserDetails,
      isAuthHeaderRequired: true,
    );
    print(
        "debug_print-UserRemoteDatasourceImpl-getUserDetails-response.data_is_${response.data}");
    print(
        "debug_print-UserRemoteDatasourceImpl-getUserDetails-response.data['user']_is_${response.data["user"]}");
    final user = UserModel.fromJson(response.data["user"]);

    return user;
  }

  // @override
  // Future<UserEntity> getUserDetails({required String email}) async {
  //   final query = '''
  //   query getUserProfile(\$email: String!) {
  //     userProfile(email: \$email) {
  //       pid
  //       name
  //       email
  //       bio
  //       image
  //       created_at
  //     }
  //   }
  //   ''';
  //   final variables = {
  //     'email': email,
  //   };

  //   final response = await networkClient.post(
  //     endpoint: EndpointConstant.getUserProfile,
  //     data: {
  //       'query': query,
  //       'variables': variables,
  //     },
  //     isAuthHeaderRequired: true,
  //   );
  //   print("debug_print_getProfile-result_fetched${[
  //     response.data,
  //     response.message
  //   ]}");

  //   if (response.success == 'true' && response.data != null) {
  //     log("Profile response ${response.data}");
  //     final data = response.data['data']['userProfile'];
  //     return UserModel.fromJson(data);
  //   } else {
  //     // Handle error appropriately, maybe throw an exception
  //     throw Exception('Failed to load user profile');
  //   }
  // }
}
