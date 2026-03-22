import 'package:clapmi/core/api/clapmi_network_client.dart';
import 'package:clapmi/core/constants/endpoint_constant.dart';
import 'package:clapmi/features/onboarding/data/models/interest_category_model.dart';
import 'package:clapmi/features/onboarding/data/models/other_user_model.dart';
import 'package:clapmi/features/onboarding/domain/entities/interest_category_entity.dart';
import 'package:clapmi/features/onboarding/domain/entities/other_user_entity.dart';
import 'package:dio/dio.dart';

abstract class OnboardingRemoteDatasource {
  Future<List<InterestCategoryEntity>> loadInterests();
  Future<String> saveInterests({required List<String> interestIDs});
  Future<List<OtherUserEntity>> getRandomUserList();
  Future<String> sendClapRequestToUsers({required List<String> userPids});
}

class OnboardingRemoteDatasourceImpl implements OnboardingRemoteDatasource {
  OnboardingRemoteDatasourceImpl({required this.networkClient});
  final ClapMiNetworkClient networkClient;

  @override
  Future<List<InterestCategoryEntity>> loadInterests() async {
    final response = await networkClient.get(
      endpoint: EndpointConstant.loadInterests,
      isAuthHeaderRequired: true,
    );

    List<InterestCategoryModel> result = [
      ...((response).data as List).map(
        (e) => InterestCategoryModel.fromJson(e),
      )
    ];
    return result;
  }

  @override
  Future<String> saveInterests({required List<String> interestIDs}) async {
    final response = await networkClient.post(
        endpoint: EndpointConstant.saveInterests,
        isAuthHeaderRequired: true,
        data: {
          "interests": interestIDs,
        });

    return response.message;
  }

  @override
  Future<List<OtherUserEntity>> getRandomUserList() async {
    final response = await networkClient.get(
      endpoint: EndpointConstant.getRandomUserList,
      isAuthHeaderRequired: true,
    );

    List<OtherUserModel> result = [
      ...((response).data as List).map(
        (e) => OtherUserModel.fromJson(e),
      )
    ];

    return result;
  }

  @override
  Future<String> sendClapRequestToUsers(
      {required List<String> userPids}) async {
    final response = await networkClient.post(
        endpoint: EndpointConstant.sendClapRequests,
        isAuthHeaderRequired: true,
        options: Options(),
        data: {
          "users": userPids,
        });
    return response.message;
  }
}
