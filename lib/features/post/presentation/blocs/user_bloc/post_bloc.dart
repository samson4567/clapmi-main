import 'package:clapmi/core/app_variables.dart';
import 'package:clapmi/features/app/presentation/blocs/app/app_bloc.dart';
import 'package:clapmi/features/post/data/models/post_model.dart';
import 'package:clapmi/features/post/domain/repositories/post_repository.dart';
import 'package:clapmi/features/post/presentation/blocs/user_bloc/post_event.dart';
import 'package:clapmi/features/post/presentation/blocs/user_bloc/post_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository postRepository;
  final AppBloc appBloc;

  PostBloc({required this.appBloc, required this.postRepository})
      : super(PostInitial()) {
    on<SelectImageEvent>(_onSelectImageEvent);
    on<CreatePostEvent>(_onCreatePostEvent);
    on<ChallengePostEvent>(_onChallengePostEvent);
    on<CreateComboEvent>(_onCreateComboEvent);
    on<SingleCreateComboEvent>(_onSingleCreateComboEvent);
    on<GetAvatarEvent>(_onGetAvatarEvent);
    on<CommentOnAPostEvent>(_onCommentOnAPostEvent);
    on<ClapPostEvent>(_onClapPostEvent);
    on<NotInterestedPostEvent>(_onNotInterestedPostEvent);
    on<GetSinglePostEvent>(_onGetSinglePostEvent);
    on<UnclapPostEvent>(_onUnclapPostEvent); // Add handler for UnclapPostEvent
    on<SavePostEvent>(_onSavePostEvent); // Add handler for SavePostEvent
    on<SharePostEvent>(_onSharePostEvent); // Add handler for SharePostEvent
    on<GetCategoriesEvent>(
        _onGetCategoriesEvent); // Add handler for UnclapPostEvent
    on<CreateVideoPostEvent>(_onCreateVideoPostEvent);
    on<SelectVideoEvent>(_onSelectVideoEvent);
    on<GetUserPostsEvent>(_onGetUserPostsEvent);
    on<GetAllPostsEvent>(_onGetAllPostsEventHandler);
    on<GetAllVideoPostsEvent>(_onGetAllVideoPostsEventHandler);
    on<GetFollowersPostEvent>(_onGetFollowersPostEventHandler);
    on<GetCurrentTabIndexEvent>(_onGetCurrentTabIndexEventHandler);
    on<CheckIfNeedMoreDataEvent>(_oncheckIfNeedMoreDataEventHandler);
    on<GetClapmiVideosEvent>(_ongetClapmiVideoEventHandler);
    on<EditPostConntentEvent>(_onEditPostContent);
    on<DelPostUserEvent>(_onDelPostUserEvent);

    // on<GetLinkForVideoEvent>(_getLinkForVideoEventHandler);

    // GetUserPosts
  }

  Future<void> _onSelectImageEvent(
      SelectImageEvent event, Emitter<PostState> emit) async {
    emit(SelectPostImageLoadingState());
    final result =
        await postRepository.selectImage(imageSource: event.imageSource);

    result.fold(
        (error) => emit(SelectPostImageErrorState(errorMessage: error.message)),
        (data) {
      emit(
        SelectPostImageSuccessState(imageFiles: data),
      );
    });
  }

  Future<void> _onCreatePostEvent(
      CreatePostEvent event, Emitter<PostState> emit) async {
    emit(const CreatePostLoadingState()); // Emit loading state
    final result = await postRepository.createPost(postModel: event.postModel);
    result.fold(
      (failure) {
        emit(CreatePostErrorState(errorMessage: failure.message));
      },
      (success) {
        emit(CreatePostSuccessState(message: success!));
      },
    );
  }

  Future<void> _onChallengePostEvent(
      ChallengePostEvent event, Emitter<PostState> emit) async {
    emit(ChallengePostLoadingState());
    final result = await postRepository.challengePost(postID: event.postID);

    result.fold(
        (error) => emit(ChallengePostErrorState(errorMessage: error.message)),
        (message) {
      emit(
        ChallengePostSuccessState(message: message),
      );
    });
  }

  Future<void> _onCreateComboEvent(
      CreateComboEvent event, Emitter<PostState> emit) async {
    emit(CreateComboLoadingState());
    final result =
        await postRepository.createCombo(comboModel: event.comboModel);

    result.fold(
        (error) => emit(CreateComboErrorState(errorMessage: error.message)),
        (message) {
      emit(
        CreateComboSuccessState(message: message),
      );
    });
  }

  Future<void> _onEditPostContent(
      EditPostConntentEvent event, Emitter<PostState> emit) async {
    print('jklkjhjk${event.editPost.content}');
    emit(EditPostContentLoadingState());
    final result =
        await postRepository.editPostContent(editPost: event.editPost);

    result.fold(
        (error) => emit(EditPostContentErrorState(errorMessage: error.message)),
        (message) {
      print('jklkjhjk${event.postModelItems.length}');
      print('jklkjhjk${event.postIndex}');
      if (event.postModelItems.isNotEmpty && event.postIndex != null) {
        final updatedPostItems = List<PostModel>.from(event.postModelItems);
        final index = event.postIndex;
        updatedPostItems[index!] =
            updatedPostItems[index].copyWith(content: event.editPost.content);
        emit(
          EditPostContentSuccessState(
              message: message, postmodelItems: updatedPostItems),
        );
        print('jklkjhjk${updatedPostItems.length}');
      }
    });
  }

  Future<void> _onDelPostUserEvent(
    DelPostUserEvent event,
    Emitter<PostState> emit,
  ) async {
    emit(DelPostUserLoadingState());
    final result = await postRepository.delPost(postDeleted: event.postId);
    result.fold(
        (failure) => emit(
              DelPostUserErrorState(errorMessage: failure.message),
            ),
        // onSuccess
        (blockedUsers) {
      if (event.postModelItems.isNotEmpty && event.postIndex != null) {
        final updatedPostItems = List<PostModel>.from(event.postModelItems);
        final index = event.postIndex!;

        if (index >= 0 && index < updatedPostItems.length) {
          updatedPostItems.removeAt(index);
        }

        emit(
          DelPostUserSuccessState(
            message: 'post deleted',
            postmodelItems: updatedPostItems, // 👈 pass updated list if needed
          ),
        );

        print('after delete: ${updatedPostItems.length}');
      }
    });
  }

  Future<void> _onSingleCreateComboEvent(
      SingleCreateComboEvent event, Emitter<PostState> emit) async {
    emit(SingleCreateComboLoadingState());
    final result = await postRepository.singlecreateCombo(
        singlecomboModel: event.singlecomboModel);

    result.fold((error) {
      final moreInfo = error.moreInformation;
      final errorMap =
          moreInfo is Map<String, dynamic> ? moreInfo : <String, dynamic>{};
      final durationErrors = errorMap['duration'];
      final errorMessage = durationErrors is List && durationErrors.isNotEmpty
          ? durationErrors.first.toString()
          : error.message;
      print("This is the error message coming $errorMessage");

      emit(SingleCreateComboErrorState(
          errorMessage: errorMessage));
    }, (message) {
      emit(
        SingleCreateComboSuccessState(message: message),
      );
    });
  }

  Future<void> _onGetAvatarEvent(
      GetAvatarEvent event, Emitter<PostState> emit) async {
    emit(GetAvatarLoadingState());
    final result = await postRepository.getAvatars();
    result.fold((error) {
      emit(GetAvatarErrorState(errorMessage: error.message));
    }, (listOfAvatarModel) {
      listOfAvatarModelG = listOfAvatarModel;
      emit(
        GetAvatarSuccessState(listOfAvatarModel: listOfAvatarModel),
      );
    });
  }

  Future<void> _onCommentOnAPostEvent(
      CommentOnAPostEvent event, Emitter<PostState> emit) async {
    emit(CommentOnAPostLoadingState());
    final result = await postRepository.commentOnAPost(
        postID: event.postID, comment: event.comment);

    result.fold(
        (error) => emit(CommentOnAPostErrorState(errorMessage: error.message)),
        (message) {
      emit(
        CommentOnAPostSuccessState(message: message),
      );
    });
  }

  // _onCommentOnAPostEvent

  Future<void> _onClapPostEvent(
      ClapPostEvent event, Emitter<PostState> emit) async {
    emit(ClapPostLoadingState());
    final result = await postRepository.clapAPost(postID: event.postID);

    result
        .fold((error) => emit(ClapPostErrorState(errorMessage: error.message)),
            (message) {
      emit(
        ClapPostSuccessState(message: message),
      );
    });
  }

  Future<void> _onNotInterestedPostEvent(
      NotInterestedPostEvent event, Emitter<PostState> emit) async {
    emit(NotInterestedPostLoadingState());
    final result =
        await postRepository.notInterestedInAPost(postID: event.postID);

    result.fold(
        (error) =>
            emit(NotInterestedPostErrorState(errorMessage: error.message)),
        (message) {
      emit(
        NotInterestedPostSuccessState(message: message),
      );
    });
  }

  Future<void> _onGetSinglePostEvent(
      GetSinglePostEvent event, Emitter<PostState> emit) async {
    emit(GetSinglePostLoadingState());

    final result = await postRepository.getSinglePost(postID: event.postID);

    result.fold((error) {
      emit(GetSinglePostErrorState(errorMessage: error.message));
    }, (post) {
      emit(
        GetSinglePostSuccessState(post: post),
      );
    });
  }

  // Add handler implementation for UnclapPostEvent
  Future<void> _onUnclapPostEvent(
      UnclapPostEvent event, Emitter<PostState> emit) async {
    emit(UnclapPostLoadingState());
    final result = await postRepository.unclapAPost(postID: event.postID);

    result.fold(
        (error) => emit(UnclapPostErrorState(errorMessage: error.message)),
        (message) {
      emit(
        UnclapPostSuccessState(message: message),
      );
    });
  }

  // Handler for saving a post
  Future<void> _onSavePostEvent(
      SavePostEvent event, Emitter<PostState> emit) async {
    emit(const SavePostLoadingState());
    final result = await postRepository.savePost(postID: event.postID);

    result.fold(
      (error) => emit(SavePostErrorState(errorMessage: error.message)),
      (message) => emit(SavePostSuccessState(message: message)),
    );
  }

  // Handler for sharing a post
  Future<void> _onSharePostEvent(
      SharePostEvent event, Emitter<PostState> emit) async {
    emit(const SharePostLoadingState());
    final result = await postRepository.sharePost(postID: event.postID);

    result.fold(
      (error) => emit(SharePostErrorState(errorMessage: error.message)),
      (message) => emit(SharePostSuccessState(message: message)),
    );
  }

  Future<void> _onGetCategoriesEvent(
      GetCategoriesEvent event, Emitter<PostState> emit) async {
    emit(GetCategoriesLoadingState());
    final result = await postRepository.getCategories();

    result.fold(
        (error) => emit(GetCategoriesErrorState(errorMessage: error.message)),
        (listOfCategoryEntity) {
      listOfCategoryModelG = listOfCategoryEntity;
      emit(
        GetCategoriesSuccessState(listOfCategoryEntity: listOfCategoryEntity),
      );
    });
  }

  Future<void> _onCreateVideoPostEvent(
      CreateVideoPostEvent event, Emitter<PostState> emit) async {
    emit(CreateVideoPostLoadingState());
    final result = await postRepository.createVideoPost(
        createVideoPostEntity: event.createVideoPostEntity);

    result.fold(
        (error) => emit(CreateVideoPostErrorState(errorMessage: error.message)),
        (message) {
      emit(
        CreateVideoPostSuccessState(message: message),
      );
    });
  }

  Future<void> _onSelectVideoEvent(
      SelectVideoEvent event, Emitter<PostState> emit) async {
    emit(SelectPostVideoLoadingState());
    final result =
        await postRepository.selectVideo(imageSource: event.imageSource);

    result.fold(
        (error) => emit(SelectPostVideoErrorState(errorMessage: error.message)),
        (data) {
      emit(
        SelectPostVideoSuccessState(imageFiles: data),
      );
    });
  }

  Future<void> _onGetUserPostsEvent(
      GetUserPostsEvent event, Emitter<PostState> emit) async {
    try {
      emit(GetUserPostsLoadingState()); // Indicate loading

      final result =
          await postRepository.getUserPosts(event.uid); // Use the resul
      result.fold((error) {
        emit(GetUserPostsErrorState(
            errorMessage: error.message)); // Emit error state
      }, (posts) {
        emit(GetUserPostsSuccessState(posts: posts)); // Emit success with data
      });
    } catch (e) {
      emit(GetUserPostsErrorState(
          errorMessage: e.toString())); // Emit error state
    }
  }

  static const numberOfPostPerPage = 50;
  List<PostModel> cachedPosts = [];
  int pageNumber = 1;
  bool isLastPage = false;

  Future<void> _onGetAllPostsEventHandler(
      GetAllPostsEvent event, Emitter<PostState> emit) async {
    print('This is the pageNumber value $pageNumber');
    emit(GetAllPostsLoadingState());
    if (event.isRefresh) {
      pageNumber = 1;
    }

    final result = await postRepository.getAllPosts(
        index: pageNumber, isRefresh: event.isRefresh);
    result.fold((error) {
      emit(GetAvatarErrorState(errorMessage: error.message));
    }, (posts) {
      isLastPage = posts.length < numberOfPostPerPage;
      print('$isLastPage and the number of post to be used ${posts.length}');
      pageNumber = pageNumber + 1;

      emit(GetAllPostsSuccessState(posts: posts, isRefresh: event.isRefresh));
    });
  }

  Future<void> _onGetAllVideoPostsEventHandler(
      GetAllVideoPostsEvent event, Emitter<PostState> emit) async {
    if (!event.isRefresh) {
      emit(GetAllVideoPostsLoadingState());
    }
    final result = await postRepository.getAllVideoPosts(
        index: event.index, isRefresh: event.isRefresh);
    result.fold(
        (error) =>
            emit(GetAllVideoPostsErrorState(errorMessage: error.message)),
        (posts) {
      // isLastPage = posts.length < numberOfPostPerPage;
      // pageNumber = pageNumber + 1;
      // print(
      //     "------[[[]]]This is the length of the video post in page $pageNumber is ${posts.length}");
      // if (posts.isEmpty || posts.length < 30) {
      //   add(CheckIfNeedMoreDataEvent(isVideoPost: true));
      //   return;
      // }
      print('${posts.map(
        (e) => e.videoUrls,
      )}');
      emit(GetAllVideoPostsSuccessState(
          posts: posts, isRefresh: event.isRefresh));
    });
  }

  Future<void> _oncheckIfNeedMoreDataEventHandler(
      CheckIfNeedMoreDataEvent event, Emitter<PostState> emit) async {
    //   if (event.index == cachedPosts.length - nextPageTrigger) {
    if (event.isVideoPost) {
      add(GetAllVideoPostsEvent(isRefresh: false));
    } else {
      add(GetAllPostsEvent(isRefresh: false));
    }
    // }
  }

  Future<void> _onGetFollowersPostEventHandler(
      GetFollowersPostEvent event, Emitter<PostState> emit) async {
    emit(GetFollowersPostLoadingState());
    final result = await postRepository.getFollowersPost();
    result.fold(
        (error) =>
            emit(GetFollowersPostErrorState(errorMessage: error.message)),
        (posts) => emit(GetFollowersPostSuccessState(posts: posts)));
  }

  Future<void> _onGetCurrentTabIndexEventHandler(
      GetCurrentTabIndexEvent event, Emitter<PostState> emit) async {
    final result = event.index;
    if (result.isNaN) {
      emit(GetAllPostsErrorState(errorMessage: result.toString()));
    } else {
      emit(CurrentTabIndexState(index: result));
    }
  }

  int videoPagination = 1;
  Future<void> _ongetClapmiVideoEventHandler(
      GetClapmiVideosEvent event, Emitter<PostState> emit) async {
    final result = await postRepository.getClapmiVideos(index: videoPagination);
    result.fold(
        (error) =>
            emit(GetAllVideoPostsErrorState(errorMessage: error.message)),
        (videoData) {
      videoPagination = videoPagination + 1;
      globalVideoUrls = videoData.$2;
      //First check if the videoData is more than 3 and check the length of globalVideoUrl
      // if (globalVideoUrls.length < 30) {
      //   globalVideoUrls.addAll(videoData.$2);
      //   add(GetClapmiVideosEvent());
      // } else {
      emit(VideosLoaded(videoData: videoData));
      // }
    });
  }
}
