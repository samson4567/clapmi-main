import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clapmi/features/livestream/data/datasources/recording_remote_datasource.dart';
import 'package:clapmi/features/livestream/data/models/recording_model.dart';

// Events
abstract class RecordingEvent {
  const RecordingEvent();
}

class StartRecording extends RecordingEvent {
  final String roomId;
  const StartRecording({required this.roomId});
}

class StopRecording extends RecordingEvent {
  final String recordingId;
  const StopRecording({required this.recordingId});
}

class RecordingStatusUpdated extends RecordingEvent {
  final Map<String, dynamic> status;
  const RecordingStatusUpdated({required this.status});
}

class ResetRecording extends RecordingEvent {
  const ResetRecording();
}

// States
abstract class RecordingState {
  const RecordingState();
}

class RecordingInitial extends RecordingState {
  const RecordingInitial();
}

class RecordingLoading extends RecordingState {
  const RecordingLoading();
}

class RecordingStarted extends RecordingState {
  final RecordingModel recording;
  const RecordingStarted({required this.recording});
}

class RecordingStopped extends RecordingState {
  final RecordingModel recording;
  const RecordingStopped({required this.recording});
}

class RecordingError extends RecordingState {
  final String message;
  const RecordingError({required this.message});
}

// BLoC
class RecordingBloc extends Bloc<RecordingEvent, RecordingState> {
  final RecordingRemoteDataSource recordingDataSource;
  StreamSubscription? _statusSubscription;

  RecordingBloc({required this.recordingDataSource})
      : super(const RecordingInitial()) {
    on<StartRecording>(_onStartRecording);
    on<StopRecording>(_onStopRecording);
    on<RecordingStatusUpdated>(_onRecordingStatusUpdated);
    on<ResetRecording>(_onResetRecording);

    // Listen for recording status updates
    recordingDataSource.listenForRecordingStatus((status) {
      add(RecordingStatusUpdated(status: status));
    });
  }

  Future<void> _onStartRecording(
    StartRecording event,
    Emitter<RecordingState> emit,
  ) async {
    debugPrint(
        '🎬 RecordingBloc._onStartRecording called for roomId: ${event.roomId}');
    emit(const RecordingLoading());

    try {
      final result = await recordingDataSource.startRecording(
        roomId: event.roomId,
      );

      if (result.containsKey('error')) {
        final errorMessage = result['error'] as String;
        debugPrint('❌ RecordingBloc: Error from datasource: $errorMessage');
        // Provide user-friendly error messages
        String userMessage = errorMessage;
        if (errorMessage.contains('No active streams to record')) {
          userMessage =
              'Cannot start recording: The livestream is not active yet. Please wait for the stream to start.';
        } else if (errorMessage.contains('Socket not connected')) {
          userMessage =
              'Cannot start recording: Connection to server lost. Please reconnect.';
        } else if (errorMessage.contains('Socket not initialized')) {
          userMessage =
              'Cannot start recording: Server connection not established.';
        }
        emit(RecordingError(message: userMessage));
      } else if (result['success'] == true) {
        debugPrint('✅ RecordingBloc: Recording started successfully');
        final recording = RecordingModel(
          recordingId: result['recordingId'] as String,
          roomId: event.roomId,
          status: RecordingStatus.recording,
          startedAt: DateTime.now(),
        );
        emit(RecordingStarted(recording: recording));
      } else {
        debugPrint('❌ RecordingBloc: Unknown response format: $result');
        emit(const RecordingError(message: 'Failed to start recording'));
      }
    } catch (e) {
      debugPrint('❌ RecordingBloc: Exception during startRecording: $e');
      emit(RecordingError(message: 'Error starting recording: $e'));
    }
  }

  Future<void> _onStopRecording(
    StopRecording event,
    Emitter<RecordingState> emit,
  ) async {
    debugPrint(
        '🛑 RecordingBloc._onStopRecording called for recordingId: ${event.recordingId}');
    emit(const RecordingLoading());

    try {
      final result = await recordingDataSource.stopRecording(
        recordingId: event.recordingId,
      );

      if (result.containsKey('error')) {
        final errorMessage = result['error'] as String;
        debugPrint('❌ RecordingBloc: Error from datasource: $errorMessage');
        // Provide user-friendly error messages
        String userMessage = errorMessage;
        if (errorMessage.contains('Socket not connected')) {
          userMessage =
              'Cannot stop recording: Connection to server lost. Please reconnect.';
        } else if (errorMessage.contains('Socket not initialized')) {
          userMessage =
              'Cannot stop recording: Server connection not established.';
        }
        emit(RecordingError(message: userMessage));
      } else if (result['success'] == true) {
        debugPrint('✅ RecordingBloc: Recording stopped successfully');
        final recording = RecordingModel(
          recordingId: result['recordingId'] as String,
          roomId: '',
          status: RecordingStatus.stopped,
          duration: result['duration'] as int?,
          downloadUrl: result['downloadUrl'] as String?,
          stoppedAt: DateTime.now(),
        );
        emit(RecordingStopped(recording: recording));
      } else {
        debugPrint('❌ RecordingBloc: Unknown response format: $result');
        emit(const RecordingError(message: 'Failed to stop recording'));
      }
    } catch (e) {
      debugPrint('❌ RecordingBloc: Exception during stopRecording: $e');
      emit(RecordingError(message: 'Error stopping recording: $e'));
    }
  }

  void _onRecordingStatusUpdated(
    RecordingStatusUpdated event,
    Emitter<RecordingState> emit,
  ) {
    final status = event.status;
    final recordingId = status['recordingId'] as String?;
    final statusStr = status['status'] as String?;

    if (recordingId != null && statusStr != null) {
      final recordingStatus = RecordingModel.parseStatus(statusStr);

      if (recordingStatus == RecordingStatus.recording) {
        emit(RecordingStarted(
          recording: RecordingModel(
            recordingId: recordingId,
            roomId: status['roomId'] as String? ?? '',
            status: RecordingStatus.recording,
            startedAt: DateTime.now(),
          ),
        ));
      } else if (recordingStatus == RecordingStatus.stopped) {
        emit(RecordingStopped(
          recording: RecordingModel(
            recordingId: recordingId,
            roomId: status['roomId'] as String? ?? '',
            status: RecordingStatus.stopped,
            duration: status['duration'] as int?,
            downloadUrl: status['downloadUrl'] as String?,
            stoppedAt: DateTime.now(),
          ),
        ));
      } else if (recordingStatus == RecordingStatus.error) {
        emit(RecordingError(
          message: status['error'] as String? ?? 'Recording error occurred',
        ));
      }
    }
  }

  void _onResetRecording(
    ResetRecording event,
    Emitter<RecordingState> emit,
  ) {
    emit(const RecordingInitial());
  }

  @override
  Future<void> close() {
    _statusSubscription?.cancel();
    recordingDataSource.removeRecordingStatusListener();
    return super.close();
  }
}
