import 'package:clapmi/core/api/clapmi_network_client.dart';
import 'package:clapmi/core/constants/endpoint_constant.dart';
import 'package:clapmi/core/db/app_preference_service.dart';
import 'package:clapmi/features/combo/data/models/combo_model.dart';
import 'package:clapmi/features/combo/domain/entities/combo_entity.dart';

abstract class ComboRemoteDatasource {
  Future<List<ComboEntity>> getLiveCombos();
  Future<List<ComboEntity>> getUpcomingCombos();
  Future<ComboEntity> getComboDetail({required String comboID});
  Future<String> startCombo({required String comboID});
  Future<String> setReminderForCombo(
      {required String comboID, required String time});
  Future<String> joinComboGround({required String comboID});
  Future<String> leaveComboGround({required String comboID});
  Future<SwitchDeviceResult> switchDevice({required String comboID, required String deviceId});
  Future<JoinCompanionResult> joinCompanion({required String comboID, required String deviceId});
  Future<String> rescheduleChallenge(
      {required String postID, required String newTime});

  Future<LiveComboModel> getSingleLiveCombo({required String comboId});
  // setRemindalForCombos
}

class ComboRemoteDatasourceImpl implements ComboRemoteDatasource {
  ComboRemoteDatasourceImpl({
    required this.networkClient,
    required this.appPreferenceService,
  });
  final AppPreferenceService appPreferenceService;

  final ClapMiNetworkClient networkClient;

  @override
  Future<List<ComboModel>> getLiveCombos() async {
    final response = await networkClient.get(
      endpoint: EndpointConstant.getLiveCombos,
      isAuthHeaderRequired: true,
    );
    List rawList = response.data;
    final result = rawList.map(
      (e) {
        return ComboModel.fromJson(e);
      },
    ).toList();
    //  print("This is the list response and result ${result.toString()}");
    return result;
  }

  @override
  Future<List<ComboModel>> getUpcomingCombos() async {
    final response = await networkClient.get(
      endpoint: EndpointConstant.getUpcomingCombos,
      isAuthHeaderRequired: true,
    );
    List rawList = response.data;
    final result = rawList.map(
      (e) {
        return ComboModel.fromJson(e);
      },
    ).toList();
    return result;
  }

  @override
  Future<ComboModel> getComboDetail({required String comboID}) async {
    // try {
    print("THIS IS TO GET THE COMBO DETAILS");
    final response = await networkClient.get(
      endpoint: "${EndpointConstant.getSingleCombo}/$comboID",
      isAuthHeaderRequired: true,
    );
    final result = ComboModel.fromJson(response.data);
    print('This is getting combo details $result');
    return result;
    // } catch (e) {
    //   print("This is the error coming from the endpoint ${e.toString()}--- ");
    //   throw (UnknownException(message: e.toString()));
    // }
  }

  @override
  Future<String> startCombo({required String comboID}) async {
    print("This is starting a combo something anyways $comboID");
    final response = await networkClient.post(
        endpoint: "${EndpointConstant.getSingleCombo}/$comboID/start",
        isAuthHeaderRequired: true,
        data: {'start': comboID});
    print("This is the response......................... ${response.message}");
    print("${response.data}");
    return response.message;
  }

  @override
  Future<String> setReminderForCombo(
      {required String comboID, required String time}) async {
    final response = await networkClient.post(
        endpoint: EndpointConstant.setReminderForCombo,
        isAuthHeaderRequired: true,
        data: {
          "comboGround": comboID,
          "reminder": time,
        });
    return response.message;
  }

  // joinComboGround

  @override
  Future<String> joinComboGround({required String comboID}) async {
    final response = await networkClient.post(
        endpoint: EndpointConstant.joinComboGround,
        isAuthHeaderRequired: true,
        data: {
          "combo": comboID,
        });
    return response.message;
  }

  @override
  Future<String> leaveComboGround({required String comboID}) async {
    final response = await networkClient.post(
        endpoint: EndpointConstant.leaveComboGround,
        isAuthHeaderRequired: true,
        data: {
          "combo": comboID,
        });
    print(
        "This is the response coming from leaving combo-ground ${response.data.toString()}");
    return response.message;
  }

  @override
  Future<SwitchDeviceResult> switchDevice({required String comboID, required String deviceId}) async {
    final response = await networkClient.post(
      endpoint: EndpointConstant.switchDevice,
      isAuthHeaderRequired: true,
      data: {
        'combo': comboID,
      },
    );
    
    return SwitchDeviceResult.fromJson(response.data);
  }

  @override
  Future<JoinCompanionResult> joinCompanion({required String comboID, required String deviceId}) async {
    final response = await networkClient.post(
      endpoint: EndpointConstant.joinCompanion,
      isAuthHeaderRequired: true,
      data: {
        'combo': comboID,
      },
    );
    
    return JoinCompanionResult.fromJson(response.data);
  }

  @override
  Future<String> rescheduleChallenge(
      {required String postID, required String newTime}) async {
    print(postID);
    print("----this is rgw rime $newTime");
    final response = await networkClient.post(
        endpoint: EndpointConstant.rescheduleChallenge,
        isAuthHeaderRequired: true,
        data: {
          'challenge': postID,
          'time': newTime,
        });
    return response.message;
  }

  @override
  Future<LiveComboModel> getSingleLiveCombo({required String comboId}) async {
    print('Time to get the single combo of $comboId');
    try {
      final response = await networkClient.get(
        endpoint: '${EndpointConstant.getLiveCombo}$comboId',
        isAuthHeaderRequired: true,
      );
      print("This is the response data here ------ ${response.data}");
      final resultMap = LiveComboModel.fromMap(response.data);
      print("*****The converted result of Live is ${resultMap.stake}");
      return resultMap;
    } catch (e) {
      print("This is the error message ${e.toString()}");
      rethrow;
    }
  }
}

/// Result class for switch-device API response
class SwitchDeviceResult {
  final bool success;
  final String? oldDeviceId;
  final String? newDeviceId;
  final String? message;

  SwitchDeviceResult({
    required this.success,
    this.oldDeviceId,
    this.newDeviceId,
    this.message,
  });

  factory SwitchDeviceResult.fromJson(Map<String, dynamic> json) {
    return SwitchDeviceResult(
      success: json['success'] ?? false,
      oldDeviceId: json['data']?['old_device_id'],
      newDeviceId: json['data']?['new_device_id'],
      message: json['message'],
    );
  }
}

/// Result class for join-companion API response
class JoinCompanionResult {
  final bool success;
  final String? deviceId;
  final String? deviceRole;
  final String? message;

  JoinCompanionResult({
    required this.success,
    this.deviceId,
    this.deviceRole,
    this.message,
  });

  factory JoinCompanionResult.fromJson(Map<String, dynamic> json) {
    return JoinCompanionResult(
      success: json['success'] ?? false,
      deviceId: json['data']?['device_id'],
      deviceRole: json['data']?['device_role'],
      message: json['message'],
    );
  }
}

// leaveComboGround
