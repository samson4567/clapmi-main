import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

/// Service to handle livestream recording via Socket.IO
/// Uses server-side recording with Mediasoup - no platform-specific recording APIs needed
class RecordingService {
  io.Socket? _socket;
  bool _isRecording = false;
  String? _currentRecordingId;
  String? _roomId;
  
  // Stream controllers for recording state
  final _recordingStateController = StreamController<RecordingState>.broadcast();
  final _recordingStartedController = StreamController<RecordingStartedEvent>.broadcast();
  final _recordingStoppedController = StreamController<RecordingStoppedEvent>.broadcast();
  final _recordingErrorController = StreamController<String>.broadcast();

  // Getters
  bool get isRecording => _isRecording;
  String? get currentRecordingId => _currentRecordingId;
  Stream<RecordingState> get recordingStateStream => _recordingStateController.stream;
  Stream<RecordingStartedEvent> get recordingStartedStream => _recordingStartedController.stream;
  Stream<RecordingStoppedEvent> get recordingStoppedStream => _recordingStoppedController.stream;
  Stream<String> get recordingErrorStream => _recordingErrorController.stream;

  /// Initialize the recording service with an existing socket connection
  void initialize(io.Socket socket, String roomId) {
    _socket = socket;
    _roomId = roomId;
    _setupSocketListeners();
  }

  /// Setup socket listeners for recording events
  void _setupSocketListeners() {
    if (_socket == null) return;

    // Listen for recording started confirmation
    _socket?.on('recording-started', (data) {
      debugPrint('🎬 Recording started: $data');
      final recordingId = data['recordingId'] as String?;
      if (recordingId != null) {
        _isRecording = true;
        _currentRecordingId = recordingId;
        _recordingStateController.add(RecordingState.recording);
        _recordingStartedController.add(RecordingStartedEvent(
          recordingId: recordingId,
          roomId: _roomId ?? '',
        ));
      }
    });

    // Listen for recording stopped confirmation
    _socket?.on('recording-stopped', (data) {
      debugPrint('🛑 Recording stopped: $data');
      final recordingId = data['recordingId'] as String?;
      final duration = data['duration'] as int?;
      final downloadUrl = data['downloadUrl'] as String?;
      
      _isRecording = false;
      _recordingStateController.add(RecordingState.stopped);
      _recordingStoppedController.add(RecordingStoppedEvent(
        recordingId: recordingId ?? _currentRecordingId ?? '',
        duration: duration ?? 0,
        downloadUrl: downloadUrl ?? '',
      ));
      _currentRecordingId = null;
    });

    // Listen for recording errors
    _socket?.on('recording-error', (data) {
      debugPrint('❌ Recording error: $data');
      final errorMessage = data['message'] as String? ?? 'Recording error occurred';
      _recordingErrorController.add(errorMessage);
      _isRecording = false;
      _recordingStateController.add(RecordingState.error);
    });
  }

  /// Start recording the livestream
  /// Emits 'start-recording' event to the server
  Future<RecordingResult> startRecording() async {
    if (_socket == null || _roomId == null) {
      return RecordingResult(
        success: false,
        errorMessage: 'Socket not connected or room ID not set',
      );
    }

    if (_isRecording) {
      return RecordingResult(
        success: false,
        errorMessage: 'Already recording',
      );
    }

    try {
      debugPrint('🎬 Emitting start-recording for room: $_roomId');
      
      // Use emitWithAck to wait for server confirmation
      final completer = Completer<RecordingResult>();
      
      _socket?.emitWithAck('start-recording', {'roomId': _roomId}, ack: (data) {
        debugPrint('🎬 Start recording ack: $data');
        if (data['success'] == true) {
          final recordingId = data['recordingId'] as String?;
          if (recordingId != null) {
            _isRecording = true;
            _currentRecordingId = recordingId;
            _recordingStateController.add(RecordingState.recording);
            _recordingStartedController.add(RecordingStartedEvent(
              recordingId: recordingId,
              roomId: _roomId ?? '',
            ));
            completer.complete(RecordingResult(
              success: true,
              recordingId: recordingId,
            ));
          } else {
            completer.complete(RecordingResult(
              success: false,
              errorMessage: 'No recording ID received',
            ));
          }
        } else {
          final errorMessage = data['error'] as String? ?? 'Failed to start recording';
          completer.complete(RecordingResult(
            success: false,
            errorMessage: errorMessage,
          ));
        }
      });

      // Timeout after 10 seconds
      return completer.future.timeout(
        const Duration(seconds: 10),
        onTimeout: () => RecordingResult(
          success: false,
          errorMessage: 'Recording start request timed out',
        ),
      );
    } catch (e) {
      debugPrint('❌ Error starting recording: $e');
      return RecordingResult(
        success: false,
        errorMessage: 'Error starting recording: $e',
      );
    }
  }

