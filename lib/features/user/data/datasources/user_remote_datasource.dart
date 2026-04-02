import 'package:clapmi/core/api/base_response.dart';
import 'package:clapmi/core/api/clapmi_network_client.dart';
import 'package:clapmi/core/constants/endpoint_constant.dart';
import 'package:clapmi/core/db/app_preference_service.dart';
import 'package:clapmi/features/user/data/models/creator_leaderboard_model.dart';
import 'package:clapmi/features/user/data/models/payment_grade_model.dart';
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
  Future<CreatorLeaderboardResponse> getCreatorLeaderboard(
      {String? levelName,
      int page = 1,
      String timeFilter = 'all',
      String? creator});
  Future<CreatorLevelsResponse> getCreatorLevels();
  Future<PaymentGradesResponse> getPaymentGrades();
  Future<BaseResponse> subscribeToGrade(String uuid);
}

class UserRemoteDatasourceImpl implements UserRemoteDatasource {
  UserRemoteDatasourceImpl({
    required this.networkClient,
    required this.appPreferenceService,
  });
  final AppPreferenceService appPreferenceService;

  final ClapMiNetworkClient networkClient;

  // Simple in-memory cache for payment grades
  PaymentGradesResponse? _cachedPaymentGrades;
  DateTime? _paymentGradesCacheTime;

  // Simple in-memory cache for creator levels
  CreatorLevelsResponse? _cachedCreatorLevels;
  DateTime? _creatorLevelsCacheTime;

  // Simple in-memory cache for creator leaderboard queries
  final Map<String, CreatorLeaderboardResponse> _cachedCreatorLeaderboard = {};
  final Map<String, DateTime> _creatorLeaderboardCacheTimes = {};

  static const _cacheDuration = Duration(minutes: 5); // Cache for 5 minutes

  // Check if cache is valid for payment grades
  bool get _isPaymentGradesCacheValid {
    if (_cachedPaymentGrades == null || _paymentGradesCacheTime == null) {
      return false;
    }
    return DateTime.now().difference(_paymentGradesCacheTime!) < _cacheDuration;
  }

  // Check if cache is valid for creator levels
  bool get _isCreatorLevelsCacheValid {
    if (_cachedCreatorLevels == null || _creatorLevelsCacheTime == null) {
      return false;
    }
    return DateTime.now().difference(_creatorLevelsCacheTime!) < _cacheDuration;
  }

  String _creatorLeaderboardCacheKey({
    String? levelName,
    required int page,
    required String timeFilter,
    String? creator,
  }) {
    return '${levelName ?? ''}|$page|$timeFilter|${creator ?? ''}';
  }

  bool _isCreatorLeaderboardCacheValid(String cacheKey) {
    final cachedResponse = _cachedCreatorLeaderboard[cacheKey];
    final cachedAt = _creatorLeaderboardCacheTimes[cacheKey];
    if (cachedResponse == null || cachedAt == null) {
      return false;
    }
    return DateTime.now().difference(cachedAt) < _cacheDuration;
  }

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
    // BaseResponse responseOne =
    //     BaseResponse(message: "null", success: 'false', data: null);
    // if (userDetails['profile_picture'] != null ||
    //     userDetails['banner'] != null) {
    //   responseOne = await _updateUserProfileImages(userDetails: userDetails);
    // }
    userDetails['dp'] = userDetails['profile_picture'];
    userDetails.remove('profile_picture');
    final responseTwo =
        await _updateOtherUserProfileDetails(userDetails: userDetails);
    // if (responseOne.message == "null") {
    //   //* It means there is no uploading of picture
    //   //* Proceed to update other details
    //   // if (responseTwo.success == "true") {
    //   print(
    //       "****************************************** ${responseTwo.message}");

