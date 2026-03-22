import 'package:clapmi/core/api/clapmi_network_client.dart';
import 'package:clapmi/core/constants/endpoint_constant.dart';
import 'package:clapmi/core/db/app_preference_service.dart';
import 'package:clapmi/features/brag/data/models/brag_challengers.dart';
import 'package:clapmi/features/brag/data/models/post_model.dart';
import 'package:clapmi/features/post/data/models/avatar_model.dart';
import 'package:clapmi/features/post/data/models/create_combo_model.dart';
import 'package:clapmi/features/post/data/models/create_post_model.dart';
import "package:dio/dio.dart" as dio;
import 'package:dio/dio.dart';

abstract class BragRemoteDatasource {
  Future<CreatePostModel> createPost({required CreatePostModel postModel});
  Future<String> challengePost({required String postID});
  Future<String> singlechallengeLiveStream({required String bragID});

  Future<String> createCombo(
      {required CreateComboModel comboModel, required bool isSingleLiveStream});

  Future<List<AvatarModel>> getAvatars();
  Future<String> commentOnAPost({
    required String postID,
    required String comment,
  });

  Future<List<BragChallengersModel>> getlistofBragchallengers({
    required String postId,
    required String contextType,
    required String list,
    required String status,
  });

  Future<List<SingleLiveStreamBragChallengerModel>>
      getlistofSingleBragchallengers(
          {required String contextType,
          required String list,
          required String status,
          required String brags});
  Future<SingleVideoPostModel> getSinglePost({required String postId});

  Future<String> acceptChallenge({required String challengeId});
  Future<String> declineChallenge({required String challengeId});
  Future<String> singleLiveacceptChallenge({required String challengeId});
  Future<String> singleLivedeclineChallenge({required String challengeId});
  Future<String> boostPoints(
      {required int boostPoint, required String challengeId});
}

class BragRemoteDatasourceImpl implements BragRemoteDatasource {
  BragRemoteDatasourceImpl({
    required this.networkClient,
    required this.appPreferenceService,
  });
  final AppPreferenceService appPreferenceService;

  final ClapMiNetworkClient networkClient;