  /// Stop recording the livestream
  /// Emits 'stop-recording' event to the server
  Future<RecordingResult> stopRecording() async {
    if (_socket == null) {
      return RecordingResult(
        success: false,
        errorMessage: 'Socket not connected',
      );
    }

    if (!_isRecording || _currentRecordingId == null) {
      return RecordingResult(
        success: false,
        errorMessage: 'No active recording to stop',
      );
    }

    try {
      debugPrint('🛑 Emitting stop-recording for recordingId: $_currentRecordingId');
      
      final completer = Completer<RecordingResult>();
      
      _socket?.emitWithAck('stop-recording', {'recordingId': _currentRecordingId}, ack: (data) {
        debugPrint('🛑 Stop recording ack: $data');
        if (data['success'] == true) {
          final recordingId = data['recordingId'] as String?;
          final duration = data['duration'] as int?;
          final downloadUrl = data['downloadUrl'] as String?;
          
          _isRecording = false;
          _recordingStateController.add(RecordingState.stopped);
          _recordingStoppedController.add(RecordingStoppedEvent(
            recordingId: recordingId ?? _currentRecordingId ?? '',
            duration: duration ?? 0,
            downloadUrl: downloadUrl ?? '',
          ));
          _currentRecordingId = null;
          
          completer.complete(RecordingResult(
            success: true,
            recordingId: recordingId,
            duration: duration,
            downloadUrl: downloadUrl,
          ));
        } else {
          final errorMessage = data['error'] as String? ?? 'Failed to stop recording';
          completer.complete(RecordingResult(
            success: false,
            errorMessage: errorMessage,
          ));
        }
      });

      // Timeout after 10 seconds
      return completer.future.timeout(
        const Duration(seconds: 10),
        onTimeout: () => RecordingResult(
          success: false,
          errorMessage: 'Recording stop request timed out',
        ),
      );
    } catch (e) {
      debugPrint('❌ Error stopping recording: $e');
      return RecordingResult(
        success: false,
        errorMessage: 'Error stopping recording: $e',
      );
    }
  }

  /// Dispose the service and clean up resources
  void dispose() {
    _socket?.off('recording-started');
    _socket?.off('recording-stopped');
    _socket?.off('recording-error');
    _recordingStateController.close();
    _recordingStartedController.close();
    _recordingStoppedController.close();
    _recordingErrorController.close();
  }
}

/// Recording state enum
enum RecordingState {
  idle,
  recording,
  stopped,
  error,
}

/// Event emitted when recording starts
class RecordingStartedEvent {
  final String recordingId;
  final String roomId;

  RecordingStartedEvent({
    required this.recordingId,
    required this.roomId,
  });
}

/// Event emitted when recording stops
class RecordingStoppedEvent {
  final String recordingId;
  final int duration;
  final String downloadUrl;

  RecordingStoppedEvent({
    required this.recordingId,
    required this.duration,
    required this.downloadUrl,
  });
}

/// Result of a recording operation
class RecordingResult {
  final bool success;
  final String? recordingId;
  final int? duration;
  final String? downloadUrl;
  final String? errorMessage;

  RecordingResult({
    required this.success,
    this.recordingId,
    this.duration,
    this.downloadUrl,
    this.errorMessage,
  });
}
