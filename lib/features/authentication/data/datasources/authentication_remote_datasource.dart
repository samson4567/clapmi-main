import 'dart:async';
import 'dart:io';

import 'package:clapmi/core/api/clapmi_network_client.dart';
import 'package:clapmi/core/constants/endpoint_constant.dart';
import 'package:clapmi/features/authentication/data/models/logout_model.dart';
import 'package:clapmi/features/authentication/data/models/new_user_request_model.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthenticationRemoteDatasource {
  Future<String> newUserSignUp({required NewUserRequestModel newUserRequest});
  Future<String> verifySignUp({required String email, required String otp});
  Future<Map> userLogin({required String email, required String password});
  Future<String> forgotPassword({required String email});
  Future<String> resendVerificationCode({required String email});
  Future<String> registerFCMtoken({
    required String token,
    required String deviceType,
  });
  Future<String> unregisterFCMtoken({
    required String token,
  });
  Future<String> toogleNotificationState({
    required String token,
    required bool toEnable,
  });

  Future<String> verifyForgotPassword(
      {required String email, required String otp});
  Future<String> resetPassword(
      {required String email,
      required String token,
      required String password,
      required String confirmPassword});
  Future<String> updatePassword({
    required String email,
    required String currentPassword,
    required String newPassword,
    required String passwordConfirmation,
  });
  Future<String> blockUser({String creator});

  Future<String> logOut({required LogoutModel refreshToken});
  Future<Map> loginWithGoogle();
}

class AuthenticationRemoteDatasourceImpl
    implements AuthenticationRemoteDatasource {
  AuthenticationRemoteDatasourceImpl(
      {required this.networkClient, required this.googleSignIn});
  final ClapMiNetworkClient networkClient;
  final GoogleSignIn googleSignIn;
  GoogleSignInServerAuthorization? serverAuth;
  GoogleSignInClientAuthorization? authorization;

  @override
  Future<String> newUserSignUp(
      {required NewUserRequestModel newUserRequest}) async {
    final response = await networkClient.post(
      endpoint: EndpointConstant.signUp,
      data: newUserRequest.toJson(),
    );
    return response.message;
  }

  @override
  Future<String> verifySignUp(
      {required String email, required String otp}) async {
    final response = await networkClient.post(
      endpoint: EndpointConstant.verifySignUp,
      // params: {},
      data: {
        'email': email,
        'otp': otp,
        'type': 'account-registration',
      },
    );

    return response.message;
  }

  @override
  Future<Map> userLogin(
      {required String email, required String password}) async {
    final response = await networkClient.post(
      endpoint: EndpointConstant.login,
      isAuthHeaderRequired: false,
      isLoginEndpoint: true,
      data: {'userdata': email, 'password': password},
    );
    print('This is the response from LOGIN $response');
    return response.data;
  }

  @override
  Future<String> forgotPassword({required String email}) async {
    final response = await networkClient.post(
      endpoint: EndpointConstant.forgotPassword,
      data: {'email': email},
    );
    return response.message;
  }

  @override
  Future<String> verifyForgotPassword(
      {required String email, required String otp}) async {
    final response = await networkClient.post(
      endpoint: EndpointConstant.verifySignUp,
      params: {'type': 'forgot-password'},
      data: {'email': email, 'otp': otp},
    );
    return response.data['resetToken'];
  }

  @override
  Future<String> resetPassword(
      {required String email,
      required String token,
      required String password,
      required String confirmPassword}) async {
    final response = await networkClient.post(
      endpoint: EndpointConstant.resetPassword,
      data: {
        'email': email,
        'password': password,
        'password_confirmation': confirmPassword,
        'token': token
      },
    );
    return response.message;
  }

  @override
  Future<String> updatePassword({
    required String email,
    required String currentPassword,
    required String newPassword,
    required String passwordConfirmation,
  }) async {
    final response = await networkClient.post(
      endpoint: EndpointConstant.updatePassword,
      isAuthHeaderRequired: true,
      data: {
        "email": email,
        "type": "auth",
        'current_password': currentPassword,
        'password': newPassword,
        'password_confirmation': passwordConfirmation,
      },
    );
    return response.message;
  }

  @override
  Future<String> resendVerificationCode({required String email}) async {
    final result = await networkClient.post(
        endpoint: EndpointConstant.resendVerificationCode,
        data: {"email": email});
    return result.message;
  }

  @override
  Future<String> blockUser({String? creator}) async {
    // print('This is the id of the creator here $creator');
    final result = await networkClient.post(
      endpoint: EndpointConstant.blockUser,
      data: {"creator": creator},
      isAuthHeaderRequired: true,
    );
    return result.message;
  }

  @override
  Future<String> logOut({required LogoutModel refreshToken}) async {
    final result = await networkClient.post(
      endpoint: EndpointConstant.logOut,
      data: refreshToken.toJson(),
      isAuthHeaderRequired: true,
    );
    return result.message;
  }

  @override
  Future<Map> loginWithGoogle() async {
    try {
      // Use platform-specific client IDs
      String clientId;

      if (Platform.isIOS) {
        // iOS Client ID
        clientId =
            "671764482867-othise6vjk1tqpvlmlemigcu0eo3c3rq.apps.googleusercontent.com";
      } else if (Platform.isAndroid) {
        // Android Client ID
        clientId =
            "671764482867-iic1g4bepl6vtm192v3bsmvdad9946ph.apps.googleusercontent.com";
      } else {
        // Fallback for other platforms (web, etc.)
        clientId =
            "671764482867-onqf7cjj17cihl2mrhdgmgpgnu8siikl.apps.googleusercontent.com";
      }

      // Initialize with platform-specific clientId
      await googleSignIn.initialize(
          clientId: clientId,
          serverClientId:
              "671764482867-onqf7cjj17cihl2mrhdgmgpgnu8siikl.apps.googleusercontent.com" // Web Client ID for backend
          );

      // Authenticate the user
      final result = await googleSignIn.authenticate();
      print("This is the result coming from here: $result");

      final String idToken = result.authentication.idToken ?? '';
      print('This is the ID token from Google: $idToken');

      if (idToken.isEmpty) {
        throw Exception('Failed to get ID token from Google');
      }

      // Send ID token to your backend
      final response = await networkClient.get(
        endpoint: "${EndpointConstant.googleelogin}$idToken",
        isLoginEndpoint: true,
      );

      print('Backend response: ${response.data}');
      return response.data;
    } catch (e) {
      print('🔴 loginWithGoogle ERROR: $e');
      rethrow;
    }
  }

  // @override
  // Future<String> registerFCMToken(
  //     {required String token, required String deviceType}) async {
  // }

  @override
  Future<String> registerFCMtoken(
      {required String token, required String deviceType}) async {
    final response = await networkClient.post(
      endpoint: EndpointConstant.registerFCMtoken,
      isAuthHeaderRequired: true,
      data: {
        "token": token,
        "device_type": deviceType,
      },
    );
    return response.message;
  }

  @override
  Future<String> unregisterFCMtoken({required String token}) async {
    final response = await networkClient.post(
      endpoint: EndpointConstant.unregisterFCMtoken,
      isAuthHeaderRequired: true,
      data: {
        "token": token,
      },
    );
    return response.message;
  }

  @override
  Future<String> toogleNotificationState(
      {required String token, required bool toEnable}) async {
    final response = await networkClient.post(
      endpoint: EndpointConstant.toogleNotificationState,
      isAuthHeaderRequired: true,
      data: {
        "token": token,
        "enabled": toEnable ? 1 : 0,
      },
    );
    return response.message;
  }
  // toogleNotificationState
}
