import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

/// Remote data source for recording operations via Socket.IO
class RecordingRemoteDataSource {
  IO.Socket? _socket;

  RecordingRemoteDataSource();

  /// Set the socket instance to use for recording operations
  void setSocket(IO.Socket socket) {
    _socket = socket;
    debugPrint('✅ RecordingRemoteDataSource: Socket set successfully');
  }

  /// Check if socket is available
  bool get isSocketAvailable => _socket != null && _socket!.connected;

  /// Start recording a livestream
  /// Returns a map with 'success' and 'recordingId' or 'error'
  Future<Map<String, dynamic>> startRecording({required String roomId}) async {
    debugPrint(
        '🎬 RecordingRemoteDataSource.startRecording called for roomId: $roomId');
    if (_socket == null) {
      debugPrint('❌ RecordingRemoteDataSource: Socket is null');
      return {'error': 'Socket not initialized'};
    }
    if (!_socket!.connected) {
      debugPrint('❌ RecordingRemoteDataSource: Socket not connected');
      return {'error': 'Socket not connected'};
    }
    debugPrint(
        '✅ RecordingRemoteDataSource: Socket is connected, emitting start-recording');

    final completer = Completer<Map<String, dynamic>>();

    _socket!.emitWithAck('start-recording', {'roomId': roomId}, ack: (data) {
      if (data is Map<String, dynamic>) {
        completer.complete(data);
      } else {
        completer.complete({'error': 'Invalid response format'});
      }
    });

    // Timeout after 10 seconds
    return completer.future.timeout(
      const Duration(seconds: 10),
      onTimeout: () => {'error': 'Request timeout'},
    );
  }

  /// Stop recording a livestream
  /// Returns a map with 'success', 'recordingId', 'duration', and 'downloadUrl' or 'error'
  Future<Map<String, dynamic>> stopRecording(
      {required String recordingId}) async {
    debugPrint(
        '🛑 RecordingRemoteDataSource.stopRecording called for recordingId: $recordingId');
    if (_socket == null) {
      debugPrint('❌ RecordingRemoteDataSource: Socket is null');
      return {'error': 'Socket not initialized'};
    }
    if (!_socket!.connected) {
      debugPrint('❌ RecordingRemoteDataSource: Socket not connected');
      return {'error': 'Socket not connected'};
    }
    debugPrint(
        '✅ RecordingRemoteDataSource: Socket is connected, emitting stop-recording');

    final completer = Completer<Map<String, dynamic>>();

    _socket!.emitWithAck('stop-recording', {'recordingId': recordingId},
        ack: (data) {
      if (data is Map<String, dynamic>) {
        completer.complete(data);
      } else {
        completer.complete({'error': 'Invalid response format'});
      }
    });

    // Timeout after 30 seconds (FFmpeg may take time to stop)
    return completer.future.timeout(
      const Duration(seconds: 30),
      onTimeout: () => {'error': 'Request timeout'},
    );
  }

  /// Listen for recording status updates from server
  void listenForRecordingStatus(Function(Map<String, dynamic>) onStatusUpdate) {
    _socket?.on('recording-status', (data) {
      if (data is Map<String, dynamic>) {
        onStatusUpdate(data);
      }
    });
  }

  /// Remove recording status listener
  void removeRecordingStatusListener() {
    _socket?.off('recording-status');
  }
}
