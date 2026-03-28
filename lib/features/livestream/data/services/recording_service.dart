import 'dart:async';
import 'package:clapmi/features/livestream/data/datasources/recording_remote_datasource.dart';
import 'package:clapmi/features/livestream/data/models/recording_model.dart';

/// Service class that manages recording operations and state
class RecordingService {
  final RecordingRemoteDataSource _remoteDataSource;

  RecordingModel? _currentRecording;
  final StreamController<RecordingModel?> _recordingController =
      StreamController<RecordingModel?>.broadcast();

  RecordingService({required RecordingRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource {
    // Listen for recording status updates from server
    _remoteDataSource.listenForRecordingStatus((status) {
      _handleStatusUpdate(status);
    });
  }

  /// Get the current recording state
  RecordingModel? get currentRecording => _currentRecording;

  /// Stream of recording state changes
  Stream<RecordingModel?> get recordingStream => _recordingController.stream;

  /// Check if currently recording
  bool get isRecording =>
      _currentRecording?.status == RecordingStatus.recording;

  /// Start recording a livestream
  Future<Map<String, dynamic>> startRecording({required String roomId}) async {
    final result = await _remoteDataSource.startRecording(roomId: roomId);

    if (result['success'] == true) {
      _currentRecording = RecordingModel(
        recordingId: result['recordingId'] as String,
        roomId: roomId,
        status: RecordingStatus.recording,
        startedAt: DateTime.now(),
      );
      _recordingController.add(_currentRecording);
    }

    return result;
  }

  /// Stop recording a livestream
  Future<Map<String, dynamic>> stopRecording(
      {required String recordingId}) async {
    final result =
        await _remoteDataSource.stopRecording(recordingId: recordingId);

    if (result['success'] == true) {
      _currentRecording = RecordingModel(
        recordingId: result['recordingId'] as String,
        roomId: _currentRecording?.roomId ?? '',
        status: RecordingStatus.stopped,
        duration: result['duration'] as int?,
        downloadUrl: result['downloadUrl'] as String?,
        stoppedAt: DateTime.now(),
      );
      _recordingController.add(_currentRecording);
    }

    return result;
  }

  /// Handle status updates from server
  void _handleStatusUpdate(Map<String, dynamic> status) {
    final recordingId = status['recordingId'] as String?;
    final statusStr = status['status'] as String?;

    if (recordingId != null && statusStr != null) {
      final recordingStatus = RecordingModel.parseStatus(statusStr);

      if (recordingStatus == RecordingStatus.recording) {
        _currentRecording = RecordingModel(
          recordingId: recordingId,
          roomId: status['roomId'] as String? ?? '',
          status: RecordingStatus.recording,
          startedAt: DateTime.now(),
        );
      } else if (recordingStatus == RecordingStatus.stopped) {
        _currentRecording = RecordingModel(
          recordingId: recordingId,
          roomId: status['roomId'] as String? ?? '',
          status: RecordingStatus.stopped,
          duration: status['duration'] as int?,
          downloadUrl: status['downloadUrl'] as String?,
          stoppedAt: DateTime.now(),
        );
      } else if (recordingStatus == RecordingStatus.error) {
        _currentRecording = RecordingModel(
          recordingId: recordingId,
          roomId: status['roomId'] as String? ?? '',
          status: RecordingStatus.error,
        );
      }

      _recordingController.add(_currentRecording);
    }
  }

  /// Reset recording state
  void reset() {
    _currentRecording = null;
    _recordingController.add(null);
  }

  /// Dispose resources
  void dispose() {
    _remoteDataSource.removeRecordingStatusListener();
    _recordingController.close();
  }
}
