import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:clapmi/core/api/clapmi_network_client.dart';
import 'package:clapmi/core/app_variables.dart';
import 'package:clapmi/core/constants/endpoint_constant.dart';
import 'package:clapmi/core/db/app_preference_service.dart';
import 'package:clapmi/features/post/data/models/avatar_model.dart';
import 'package:clapmi/features/post/data/models/category_model.dart';
import 'package:clapmi/features/post/data/models/create_combo_model.dart';
import 'package:clapmi/features/post/data/models/create_post_model.dart';
import 'package:clapmi/features/post/data/models/create_video_post_model.dart';
import 'package:clapmi/features/post/data/models/edit_post_model.dart';
import 'package:clapmi/features/post/data/models/post_model.dart'; // Import the new PostModel
import 'package:clapmi/features/post/data/models/video_url_model.dart';
import 'package:clapmi/features/post/domain/entities/category_entity.dart';
import 'package:clapmi/features/post/domain/entities/create_video_post_entity.dart';
import "package:dio/dio.dart" as dio;
import 'package:dio/dio.dart';
import 'package:path/path.dart' as p;
import 'package:video_thumbnail/video_thumbnail.dart';

abstract class PostRemoteDatasource {
  Future<String> createPost({required CreatePostModel postModel});
  Future<List<CategoryEntity>> getCategories();

  Future<String> challengePost({required String postID});
  Future<String> acceptChallenge({required String postID});

  Future<String> createCombo({required CreateComboModel comboModel});
  Future<String> editPost({required EditPostContentModel editPost});
  Future<String> singlecreateCombo(
      {required SingleLiveCreateModel singlecomboModel});
  Future<List<AvatarModel>> getAvatars();
  Future<List<PostModel>> getAllPosts(
      {required int index, required bool isRefresh}); // Updated return type
  Future<List<PostModel>> getAllVideoPosts(
      {required int index, required bool isRefresh}); // Updated return type
  Future<List<PostModel>> getFollowersPost();
  Future<List<PostModel>> getUserPosts(String uid);
  Future<PostModel> getSinglePost(
      {required String postId}); // Updated return type
  Future<String> clapAPost({
    required String postID,
  }); // Updated return type
  Future<String> notInterestedInAPost({
    required String postID,
  }); // Updated return type
  Future<String> commentOnAPost({
    required String postID,
    required String comment,
  });
  // Add unclap method signature
  Future<String> unclapAPost({
    required String postID,
  });
  // Abstract method to save a post
  Future<String> savePost({required String postID});
  // Abstract method to share a post
  Future<String> sharePost({required String postID});
  Future<String> createVideoPost(
      {required CreateVideoPostEntity createVideoPostEntity});
  // Future<VideoUrlModel> uploadUrl({required Map<String, dynamic> cred});

  Future<(List<VideoPostModel>, List<String>)> getClapmiVideos(
      {required int index});
  Future<String> delUser({String postDeleted});
}

class PostRemoteDatasourceImpl implements PostRemoteDatasource {
  PostRemoteDatasourceImpl({
    required this.networkClient,
    required this.appPreferenceService,
  });
  final AppPreferenceService appPreferenceService;

  final ClapMiNetworkClient networkClient;

  List<PostModel> cachedVideoPost = [];
  List<PostModel> cachedNormalPost = [];

  @override
  Future<String> createPost({required CreatePostModel postModel}) async {
    Map data = (postModel.toJson());
    dio.MultipartFile? imageFile;
    List<dio.MultipartFile> listOfImageFiles = [];

    if ((data["images"] as List<String>?)?.isNotEmpty ?? false) {
      for (String imagePath in data["images"]) {
        // String imagePath = (data["images"] as List<String>).first;
        listOfImageFiles.add(await dio.MultipartFile.fromFile(
          imagePath,
          filename: imagePath.split("/").lastOrNull,
        ));
      }
    }

    final finalData = {
      "content": data['content'],
      "who_can_see_this_post":
          data['who_can_see_this_post'].toString().toLowerCase()
    };
    if (listOfImageFiles.isNotEmpty) {
      finalData["images[]"] = listOfImageFiles;
    }
    dio.FormData formData = dio.FormData.fromMap({...finalData});

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
    return response.message;
    // CreatePostModel.fromJson(response.data);
  }

