part of 'onboarding_bloc.dart';

sealed class OnboardingState extends Equatable {
  const OnboardingState();
  @override
  List<Object?> get props => [];
}

final class OnboardingInitial extends OnboardingState {
  @override
  List<Object> get props => [];
}

// interest
final class LoadInterestLoadingState extends OnboardingState {}

final class LoadInterestSuccessState extends OnboardingState {
  const LoadInterestSuccessState({required this.interestCategories});
  final List<InterestCategoryModel> interestCategories;
  @override
  List<Object> get props => [interestCategories];
}

final class LoadInterestErrorState extends OnboardingState {
  const LoadInterestErrorState({required this.errorMessage});
  final String errorMessage;
  @override
  List<Object> get props => [errorMessage];
}

// save interest
final class SaveInterestsLoadingState extends OnboardingState {}

final class SaveInterestsSuccessState extends OnboardingState {
  const SaveInterestsSuccessState({required this.message});
  final String message;

  @override
  List<Object> get props => [message];
}

final class SaveInterestsErrorState extends OnboardingState {
  const SaveInterestsErrorState({required this.errorMessage});
  final String errorMessage;

  @override
  List<Object> get props => [errorMessage];
}
// save interest ended ....

// userList
final class GetRandomUserLoadingState extends OnboardingState {}

final class GetRandomUserSuccessState extends OnboardingState {
  const GetRandomUserSuccessState({required this.randomUsers});
  final List<OtherUserModel> randomUsers;
  @override
  List<Object> get props => [randomUsers];
}

final class GetRandomUserErrorState extends OnboardingState {
  const GetRandomUserErrorState({required this.errorMessage});
  final String errorMessage;
  @override
  List<Object> get props => [errorMessage];
}
// userList ended ....

// clap request events
final class SendClapRequestToUsersLoadingState extends OnboardingState {
  const SendClapRequestToUsersLoadingState(
      {required this.idsOFUsersThatWereSentRequest});
  final List<String> idsOFUsersThatWereSentRequest;
  @override
  List<Object> get props => [idsOFUsersThatWereSentRequest];
}

final class SendClapRequestToUsersSuccessState extends OnboardingState {
  const SendClapRequestToUsersSuccessState({required this.userPids});
  final List<String> userPids;

  @override
  List<Object> get props => [userPids];
}

final class SendClapRequestToUsersErrorState extends OnboardingState {
  const SendClapRequestToUsersErrorState(
      {required this.errorMessage, required this.userPids});
  final String errorMessage;
  final List<String> userPids;
  @override
  List<Object> get props => [errorMessage];
}

final class SendClapRequestToUsersRequestPendingState extends OnboardingState {
  const SendClapRequestToUsersRequestPendingState(
      {required this.message, required this.userPids});
  final String message;
  final List<String> userPids;
  @override
  List<Object> get props => [message];
}
// clap request events ended .....