    //   // }
    // } else {
    //   if (responseTwo.success == "true" && responseOne.success == "true") {
    //     print("****************************************** ${responseOne.data}");
    //     return responseOne.message;
    //   } else {
    //     return responseOne.message;
    //   }
    // }
    return responseTwo.message;
    // throw "An Error has occured";
  }

  Future<BaseResponse> _updateOtherUserProfileDetails(
      {required Map userDetails}) async {
    // userDetails.remove("banner");
    // userDetails.remove("profile_picture");

    final response = await networkClient.post(
      endpoint: EndpointConstant.updateUserDetails,
      isAuthHeaderRequired: true,
      data: userDetails,
    );
    return response;
  }

  Future<BaseResponse> _updateUserProfileImages(
      {required Map userDetails}) async {
    // print("debug_print_updateUser-_updateUserProfileImages-start");
    // print(
    //     "debug_print_updateUser-_updateUserProfileImages-before_userDetails_is_$userDetails ");
    dio.MultipartFile? profilePicture;
    try {
      // print(
      //     "debug_print_updateUser-_updateUserProfileImages-profile_picture_creation-start ");
      profilePicture = await dio.MultipartFile.fromFile(
          userDetails['profile_picture'],
          filename: (userDetails['profile_picture'].split("/") as List<String>)
              .lastOrNull);
    } catch (e) {}
    userDetails = {
      "profile_picture": profilePicture,
      "banner": await dio.MultipartFile.fromFile(userDetails['banner'],
          filename:
              (userDetails['banner'].split("/") as List<String>).lastOrNull),
    };
    // print(
    //     "debug_print_updateUser-_updateUserProfileImages-after_userDetails_is_$userDetails ");
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
    // print("debug_print_updateUser-_updateUserProfileImages-response_fetched ${[
    //   response.data,
    //   response.message,
    //   response.success,
    // ]}");
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
    //  print("debug_print-UserRemoteDatasourceImpl-getUserDetails-start");
    final response = await networkClient.get(
      endpoint: EndpointConstant.getUserDetails,
      isAuthHeaderRequired: true,
    );
    // print(
    //     "debug_print-UserRemoteDatasourceImpl-getUserDetails-response.data_is_${response.data}");
    // print(
    //     "debug_print-UserRemoteDatasourceImpl-getUserDetails-response.data['user']_is_${response.data["user"]}");
    final user = UserModel.fromJson(response.data["user"]);

    return user;
  }

  @override
  Future<CreatorLeaderboardResponse> getCreatorLeaderboard({
    String? levelName,
    int page = 1,
    String timeFilter = 'all',
    String? creator,
  }) async {
    final cacheKey = _creatorLeaderboardCacheKey(
      levelName: levelName,
      page: page,
      timeFilter: timeFilter,
      creator: creator,
    );

    if (_isCreatorLeaderboardCacheValid(cacheKey)) {
      return _cachedCreatorLeaderboard[cacheKey]!;
    }

    final response = await networkClient.get(
      endpoint: EndpointConstant.getCreatorLeaderboard,
      isAuthHeaderRequired: true,
      params: {
        if (levelName != null) 'level_name': levelName,
        'page': page,
        if (timeFilter != 'all') 'time_filter': timeFilter,
        if (creator != null) 'creator': creator,
      },
    );

    // The API response structure is: {rankings: [...], pagination: {...}}
    // NOT {message: "...", success: true, data: {rankings: [...], pagination: {...}}}
    // So we need to construct the response manually
    final json = response.data as Map<String, dynamic>;
    final result = CreatorLeaderboardResponse(
      message: 'Creator leaderboard fetched successfully',
      success: true,
      data: CreatorLeaderboardData(
        rankings: (json['rankings'] as List<dynamic>?)
                ?.map((e) =>
                    CreatorRankingModel.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        pagination: PaginationInfo.fromJson(json['pagination'] ?? {}),
      ),
    );

    _cachedCreatorLeaderboard[cacheKey] = result;
    _creatorLeaderboardCacheTimes[cacheKey] = DateTime.now();

    return result;
  }

  @override
  Future<CreatorLevelsResponse> getCreatorLevels() async {
    // Return cached data if available and valid
    if (_isCreatorLevelsCacheValid) {
      return _cachedCreatorLevels!;
    }

    final response = await networkClient.get(
      endpoint: EndpointConstant.getCreatorLevels,
      isAuthHeaderRequired: true,
    );

    final json = response.data as Map<String, dynamic>;

    // Cache the response
    _cachedCreatorLevels = CreatorLevelsResponse.fromJson(json);
    _creatorLevelsCacheTime = DateTime.now();

    return _cachedCreatorLevels!;
  }

  // Method to clear creator levels cache
  void clearCreatorLevelsCache() {
    _cachedCreatorLevels = null;
    _creatorLevelsCacheTime = null;
  }

  void clearCreatorLeaderboardCache() {
    _cachedCreatorLeaderboard.clear();
    _creatorLeaderboardCacheTimes.clear();
  }

  // Clear all caches
  void clearAllCaches() {
    clearPaymentGradesCache();
    clearCreatorLevelsCache();
    clearCreatorLeaderboardCache();
  }

  @override
  Future<PaymentGradesResponse> getPaymentGrades() async {
    // Return cached data if available and valid
    if (_isPaymentGradesCacheValid) {
      return _cachedPaymentGrades!;
    }

    final response = await networkClient.get(
      endpoint: EndpointConstant.paymentGrades,
      isAuthHeaderRequired: true,
    );

    final json = response.data as Map<String, dynamic>;

    // Cache the response
    _cachedPaymentGrades = PaymentGradesResponse.fromJson(json);
    _paymentGradesCacheTime = DateTime.now();

    return _cachedPaymentGrades!;
  }

  // Method to clear cache (useful after subscription)
  void clearPaymentGradesCache() {
    _cachedPaymentGrades = null;
    _paymentGradesCacheTime = null;
  }

  @override
  Future<BaseResponse> subscribeToGrade(String uuid) async {
    // Construct the endpoint: /creators/{uuid}/subscribe
    final endpoint = '/creators/$uuid/subscribe';

    try {
      // ClapMiNetworkClient.post already returns BaseResponse.fromJson(response)
      // So we can return it directly
      final response = await networkClient.post(
        endpoint: endpoint,
        isAuthHeaderRequired: true,
        data: {},
      );

      // Clear caches after successful subscription to refresh data
      // Check if the response indicates success
      if (response.success == 'true') {
        clearAllCaches();
      }

      return response;
    } on dio.DioException catch (e) {
      // Handle DioException - extract error message from response
      final response = e.response;
      if (response?.data != null) {
        final data = response!.data;
        if (data is Map) {
          return BaseResponse(
            success: 'false',
            message: data['message'] ?? e.message ?? 'An error occurred',
            data: null,
          );
        }
      }
      return BaseResponse(
        success: 'false',
        message: e.message ?? 'An error occurred',
        data: null,
      );
    } catch (error) {
      return BaseResponse(
        success: 'false',
        message: error.toString(),
        data: null,
      );
    }
  }
}