  @override
  Future<String> challengePost({required String postID}) async {
    final response = await networkClient.post(
      endpoint: EndpointConstant.challengeSomething,
      isAuthHeaderRequired: true,
      data: {
        /// Yes i know it is wierd [just checking]
        "brag": postID,
      },
    );

    return response.message;
  }

  @override
  Future<String> createCombo({required CreateComboModel comboModel}) async {
    final response = await networkClient.post(
        endpoint: EndpointConstant.createCombo,
        isAuthHeaderRequired: true,
        data: comboModel.toCreateMap());
    return response.message;
  }

  @override
  Future<String> editPost({
    required EditPostContentModel editPost,
  }) async {
    final response = await networkClient.patch(
      endpoint: '${EndpointConstant.editPost}/${editPost.postId}',
      isAuthHeaderRequired: true,
      data: EditPostContentModel.fromEntity(editPost).toJson(),
    );

    return response.message;
  }

  @override
  Future<String> delUser({String? postDeleted}) async {
    if (postDeleted == null || postDeleted.isEmpty) {
      throw ArgumentError('Post ID is required for deletion');
    }

    final result = await networkClient.delete(
      endpoint: '${EndpointConstant.delPost}/$postDeleted',
      isAuthHeaderRequired: true,
    );
    return result.message;
  }

  @override
  Future<String> singlecreateCombo(
      {required SingleLiveCreateModel singlecomboModel}) async {
    final response = await networkClient.post(
        endpoint: EndpointConstant.singlecreateCombo,
        isAuthHeaderRequired: true,
        data: singlecomboModel.toJson());
    return response.message;
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

    return response.message;
  }

  @override
  Future<List<PostModel>> getAllPosts(
      {required int index, required bool isRefresh}) async {
    print(
        "--------------------------------sdjbdkjsbdjsbdjsd-getAllPosts-started----------");
    final response = await networkClient.get(
      endpoint: '${EndpointConstant.getAllPosts}?page=$index',
      isAuthHeaderRequired: true,
    );
    print("sdjbdkjsbdjsbdjsd-getAllPosts-1111");
    if (isRefresh) {
      cachedVideoPost = [];
      cachedNormalPost = [];
    }
    // Check if the data is in the expected format
    if (response.data['posts'] is List) {
      final List<dynamic> rawPosts = response.data['posts'];
      //First get the videoPosts
      List<PostModel> videoPosts = rawPosts
          .map((post) => PostModel.fromJson(post as Map<String, dynamic>))
          .where((post) =>
              post.type == PostType.video && post.type != PostType.unknown)
          .cast<PostModel>()
          .toList();
      cachedVideoPost.addAll(videoPosts);
      // Parse the list of posts, filtering out unknown/video types
      final List<PostModel> posts = rawPosts
          .map((post) => PostModel.fromJson(post as Map<String, dynamic>))
          .where((post) =>
              post.type != PostType.video && post.type != PostType.unknown)
          .cast<PostModel>()
          .toList();
      cachedNormalPost.addAll(posts);

      return cachedNormalPost;
    }
    return cachedNormalPost;
  }

  @override
  Future<String> clapAPost({required String postID}) async {
    final response = await networkClient.post(
      endpoint: EndpointConstant.clapAPost,
      isAuthHeaderRequired: true,
      data: {
        "post": postID,
      },
    );
    print('------${response.message}');
    return response.message;
  }

  @override
  Future<String> notInterestedInAPost({required String postID}) async {
    final response = await networkClient.post(
      endpoint: EndpointConstant.notInterestedInPost,
      isAuthHeaderRequired: true,
      data: {
        "post": postID,
      },
    );

    return response.message;
  }

