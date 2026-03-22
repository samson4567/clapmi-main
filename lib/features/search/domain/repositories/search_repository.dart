import 'package:clapmi/Models/search/user_search.dart';
import 'package:clapmi/core/error/failure.dart';
import 'package:dartz/dartz.dart';

abstract class SearchRepository {
  Future<Either<Failure, List<UserSearch>>> searchUsers(String query);
}
