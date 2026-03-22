import 'package:clapmi/core/api/api_client.dart';
import 'package:clapmi/core/api/base_response.dart';
import 'package:dio/dio.dart';

class ClapMiNetworkClient extends ApiClient {
  ClapMiNetworkClient({
    required super.dio,
    required super.appPreferenceService,
  });

  @override
  Future<BaseResponse> get({
    required String endpoint,
    Options? options,
    Map<String, dynamic>? params,
    Map<String, dynamic>? data,
    bool isAuthHeaderRequired = false,
    bool isLoginEndpoint = false,
  }) async {
    final requestOptions = options ?? Options();
    requestOptions.extra ??= {};
    requestOptions.extra?['isAuthHeaderRequired'] = isAuthHeaderRequired;
    requestOptions.extra?['isLoginEndpoint'] = isLoginEndpoint;
    final response = await super.get(
      endpoint: endpoint,
      options: requestOptions,
      params: params,
    );
    return BaseResponse.fromJson(response);
  }

  @override
  Future<BaseResponse> post({
    required String endpoint,
    data,
    Options? options,
    Map<String, dynamic>? params,
    bool isAuthHeaderRequired = false,
    bool isLoginEndpoint = false,
  }) async {
    final requestOptions = options ?? Options();
    requestOptions.extra ??= {};
    requestOptions.extra?['isAuthHeaderRequired'] = isAuthHeaderRequired;
    requestOptions.extra?['isLoginEndpoint'] = isLoginEndpoint;
    final response = await super.post(
      endpoint: endpoint,
      data: data,
      options: requestOptions,
      params: params,
    );

    return BaseResponse.fromJson(response);
  }

  @override
  Future<dynamic> put({
    required String endpoint,
    data,
    Options? options,
    Map<String, dynamic>? params,
    bool isAuthHeaderRequired = false,
    Function(int, int)? onSendProgress,
  }) async {
    final requestOptions = options ?? Options();
    requestOptions.extra ??= {};
    requestOptions.extra?['isAuthHeaderRequired'] = isAuthHeaderRequired;
    final response = await super.put(
      endpoint: endpoint,
      data: data,
      options: requestOptions,
      params: params,
      onSendProgress: onSendProgress,
    );
    return response;
    //BaseResponse.fromJson(response);
  }

  @override
  Future<BaseResponse> patch({
    required String endpoint,
    data,
    Options? options,
    Map<String, dynamic>? params,
    bool isAuthHeaderRequired = false,
  }) async {
    final requestOptions = options ?? Options();
    requestOptions.extra ??= {};
    requestOptions.extra?['isAuthHeaderRequired'] = isAuthHeaderRequired;
    final response = await super.patch(
        endpoint: endpoint,
        data: data,
        options: requestOptions,
        params: params);
    return BaseResponse.fromJson(response);
  }

  @override
  Future<BaseResponse> delete({
    required String endpoint,
    data,
    Options? options,
    Map<String, dynamic>? params,
    bool isAuthHeaderRequired = false,
  }) async {
    final requestOptions = options ?? Options();
    requestOptions.extra ??= {};
    requestOptions.extra?['isAuthHeaderRequired'] = isAuthHeaderRequired;
    final response = await super.delete(
        endpoint: endpoint,
        data: data,
        options: requestOptions,
        params: params);
    return BaseResponse.fromJson(response);
  }
}
