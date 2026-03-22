import 'package:clapmi/Models/search/user_search.dart';
import 'package:clapmi/core/error/exception.dart';
import 'package:clapmi/core/error/failure.dart';
import 'package:clapmi/features/search/data/datasources/search_remote_data_source.dart';
import 'package:clapmi/features/search/domain/repositories/search_repository.dart';
import 'package:dartz/dartz.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remoteDataSource;

  SearchRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<UserSearch>>> searchUsers(String query) async {
    try {
      final remoteUsers = await remoteDataSource.searchUsers(query);
      return Right(remoteUsers);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(
        message: e.toString(),
      ));
    }
  }
}