  @override
  Future<PostModel> getSinglePost({required String postId}) async {
    final response = await networkClient.get(
      endpoint: "${EndpointConstant.getSinglePost}/$postId",
      isAuthHeaderRequired: true,
    );
    Map data = response.data;
    data["post"] = postId;
    final post = PostModel.fromJson({...data});
    return post;
  }

  // Implement unclap method
  @override
  Future<String> unclapAPost({required String postID}) async {
    final response = await networkClient.post(
      endpoint: EndpointConstant.unclapAPost, // Use the new endpoint
      isAuthHeaderRequired: true,
      data: {
        "post": postID,
      },
    );
    log("Unclap post => Success ${response.success} => ${response.message}");
    return response.message;
  }

  @override
  Future<String> savePost({required String postID}) async {
    final response = await networkClient.post(
      endpoint: EndpointConstant.savePost,
      isAuthHeaderRequired: true,
      data: {
        "post": postID,
      },
    );
    log("Save post => Success ${response.success} => ${response.message}");
    return response.message;
  }

  @override
  Future<String> sharePost({required String postID}) async {
    final response = await networkClient.post(
      endpoint: EndpointConstant.sharePost,
      isAuthHeaderRequired: true,
      data: {
        "post": postID,
      },
    );
    log("Share post => Success ${response.success} => ${response.message}");
    return response.message;
  }

  @override
  Future<List<CategoryEntity>> getCategories() async {
    final response = await networkClient.get(
      endpoint: EndpointConstant.getCategories, // Use the new endpoint
      isAuthHeaderRequired: true,
    );
    final result = (response.data as List?)?.map(
          (e) {
            return CategoryModel.fromjson(e);
          },
        ).toList() ??
        [];
    return result;
  }

  //**DIFFERENT PROCESSES INVOLVED IN GETTING THIS THING DONE */
  //**IN CREATING A VIDEO POST */
  //**GENERATION OF THUMBNAIL FROM THE VIDEO FILE TO BE UPLOADED */
  //**GENERATING A LINK TO UPLOAD THE THUMBNAIL, UPLOAD THE VIDEO TO THE THIRD PARTY SERVICE*/
  //**GENERATING A LINK TO UPLOAD THE VIDEO AND ALSO UPLOAD THE VIDEO VIA THE LINK */
  //**CREATE A VIDEO POST USING THE GENERATED DATA */
  @override
  Future<String> createVideoPost(
      {required CreateVideoPostEntity createVideoPostEntity}) async {
    VideoUrlModel? videoData;
    print("bjdkfbjdkfbdsjfjb=>11111");

    //**GENERATE THE VIDEO THUMBNAIL */
    final thumbnailFile =
        await generateThumbnail(videoPath: createVideoPostEntity.video!.path);
    print("bjdkfbjdkfbdsjfjb=>2222");
    //**GENERATE SIGNED LINK FOR THUMBNAIL UPLOADING */
    final thumbnailData = await uploadUrl(cred: {
      'filename': p.basename(thumbnailFile!.path),
      'path': p.basenameWithoutExtension(thumbnailFile.path),
      'content_type': 'image/jpeg',
    });
    // thumbnailFile.openRead();
    print("bjdkfbjdkfbdsjfjb=>3333");
    //**UPLOAD THE THUMBNAIL FILE TO THE GENERATED SIGNED LINK */
    final uplaodImage = await networkClient.put(
        endpoint: thumbnailData.url ?? '',
        data: thumbnailFile.openRead(),
        options: Options(contentType: 'image/jpeg', headers: {
          'x-amz-acl': 'public-read',
          'content_type': 'image/jpeg',
          'content-Length': thumbnailFile.lengthSync().toString(),
        }),
        onSendProgress: (sent, total) {
          progressUpdate.add(sent / total);
          print('Uploading....${((sent / total) * 100).toStringAsFixed(0)}%');
        });
    print("bjdkfbjdkfbdsjfjb=>4444");

    //**HAVING UPLOADED THE THUMBNAIL TO THE SIGNED LINK, THEN GENERATE LINK FOR THE VIDEOFILE*/
    print("bjdkfbjdkfbdsjfjb=>${createVideoPostEntity.video!.path}");
    if (uplaodImage == 200) {
      print("bjdkfbjdkfbdsjfjb=>4444aaaaa");
      videoData = await uploadUrl(cred: {
        'filename': p.basename(
          createVideoPostEntity.video!.path,
        ),
        'path': p.basenameWithoutExtension(createVideoPostEntity.video!.path),
        'content_type': 'video/mp4',
      });
      print("bjdkfbjdkfbdsjfjb=>4444bbbbb");
    }
    print("bjdkfbjdkfbdsjfjb=>5555");
    //**UPLOAD THE VIDEO FILE TO THE GENERATED SIGNED-LINK */
    final responseUpload = await networkClient.put(
        endpoint: videoData?.url ?? '',
        data: createVideoPostEntity.video?.openRead(),
        options: Options(
          contentType: 'video/mp4',
          headers: {
            'x-amz-acl': 'public-read',
            'content_type': 'video/mp4',
            'content-Length':
                createVideoPostEntity.video?.lengthSync().toString(),
          },
        ),
        onSendProgress: (sent, total) {
          progressUpdate.add(sent / total);
          print('Uploading....${((sent / total) * 100).toStringAsFixed(0)}%');
        });
    print("bjdkfbjdkfbdsjfjb=>6666");
    //**CREATE A VIDEO POST WHICH WILL BOTH INCLUDE THE THUMBNAIL PATH AND THE VIDEO PATH */
    if (responseUpload == 200) {
      print("bjdkfbjdkfbdsjfjb=>6666-aaaaa");
      final response = await networkClient.post(
          endpoint: EndpointConstant.createVideoPost,
          isAuthHeaderRequired: true,
          data: {
            'title': createVideoPostEntity.description,
            //'Sasuke vs Naruto Epic Fight',
            'tags': createVideoPostEntity.tags,
            'category': createVideoPostEntity.category,
            'description': createVideoPostEntity.description,
            'video': videoData?.path,
            'thumbnail': thumbnailData.path,
          });
      print("bjdkfbjdkfbdsjfjb=>6666-bbbbb");
      return response.message;
    } else {
      return '';
    }
  }

