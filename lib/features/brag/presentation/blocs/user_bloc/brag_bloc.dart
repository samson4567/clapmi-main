import 'package:clapmi/features/app/presentation/blocs/app/app_bloc.dart';
import 'package:clapmi/features/brag/domain/repositories/brag_repository.dart';
import 'package:clapmi/features/brag/presentation/blocs/user_bloc/brag_event.dart';
import 'package:clapmi/features/brag/presentation/blocs/user_bloc/brag_state.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class BragBloc extends Bloc<BragEvent, BragState> {
  final BragRepository bragRepository;
  final AppBloc appBloc;

  BragBloc({required this.appBloc, required this.bragRepository})
      : super(BragInitial()) {
    on<SelectVideoEvent>(_onSelectImageEvent);
    on<CreateBragEvent>(_onCreatePostEvent);
    on<ChallengePostEvent>(_onChallengePostEvent);
    on<SingleLiveStreamChallengeEvent>(_onSingleLiveChallengeEvent);
    on<CreateComboEvent>(_onCreateComboEvent);
    on<GetAvatarEvent>(_onGetAvatarEvent);
    on<CommentOnAPostEvent>(_onCommentOnAPostEvent);
    on<BragChallengersEvent>(_onBragChallengerEvent);
    on<SingleBragChallengersEvent>(_onSingleBragChallengerEvent);
    on<GetSingleBragEvent>(_getSingleBragEventHandler);
    on<AcceptChallengeEvent>(_onAcceptChallengeEvent);
    on<DeclineChallengeEvent>(_onDeclineChallengeEvent);
    on<SingleLiveAcceptChallengeEvent>(_onSingleLiveAcceptChallengeEvent);
    on<SingleLiveDeclineChallengeEvent>(_onSingleLiveDeclineChallengeEvent);
    on<BoostChallengePoint>(_onboostChallengePointEventHandler);

    // CommentOnAPost
  }

  Future<void> _onSelectImageEvent(
      SelectVideoEvent event, Emitter<BragState> emit) async {
    emit(SelectPostImageLoadingState());
    final result =
        await bragRepository.selectImage(imageSource: event.imageSource);

    result.fold(
        (error) => emit(SelectPostImageErrorState(errorMessage: error.message)),
        (data) {
      emit(
        SelectPostImageSuccessState(imageFile: data),
      );
    });
  }

  Future<void> _onCreatePostEvent(
      CreateBragEvent event, Emitter<BragState> emit) async {
    emit(CreatePostLoadingState());
    final result = await bragRepository.createPost(postModel: event.postModel);

    result.fold(
        (error) => emit(CreatePostErrorState(errorMessage: error.message)),
        (postModel) {
      appBloc.state.testPostModel = postModel;
      emit(
        CreatePostSuccessState(postModel: postModel!),
      );
    });
  }

  Future<void> _onChallengePostEvent(
      ChallengePostEvent event, Emitter<BragState> emit) async {
    emit(ChallengePostLoadingState());
    final result = await bragRepository.challengePost(postID: event.postID);

    result.fold(
        (error) => emit(ChallengePostErrorState(errorMessage: error.message)),
        (challengeId) {
      emit(
        ChallengePostSuccessState(challengeId: challengeId),
      );
    });
  }

  Future<void> _onSingleLiveChallengeEvent(
      SingleLiveStreamChallengeEvent event, Emitter<BragState> emit) async {
    emit(SingleLiveStreamChallengeLoadingState());
    final result =
        await bragRepository.singlechallengeLiveStream(bradID: event.bragID);

    result.fold((error) {
      emit(SingleLiveStreamChallengeErrorState(
          errorMessage: error.moreInformation?['brag'][0]));
    }, (challengeId) {
      emit(
        SingleLiveStreamChallengeSuccessState(challengeId: challengeId),
      );
    });
  }

  Future<void> _onCreateComboEvent(
      CreateComboEvent event, Emitter<BragState> emit) async {
    emit(CreateComboLoadingState());
    final result = await bragRepository.createCombo(
        comboModel: event.comboModel,
        isSingleLiveStream: event.isSingleLiveStream);
    result.fold((error) {
      print("${error.toString()}-----");
      emit(CreateComboErrorState(errorMessage: error.moreInformation ?? {}));
    }, (message) {
      emit(
        CreateComboSuccessState(message: message),
      );
    });
  }

  Future<void> _onGetAvatarEvent(
      GetAvatarEvent event, Emitter<BragState> emit) async {
    emit(GetAvatarLoadingState());
    final result = await bragRepository.getAvatars();
    result
        .fold((error) => emit(GetAvatarErrorState(errorMessage: error.message)),
            (listOfAvatarModel) {
      emit(
        GetAvatarSuccessState(listOfAvatarModel: listOfAvatarModel),
      );
    });
  }

  Future<void> _onCommentOnAPostEvent(
      CommentOnAPostEvent event, Emitter<BragState> emit) async {
    emit(CommentOnAPostLoadingState());
    final result = await bragRepository.commentOnAPost(
        postID: event.postID, comment: event.comment);
    result.fold(
        (error) => emit(CommentOnAPostErrorState(errorMessage: error.message)),
        (message) {
      emit(
        CommentOnAPostSuccessState(message: message),
      );
    });
  }

  Future<void> _onBragChallengerEvent(
    BragChallengersEvent event,
    Emitter<BragState> emit,
  ) async {
    emit(SingleBragChallengersLoadingState());
    final result = await bragRepository.getlistofBragchallengers(
        postId: event.postId,
        contextType: event.contextType,
        list: event.list,
        status: event.status);

    result.fold(
      (error) => emit(
        BragChallengersErrorState(errorMessage: error.message),
      ),
      (challengers) => emit(
        BragChallengersSuccessState(challengers),
      ),
    );
  }

  Future<void> _onSingleBragChallengerEvent(
    SingleBragChallengersEvent event,
    Emitter<BragState> emit,
  ) async {
    emit(SingleBragChallengersLoadingState());
    final result = await bragRepository.getlistofSingleBragchallengers(
        contextType: event.contextType,
        list: event.list,
        status: event.status,
        brags: event.brags);

    result.fold(
      (error) => emit(
        SingleBragChallengersErrorState(errorMessage: error.message),
      ),
      (challengers) => emit(
        SingleBragChallengersSuccessState(challengers),
      ),
    );
  }

  Future<void> _getSingleBragEventHandler(
      GetSingleBragEvent event, Emitter<BragState> emit) async {
    emit(SingleBragChallengersLoadingState());
    final result = await bragRepository.getSinglePost(postId: event.postId);

    result.fold(
        (error) => emit(BragChallengersErrorState(errorMessage: error.message)),
        (post) => emit(SingleBragState(post: post)));
  }

  Future<void> _onAcceptChallengeEvent(
      AcceptChallengeEvent event, Emitter<BragState> emit) async {
    emit(AcceptChallengeLoadingState()); // Emit loading state
    final result =
        await bragRepository.acceptChallenge(challengeId: event.challengeId);
    result.fold(
      (failure) {
        var message = failure.moreInformation?['host'][0];
        emit(AcceptChallengeErrorState(errorMessage: message));
      },
      (success) {
        emit(AcceptChallengeSuccessState(message: success));
      },
    );
  }

  Future<void> _onDeclineChallengeEvent(
      DeclineChallengeEvent event, Emitter<BragState> emit) async {
    emit(ChallengeDeclinedLoading());
    final result =
        await bragRepository.declineChallenge(challengeId: event.challengeId);
    result.fold((failure) {
      var message = failure.moreInformation?['host'][0];
      emit(AcceptChallengeErrorState(errorMessage: message));
    }, (success) => emit(ChallengeDeclined(message: success)));
  }

  Future<void> _onSingleLiveAcceptChallengeEvent(
      SingleLiveAcceptChallengeEvent event, Emitter<BragState> emit) async {
    emit(SingleLiveAcceptChallengeLoadingState()); // Emit loading state
    final result = await bragRepository.singleLiveacceptChallenge(
        challenge: event.challenge);
    result.fold(
      (failure) {
        String message = "";
        if (failure.moreInformation!.containsKey("host")) {
          message = failure.moreInformation?['host'][0];
        } else if (failure.moreInformation!.containsKey("amount")) {
          message = failure.moreInformation?["amount"][0];
        }
        emit(SingleLiveAcceptChallengeErrorState(errorMessage: message));
      },
      (success) {
        emit(AcceptChallengeSuccessState(message: success));
      },
    );
  }

  Future<void> _onSingleLiveDeclineChallengeEvent(
      SingleLiveDeclineChallengeEvent event, Emitter<BragState> emit) async {
    emit(SingleLiveChallengeDeclinedLoading());
    final result = await bragRepository.singleLivedeclineChallenge(
        challenge: event.challenge);
    result.fold((failure) {
      var message = failure.moreInformation?['host'][0];
      emit(SingleLiveAcceptChallengeErrorState(errorMessage: message));
    }, (success) => emit(SingeLiveChallengeDeclined(message: success)));
  }

  Future<void> _onboostChallengePointEventHandler(
      BoostChallengePoint event, Emitter<BragState> emit) async {
    emit(BoostPointLoading());
    final result = await bragRepository.boostPoints(
        boostPoint: event.boostPoint, challengeId: event.challengeId);
    result.fold((failure) {
      emit(BragChallengersErrorState(errorMessage: failure.message));
    }, (message) => emit(BoostPointLoaded(responseMessage: message)));
  }
}
