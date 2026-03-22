import 'package:clapmi/core/app_variables.dart';
import 'package:clapmi/core/db/app_preference_service.dart';
import 'package:clapmi/core/security/secure_key.dart';
import 'package:clapmi/features/authentication/data/models/token_model.dart';
import 'package:clapmi/global_object_folder_jacket/global_object.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';

class HeaderInterceptor extends Interceptor {
  HeaderInterceptor({
    required this.appPreferenceService,
    required this.dio,
  });
  final AppPreferenceService appPreferenceService;
  final Dio dio;
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final isAuthHeaderRequired = options.extra['isAuthHeaderRequired'] ?? false;
    final isLoginEndpoint = options.extra['isLoginEndpoint'] ?? false;
    if (isAuthHeaderRequired) {
      final serializedAccessToken =
          appPreferenceService.getValue<String>(SecureKey.loginAuthTokenKey);
      if (serializedAccessToken != null) {
        TokenModel result = TokenModel.deserialize(serializedAccessToken);
        options.headers['Authorization'] = result.accessToken;
      }
    }
    if (isLoginEndpoint) {
      options.headers['x-client-type'] = 'mobile';
    }
    options.extra.clear();
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 &&
        (err.response?.data['message'] == 'Token missing' ||
            err.response?.data['message'] == 'Invalid refresh token' ||
            err.response?.data['message'] ==
                'Invalid or expired refresh token')) {
      await appPreferenceService.clearAll();
      final navigator = rootNavigatorKey.currentState;
      if (navigator != null && navigator.mounted) {
        theclapAnimationController.dispose();
        navigator.context.go(MyAppRouteConstant.login);
      }
    } else {
      super.onError(err, handler);
    }
  }
}
