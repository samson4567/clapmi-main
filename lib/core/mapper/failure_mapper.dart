import 'package:clapmi/core/error/exception.dart';
import 'package:clapmi/core/error/failure.dart';

Failure mapExceptionToFailure(Object e) {
  if (e is ServerException) {
    return ServerFailure(message: e.message, description: e.description);
  } else if (e is UnAuthorizedException) {
    return UnAuthorizedFailure(message: e.message, description: e.description);
  } else if (e is ClientException) {
    return ClientFailure(
        message: e.message,
        description: e.description,
        moreInformation: e.moreInformation);
  } else if (e is NetworkException) {
    return NetworkFailure(message: e.message, description: e.description);
  } else if (e is TimeoutException) {
    return TimeoutFailure(message: e.message, description: e.description);
  } else if (e is BadRequestException) {
    return BadRequestFailure(message: e.message, description: e.description);
  } else {
    // Default case for unknown exceptions
    return UnKnownFailure(
        message: 'Something went wrong \n $e', description: 'Try again later');
  }
}