  @override
  Future<CreatePostModel> createPost(
      {required CreatePostModel postModel}) async {
    print("debug_print_createPost-started");
    Map data = (postModel.toJson());
    print("debug_print_createPost-inputed_data $data");
    List<dio.MultipartFile> formattedListOfFiles = [];
    if ((data["images"] as List<String>?)?.isNotEmpty ?? false) {
      for (String e in data["images"]) {
        formattedListOfFiles.add(
          await dio.MultipartFile.fromFile(e,
              filename: e.split("/").lastOrNull),
        );
      }
    }
    data["images"] = formattedListOfFiles.firstOrNull;
    data = {
      "content": data['content'],
      "images": data['images'],
    };
    dio.FormData formData = dio.FormData.fromMap({...data});
    final response = await networkClient.post(
      endpoint: EndpointConstant.createPost,
      isAuthHeaderRequired: true,
      options: Options(headers: {
        "Content-Type":
            "multipart/form-data; boundary=--------------------------660649622858918291819953",
        "Accept": "application/json"
      }),
      data: formData,
    );
    print("debug_print_createPost-result_fetched${[
      response.data,
      response.message
    ]}");
    return CreatePostModel.fromJson(response.data);
  }

  @override
  Future<String> challengePost({required String postID}) async {
    try {
      final response = await networkClient.post(
        endpoint: EndpointConstant.challengeSomething,
        isAuthHeaderRequired: true,
        data: {
          /// Yes i know it is wierd [just checking]
          "brag": postID,
        },
      );
      print("debug_print_createPost-result_fetched${[
        response.data,
        response.message
      ]}");
      return response.data["challenge"];
    } catch (e) {
      throw Exception("This is error: ${e.toString()}");
    }
  }

  @override
  Future<String> singlechallengeLiveStream({required String bragID}) async {
    try {
      final response = await networkClient.post(
        endpoint: EndpointConstant.challengeSingleLive,
        isAuthHeaderRequired: true,
        data: {
          /// Yes i know it is wierd [just checking]
          "brag": bragID,
          "context_type": "live",
        },
      );
      print("debug_print_createPost-result_fetched${[
        response.data,
        response.message
      ]}");
      return response.data["challenge"];
    } catch (e) {
      throw Exception("This is error: ${e.toString()}");
    }
  }

  @override
  Future<String> createCombo(
      {required CreateComboModel comboModel,
      required bool isSingleLiveStream}) async {
    final response = await networkClient.post(
        endpoint: EndpointConstant.createCombo,
        isAuthHeaderRequired: true,
        data:

            //  {
            //   'type': comboModel.type,
            //   'title': comboModel.title,
            //   'duration': comboModel.duration,
            //   'context_type': comboModel.contextType,
            // },

            comboModel.toCreateMap());
    print("debug_print_createPost-result_fetched${[
      response.data,
      response.message
    ]}");
    if (isSingleLiveStream) {
      return response.data['combo'] as String;
    } else {
      return response.message;
    }
  }

  @override
  Future<List<AvatarModel>> getAvatars() async {
    final response = await networkClient.get(
      endpoint: EndpointConstant.getAvatars,
      isAuthHeaderRequired: true,
    );

    List<AvatarModel> result = [
      ...((response).data as List).map(
        (e) => AvatarModel.fromjson(e),
      )
    ];

    return result;
  }

  @override
  Future<String> commentOnAPost(
      {required String postID, required String comment}) async {
    final response = await networkClient.post(
        endpoint: EndpointConstant.commentOnAPost,
        isAuthHeaderRequired: true,
        data: {
          "post": postID,
          "comment": comment,
        });
    print("debug_print_commentOnAPost-result_fetched${[
      response.data,
      response.message
    ]}");

    return response.message;
  }

  @override
  Future<List<BragChallengersModel>> getlistofBragchallengers({
    required String postId,
    required String contextType,
    required String list,
    required String status,
  }) async {
    print(
        "666666666666666666666666666666666666666666666^^^^^^^^^^^^^^^^^^^^^^^^^^^^$postId");
    try {
      final response = await networkClient.get(
        endpoint:
            '${EndpointConstant.getListofBragchallenger}$postId/challenges?context_type=$contextType&list=$list&status=$status',
        isAuthHeaderRequired: true,
      );
      print(
          "----------------------------------------BRAG CHALLENGERS RESPONSE---------------------------------${response.data}");
      List resultList = response.data['challenges'];
      print(
          "-----------------------------------BRAG CHALLENGERS RESPONSE CONVERTED DATA-----------------------------------------------$resultList");
      List<BragChallengersModel> result = resultList
          .map((bragChallenger) => BragChallengersModel.fromMap(bragChallenger))
          .toList();
      return result;
    } catch (e) {
      throw Exception("Checking the error of the work ${e.toString()}");
    }
  }

  @override
  Future<List<SingleLiveStreamBragChallengerModel>>
      getlistofSingleBragchallengers(
          {required String contextType,
          required String brags,
          required String list,
          required String status}) async {
    try {
      final response = await networkClient.get(
        endpoint:
            '${EndpointConstant.getListofBragchallenger}$brags/challenges?context_type=$contextType&list=$list&status=$status',
        isAuthHeaderRequired: true,
      );
      print(
          "----------------------------------------BRAG CHALLENGERS RESPONSE---------------------------------${response.data}");
      List resultList = response.data['challenges'];
      print(
          "-----------------------------------BRAG CHALLENGERS RESPONSE CONVERTED DATA-----------------------------------------------$resultList");
      List<SingleLiveStreamBragChallengerModel> result = resultList
          .map((singleBragChallenger) =>
              SingleLiveStreamBragChallengerModel.fromJson(
                  singleBragChallenger))
          .toList();
      return result;
    } catch (e) {
      throw Exception("Checking the error of the work ${e.toString()}");
    }
  }

  @override
  Future<SingleVideoPostModel> getSinglePost({required String postId}) async {
    try {
      final response = await networkClient.get(
        endpoint: "${EndpointConstant.getSinglePost}/$postId",
        isAuthHeaderRequired: true,
      );
      final post = SingleVideoPostModel.fromMap(response.data);
      return post;
    } catch (e) {
      throw Exception("There is an internal error: ${e.toString()}");
    }
  }

  @override
  Future<String> acceptChallenge({required String challengeId}) async {
    final response = await networkClient.post(
      endpoint: EndpointConstant.acceptChallenge,
      isAuthHeaderRequired: true,
      data: {
        "challenge": challengeId,
      },
    );
    return response.message;
  }

  @override
  Future<String> declineChallenge({required String challengeId}) async {
    final response = await networkClient.post(
      endpoint: EndpointConstant.declineChallenge,
      isAuthHeaderRequired: true,
      data: {
        "challenge": challengeId,
      },
    );
    return response.message;
  }

  @override
  Future<String> singleLiveacceptChallenge(
      {required String challengeId}) async {
    final response = await networkClient.post(
      endpoint: EndpointConstant.singleLiveacceptChallenge,
      isAuthHeaderRequired: true,
      data: {
        "challenge": challengeId,
      },
    );
    print("----------$response");
    return response.message;
  }

  @override
  Future<String> singleLivedeclineChallenge(
      {required String challengeId}) async {
    final response = await networkClient.post(
      endpoint: EndpointConstant.singleLivedeclineChallenge,
      isAuthHeaderRequired: true,
      data: {
        "challenge": challengeId,
      },
    );
    return response.message;
  }

  @override
  Future<String> boostPoints(
      {required int boostPoint, required String challengeId}) async {
    final response = await networkClient.patch(
        endpoint:
            '${EndpointConstant.getListofBragchallenger}$challengeId/challenge',
        isAuthHeaderRequired: true,
        data: {
          "action": "boost",
          "boost-points": boostPoint,
        });
    return response.message;
  }
}
