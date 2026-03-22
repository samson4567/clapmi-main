import 'package:envied/envied.dart';
import 'package:flutter/foundation.dart';

part 'multi_env.g.dart';

@Envied(path: '.env', name: 'ProductionEnv')
@Envied(path: '.env_debug', name: 'DebugEnv')
final class MultiEnv {
  // static const bool kDebugMode;

  factory MultiEnv() => _instance;

  static final MultiEnv _instance = switch (!kDebugMode) {
    true => _DebugEnv(),
    false => _ProductionEnv(),
  }; //

  @EnviedField(varName: 'API-URL')
  final String apiUrl = _instance.apiUrl;

  @EnviedField(varName: 'WEBSOCKET-API-URL')
  final String webSocketApiUrl = _instance.webSocketApiUrl;

  @EnviedField(varName: 'WEBSOCKET-AUTH-URL')
  final String webSocketAuthUrl = _instance.webSocketAuthUrl;

  @EnviedField(varName: 'SOCKET-IO-URL')
  final String socketIoUrl = _instance.socketIoUrl;

  @EnviedField(varName: 'SOCKET-PATH')
  final String socketPath = _instance.socketPath;

  @EnviedField(varName: 'TWITTER-HANDLE')
  final String xHandle = _instance.xHandle;

  @EnviedField(varName: 'INSTANGRAM-HANDLE')
  final String instangramHandle = _instance.instangramHandle;

  @EnviedField(varName: 'TIKTOK-HANDLE')
  final String tiktokHandle = _instance.tiktokHandle;

  @EnviedField(varName: 'DISCORD-SERVER')
  final String discordServer = _instance.discordServer;
}
