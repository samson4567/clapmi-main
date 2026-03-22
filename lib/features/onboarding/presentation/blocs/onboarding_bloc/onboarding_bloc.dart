import 'package:clapmi/core/app_variables.dart';
import 'package:clapmi/features/onboarding/data/models/interest_category_model.dart';
import 'package:clapmi/features/onboarding/data/models/other_user_model.dart';
import 'package:clapmi/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final OnboardingRepository onboardingRepository;
  OnboardingBloc({required this.onboardingRepository})
      : super(OnboardingInitial()) {
    on<LoadInterestEvent>(_onLoadInterestEvent);
    on<GetRandonUserEvent>(_onGetRandonUserEvent);

    on<SendClapRequestToUsersEvent>(_onSendClapRequestToUsersEvent);
    on<SaveInterestsEvent>(_onSaveInterestEvent);
  }
  // dOfSeb8b-c605-4554-b913-2c3177db41ab

  // SaveInterestEvent

  Future<void> _onLoadInterestEvent(
      LoadInterestEvent event, Emitter<OnboardingState> emit) async {
    emit(LoadInterestLoadingState());
    final result = await onboardingRepository.loadInterests();
    result.fold(
        (error) => emit(LoadInterestErrorState(errorMessage: error.message)),
        (interestCategories) {
      listOFInterestCategoryModelG = interestCategories;
      emit(
        LoadInterestSuccessState(
          interestCategories: interestCategories
              .map(
                (e) => InterestCategoryModel.fromEntity(e),
              )
              .toList(),
        ),
      );
    });
  }
  // SendClapRequestToUsersEvent

  Future<void> _onGetRandonUserEvent(
      GetRandonUserEvent event, Emitter<OnboardingState> emit) async {
    emit(GetRandomUserLoadingState());

    final result = await onboardingRepository.getRandomUserList();

    result.fold(
      (error) {
        emit(GetRandomUserErrorState(errorMessage: error.message));
      },
      (randomUsers) {
        emit(
          GetRandomUserSuccessState(
            randomUsers: randomUsers
                .map(
                  (e) => OtherUserModel.fromEntity(e),
                )
                .toList(),
          ),
        );
      },
    );
  }

  Future<void> _onSendClapRequestToUsersEvent(
      SendClapRequestToUsersEvent event, Emitter<OnboardingState> emit) async {
    emit(SendClapRequestToUsersLoadingState(
      idsOFUsersThatWereSentRequest: event.userPids,
    ));
    final result = await onboardingRepository.sendClapRequestToUsers(
        userPids: event.userPids);
    result.fold(
      (error) {
        if (error.message.contains("already pending")) {
          emit(SendClapRequestToUsersRequestPendingState(
            message: error.message,
            userPids: event.userPids,
          ));
          return;
        }
        emit(SendClapRequestToUsersErrorState(
          errorMessage: error.message,
          userPids: event.userPids,
        ));
      },
      (randomUsers) => emit(
        SendClapRequestToUsersSuccessState(
          userPids: event.userPids, // i know it seems wierd but it cool
        ),
      ),
    );
  }

  Future<void> _onSaveInterestEvent(
      SaveInterestsEvent event, Emitter<OnboardingState> emit) async {
    emit(SaveInterestsLoadingState());
    final result = await onboardingRepository.saveInterests(
      interestIDs: event.interestIDs,
    );
    result.fold(
      (error) => emit(SaveInterestsErrorState(
        errorMessage: error.message,
      )),
      (message) => emit(
        SaveInterestsSuccessState(
          message: message,
        ),
      ),
    );
  }
}