  @override
  Future<List<PostModel>> getAllVideoPosts(
      {required int index, required bool isRefresh}) async {
    final response = await networkClient.get(
      endpoint: "${EndpointConstant.getAllVideoPosts}?page=$index",
      isAuthHeaderRequired: true,
    );

    if (isRefresh) {
      cachedNormalPost = [];
      cachedVideoPost = [];
    }
    // Check if the data is in the expected format
    if (response.data['posts'] is List) {
      final List<dynamic> rawPosts = response.data['posts'];
      //First get the videoPosts
      List<PostModel> videoPosts = rawPosts
          .map((post) => PostModel.fromJson(post as Map<String, dynamic>))
          .where((post) =>
              post.type == PostType.video && post.type != PostType.unknown)
          .cast<PostModel>()
          .toList();
      cachedVideoPost.addAll(videoPosts);
      // Parse the list of posts, filtering out unknown/video types
      final List<PostModel> posts = rawPosts
          .map((post) => PostModel.fromJson(post as Map<String, dynamic>))
          .where((post) =>
              post.type != PostType.video && post.type != PostType.unknown)
          .cast<PostModel>()
          .toList();
      cachedNormalPost.addAll(posts);
    }
    print("sdkjdbksjadasdbdjsadksabj>>>${cachedVideoPost.map(
      (e) => e.videoUrls,
    )}");
    return cachedVideoPost;
  }

  @override
  Future<String> acceptChallenge({required String postID}) async {
    final response = await networkClient.post(
      endpoint: EndpointConstant.acceptChallenge,
      isAuthHeaderRequired: true,
      data: {
        "challenge": postID,
      },
    );
    return response.message;
  }

  @override
  Future<List<PostModel>> getUserPosts(String uid) async {
    final response = await networkClient.get(
      endpoint: "${EndpointConstant.getUserPosts}/$uid",
      isAuthHeaderRequired: true,
    );
    // Check if the data is in the expected format
    if (response.data is List) {
      final List<dynamic> rawPosts = response.data;
      // Parse the list of posts, filtering out unknown/video types
      final List<PostModel> posts = rawPosts
          .map((postJson) {
            try {
              PostModel postModel =
                  PostModel.fromJson(postJson as Map<String, dynamic>);
              return postModel;
            } catch (e) {
              return null; // Return null for posts that fail parsing
            }
          })
          .where((post) =>
              post != null &&
              // post.type == PostType.video &&
              post.type !=
                  PostType.unknown) // Filter out nulls, videos, and unknowns
          .cast<PostModel>() // Cast to the correct type
          .toList();
      return posts;
    } else {
      // Throw an exception or return an empty list depending on desired error handling
      throw Exception('Failed to parse posts: Unexpected data format');
      // return [];
    }
  }

  @override
  Future<List<PostModel>> getFollowersPost() async {
    final response = await networkClient.get(
      endpoint: EndpointConstant.getFollowersPost,
      isAuthHeaderRequired: true,
    );
    // Check if the data is in the expected format
    if (response.data is List) {
      final List<dynamic> rawPosts = response.data;
      // Parse the list of posts, filtering out unknown/video types
      final List<PostModel> posts = rawPosts
          .map((postJson) {
            try {
              PostModel postModel =
                  PostModel.fromJson(postJson as Map<String, dynamic>);
              return postModel;
            } catch (e) {
              log('Error parsing post: $e\nJSON: $postJson');
              return null; // Return null for posts that fail parsing
            }
          })
          .where((post) =>
              post != null &&
              // post.type == PostType.video &&
              post.type !=
                  PostType.unknown) // Filter out nulls, videos, and unknowns
          .cast<PostModel>() // Cast to the correct type
          .toList();
      return posts;
    } else {
      // Throw an exception or return an empty list depending on desired error handling
      throw Exception('Failed to parse posts: Unexpected data format');
      // return [];
    }
  }

  Future<VideoUrlModel> uploadUrl({required Map<String, dynamic> cred}) async {
    final response = await networkClient.post(
      endpoint: EndpointConstant.uploadUrl,
      data: cred,
      isAuthHeaderRequired: true,
    );
    return VideoUrlModel.fromMap(response.data);
  }

  Future<File?> generateThumbnail({required String videoPath}) async {
    final thumbnail = await VideoThumbnail.thumbnailFile(
      video: videoPath, imageFormat: ImageFormat.JPEG, quality: 100,
      //  thumbnailPath: 'clapmi/thumbnails/',
    );
    if (thumbnail != null) {
      return File(safeDecodePath(thumbnail));
    } else {
      return null;
    }
  }

  String safeDecodePath(String path) {
    // Check if the path contains URL encoding patterns
    if (path.contains('%')) {
      try {
        String decoded = Uri.decodeComponent(path);
        // If decode succeeded and changed something, return it
        if (decoded != path) {
          return decoded;
        }
      } catch (e) {
        // If decoding fails, return original
        return path;
      }
    }
    // Return original if no encoding detected
    return path;
  }

  @override
  Future<(List<VideoPostModel>, List<String>)> getClapmiVideos(
      {required int index}) async {
    final response = await networkClient.get(
      endpoint: EndpointConstant.getAllVideoPosts,
      //"${EndpointConstant.getAllPosts}?page=$index",
      isAuthHeaderRequired: true,
    );
    final List<dynamic> rawPosts = response.data as List;
    //First get the videoPosts
    List<VideoPostModel> videoPosts = rawPosts
        .map((post) => VideoPostModel.fromMap(post as Map<String, dynamic>))
        .toList();
    // .where((post) =>
    //     post.type == PostType.video && post.type != PostType.unknown)
    // .cast<PostModel>()
    // .toList();

    final videoUrls = videoPosts.map((element) {
      return element.video ?? '';
    }).toList();
    print(
        "IS VIDEO AVAILABLE %%%%%%%%% ${videoPosts.isEmpty} &&&&&&&&& $videoUrls}");
    return (videoPosts, videoUrls);
  }
}
