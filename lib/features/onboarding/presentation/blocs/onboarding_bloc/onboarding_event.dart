part of 'onboarding_bloc.dart';

sealed class OnboardingEvent extends Equatable {
  const OnboardingEvent();
  @override
  List<Object?> get props => [];
}

final class LoadInterestEvent extends OnboardingEvent {
  const LoadInterestEvent();

  @override
  List<Object?> get props => [];
}

final class SaveInterestsEvent extends OnboardingEvent {
  final List<String> interestIDs;
  const SaveInterestsEvent({required this.interestIDs});

  @override
  List<Object?> get props => [];
}

final class GetRandonUserEvent extends OnboardingEvent {
  const GetRandonUserEvent();

  @override
  List<Object?> get props => [];
}

final class SendClapRequestToUsersEvent extends OnboardingEvent {
  final List<String> userPids;
  const SendClapRequestToUsersEvent({required this.userPids});

  @override
  List<Object?> get props => [];
}
