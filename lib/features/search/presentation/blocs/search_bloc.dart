import 'package:clapmi/Models/search/user_search.dart';
import 'package:clapmi/core/error/failure.dart';
import 'package:clapmi/features/search/domain/repositories/search_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository searchRepository;

  SearchBloc({required this.searchRepository}) : super(SearchInitial()) {
    on<SearchUsersEvent>(
      _onSearchUsers,
      // Add debouncer
      transformer: (events, mapper) => events
          .debounceTime(const Duration(milliseconds: 500))
          .switchMap(mapper),
    );
  }

  Future<void> _onSearchUsers(
      SearchUsersEvent event, Emitter<SearchState> emit) async {
    if (event.query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());
    final result = await searchRepository.searchUsers(event.query);
    result.fold(
      (failure) {
        if (failure is ServerFailure) {
          emit(SearchError(failure.message));
        } else if (failure is NetworkFailure) {
          emit(SearchError(failure.message));
        } else {
          emit(const SearchError('An unexpected error occurred'));
        }
      },
      (users) => emit(SearchLoaded(users)),
    );
  }
}
