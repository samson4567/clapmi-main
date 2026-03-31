import 'package:clapmi/core/api/header_interceptor.dart';
import 'package:clapmi/core/api/multi_env.dart';
import 'package:clapmi/core/app_variables.dart';
import 'package:clapmi/core/constants/endpoint_constant.dart';
import 'package:clapmi/core/db/app_preference_service.dart';
import 'package:clapmi/core/network_info/network_info.dart';
import 'package:clapmi/core/security/secure_key.dart';
import 'package:clapmi/features/authentication/data/models/token_model.dart';
import 'package:dio/dio.dart';
import 'package:clapmi/core/error/exception.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

abstract class ApiClient<T> {
  final Dio dio;
  final AppPreferenceService appPreferenceService;
  ApiClient({
    required this.dio,
    required this.appPreferenceService,
  }) {
    dio
      ..options.baseUrl = MultiEnv().apiUrl
      ..options.connectTimeout = const Duration(seconds: 120)
      ..options.receiveTimeout = const Duration(seconds: 120)
      ..options.headers = {'Content-Type': 'application/json; charset=UTF-8'};
    if (kDebugMode) {
      dio.interceptors.addAll([
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
        )
      ]);
    }
    dio.interceptors.add(HeaderInterceptor(
      appPreferenceService: appPreferenceService,
      dio: dio,
    ));
  }

  Future<T> get({
    required String endpoint,
    Options? options,
    Map<String, dynamic>? params,
    Map<String, dynamic>? data,
  }) async {
    try {
      if (isthereInternetG) {
        final response = await dio.get(endpoint,
            queryParameters: params, options: options, data: data);
        return response.data;
      } else {
        throw const NetworkException();
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        //WHEN ACCESS_TOKEN HAS EXPIRED....
        try {
          final serializedRefreshToken = appPreferenceService
              .getValue<String>(SecureKey.loginAuthTokenKey);
          TokenModel result =
              TokenModel.deserialize(serializedRefreshToken ?? '');
          final tokenResponse = await dio.post(
            EndpointConstant.refreshToken,
            data: {
              'refresh_token': result.refreshToken,
            },
            options: Options(headers: {'x-client-type': 'mobile'}),
          );
          TokenModel tokenModel =
              TokenModel.fromJson({...tokenResponse.data['data']});
          await appPreferenceService.saveValue(
              SecureKey.loginAuthTokenKey, TokenModel.serialize(tokenModel));
          final response = await dio.get(endpoint,
              queryParameters: params, options: options);
          return response.data;
        } on DioException catch (e) {
          _handleError(e);
        }
      } else {
        _handleError(e);
      }
      rethrow;
    }
  }

  Future<T> post({
    required String endpoint,
    dynamic data,
    Options? options,
    Map<String, dynamic>? params,
  }) async {
    try {
      if (isthereInternetG
          // await ConnectivityHelper.hasInternetConnection()
          ) {
        final response = await dio.post(endpoint,
            data: data, options: options, queryParameters: params);
        return response.data;
      } else {
        throw const NetworkException();
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        try {
          final serializedRefreshToken = appPreferenceService
              .getValue<String>(SecureKey.loginAuthTokenKey);
          TokenModel result =
              TokenModel.deserialize(serializedRefreshToken ?? '');
          final tokenResponse = await dio.post(
            EndpointConstant.refreshToken,
            data: {
              'refresh_token': result.refreshToken,
            },
            options: Options(headers: {'x-client-type': 'mobile'}),
          );
          TokenModel tokenModel =
              TokenModel.fromJson({...tokenResponse.data['data']});
          await appPreferenceService.saveValue(
              SecureKey.loginAuthTokenKey, TokenModel.serialize(tokenModel));
          //THEN CALL THE ENDPOINT AGAIN HAVING SAVED THE NEW ACCESS_TOKEN
          //RECURRING PRINCIPLE COULD BE USED HERE ALSO.
          final response = await dio.post(endpoint,
              data: data, options: options, queryParameters: params);
          return response.data;
        } on DioException catch (e) {
          _handleError(e);
        }
      } else {}

      _handleError(e);
      rethrow;
    }
  }

  Future<T> graphQLPost({
    required String endpoint,
    dynamic data,
    Options? options,
    Map<String, dynamic>? params,
  }) async {
    try {
      if (await ConnectivityHelper.hasInternetConnection()) {
        final response = await dio.post(endpoint,
            data: {"query": data}, options: options, queryParameters: params);
        return response.data;
      } else {
        throw const NetworkException();
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        try {
          final serializedRefreshToken = appPreferenceService
              .getValue<String>(SecureKey.loginAuthTokenKey);
          TokenModel result =
              TokenModel.deserialize(serializedRefreshToken ?? '');
          final tokenResponse = await dio.post(
            EndpointConstant.refreshToken,
            data: {
              'refresh_token': result.refreshToken,
            },
            options: Options(headers: {'x-client-type': 'mobile'}),
          );
          TokenModel tokenModel =
              TokenModel.fromJson({...tokenResponse.data['data']});
          await appPreferenceService.saveValue(
              SecureKey.loginAuthTokenKey, TokenModel.serialize(tokenModel));
          final response = await dio.post(endpoint,
              data: {"query": data}, options: options, queryParameters: params);
          return response.data;
        } on DioException catch (e) {
          _handleError(e);
        }
      } else {}
      _handleError(e);
      rethrow;
    }
  }

  Future<T> put({
    required String endpoint,
    dynamic data,
    Options? options,
    Map<String, dynamic>? params,
    Function(int, int)? onSendProgress,
  }) async {
    try {
      if (await ConnectivityHelper.hasInternetConnection()) {
        final response = await dio.put(
          endpoint,
          data: data,
          options: options,
          queryParameters: params,
          onSendProgress: onSendProgress,
        );
        return response.statusCode as dynamic;
      } else {
        throw const NetworkException();
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        try {
          final serializedRefreshToken = appPreferenceService
              .getValue<String>(SecureKey.loginAuthTokenKey);
          TokenModel result =
              TokenModel.deserialize(serializedRefreshToken ?? '');
          final tokenResponse = await dio.post(
            EndpointConstant.refreshToken,
            data: {
              'refresh_token': result.refreshToken,
            },
            options: Options(headers: {'x-client-type': 'mobile'}),
          );
          TokenModel tokenModel =
              TokenModel.fromJson({...tokenResponse.data['data']});
          await appPreferenceService.saveValue(
              SecureKey.loginAuthTokenKey, TokenModel.serialize(tokenModel));
          final response = await dio.put(
            endpoint,
            data: data,
            options: options,
            queryParameters: params,
            onSendProgress: onSendProgress,
          );
          return response.statusCode as dynamic;
        } on DioException catch (e) {
          _handleError(e);
        }
      } else {}
      _handleError(e);
      rethrow;
    }
  }

  Future<T> patch(
      {required String endpoint,
      dynamic data,
      Options? options,
      Map<String, dynamic>? params}) async {
    try {
      if (await ConnectivityHelper.hasInternetConnection()) {
        final response = await dio.patch(endpoint,
            data: data, options: options, queryParameters: params);
        return response.data;
      } else {
        throw const NetworkException();
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        try {
          final serializedRefreshToken = appPreferenceService
              .getValue<String>(SecureKey.loginAuthTokenKey);
          TokenModel result =
              TokenModel.deserialize(serializedRefreshToken ?? '');

          final tokenResponse = await dio.post(
            EndpointConstant.refreshToken,
            data: {
              'refresh_token': result.refreshToken,
            },
            options: Options(headers: {'x-client-type': 'mobile'}),
          );
          TokenModel tokenModel =
              TokenModel.fromJson({...tokenResponse.data['data']});
          await appPreferenceService.saveValue(
              SecureKey.loginAuthTokenKey, TokenModel.serialize(tokenModel));
          final response = await dio.patch(endpoint,
              data: data, options: options, queryParameters: params);
          return response.data;
        } on DioException catch (e) {
          _handleError(e);
        }
      } else {}
      _handleError(e);
      rethrow;
    }
  }

  Future<T> delete(
      {required String endpoint,
      dynamic data,
      Options? options,
      Map<String, dynamic>? params}) async {
    try {
      if (await ConnectivityHelper.hasInternetConnection()) {
        final response = await dio.delete(endpoint,
            data: data, options: options, queryParameters: params);
        return response.data;
      } else {
        throw const NetworkException();
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        try {
          final serializedRefreshToken = appPreferenceService
              .getValue<String>(SecureKey.loginAuthTokenKey);
          TokenModel result =
              TokenModel.deserialize(serializedRefreshToken ?? '');
          final tokenResponse = await dio.post(
            EndpointConstant.refreshToken,
            data: {
              'refresh_token': result.refreshToken,
            },
            options: Options(),
          );
          TokenModel tokenModel =
              TokenModel.fromJson({...tokenResponse.data['data']});
          await appPreferenceService.saveValue(
              SecureKey.loginAuthTokenKey, TokenModel.serialize(tokenModel));
          final response = await dio.delete(endpoint,
              data: data, options: options, queryParameters: params);
          return response.data;
        } on DioException catch (e) {
          _handleError(e);
        }
      } else {}
      _handleError(e);
      rethrow;
    }
  }

  void _handleError(DioException error) {
    String errorMessage = "Something went wrong";
    // Map<String, dynamic> errorMapMessage = {};
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        throw const TimeoutException(message: "Request timed out");

      case DioExceptionType.badResponse:
        // Logger.log(
        //     alertType: AlertType.error,
        //     message: "${error.response?.statusCode}");
        final response = error.response;
        if (response != null) {
          final responseData = response.data;
          final statusCode = response.statusCode;
          print("This is the response data format ${response.data}");

          if (responseData is Map<String, dynamic>) {
            errorMessage = responseData['message']?.toString() ?? errorMessage;

            final errors = responseData['errors'];
            if (errors is Map && errors.isNotEmpty) {
              errorMessage = errors.values
                  .map((value) => value.toString())
                  .join('\n');
              print(
                  "This is the error form sent to the frontend ----$errorMessage");
            } else if (errors is List && errors.isNotEmpty) {
              errorMessage = errors.map((value) => value.toString()).join('\n');
              print(
                  "This is the error form sent to the frontend ----$errorMessage");
            }
          }

          if (statusCode != null) {
            switch (statusCode) {
              case 401:
              case 403:
                throw UnAuthorizedException(message: errorMessage);
              case 422:
                throw ClientException(
                    message: errorMessage,
                    moreInformation: responseData['errors']);
              case 404:
              case 400:
                final errors = responseData['errors'];
                final hasNoErrors = errors == null ||
                    (errors is List && errors.isEmpty) ||
                    (errors is Map && errors.isEmpty);
                if (hasNoErrors) {
                  errorMessage = responseData['message'];
                }
                throw BadRequestException(message: errorMessage);
              default:
                if (statusCode >= 500 && statusCode < 600) {
                  throw ServerException(message: errorMessage);
                }
            }
          }
        }
        throw UnknownException(message: errorMessage);

      case DioExceptionType.unknown:
        throw const UnknownException(message: "An unexpected error occurred");

      default:
        throw UnknownException(message: errorMessage);
    }
  }
}
