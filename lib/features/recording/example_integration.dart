import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clapmi/features/livestream/presentation/blocs/recording/recording_bloc.dart';
import 'package:clapmi/features/livestream/presentation/widgets/pop_record.dart';
import 'package:clapmi/features/livestream/presentation/widgets/recording_controls_sheet.dart';
import 'package:clapmi/features/livestream/presentation/widgets/confirm_variant.dart';
import 'package:clapmi/features/livestream/presentation/widgets/record_started_notification.dart';
import 'package:clapmi/features/livestream/presentation/widgets/download_file_container.dart';
import 'package:clapmi/features/livestream/presentation/widgets/recording_indicator.dart';
import 'package:clapmi/features/livestream/data/models/recording_model.dart';

/// Example integration showing how to use the recording feature
/// This demonstrates both recording flows described in the documentation
class ExampleLivestreamIntegration extends StatefulWidget {
  final String roomId;

  const ExampleLivestreamIntegration({
    super.key,
    required this.roomId,
  });

  @override
  State<ExampleLivestreamIntegration> createState() =>
      _ExampleLivestreamIntegrationState();
}

class _ExampleLivestreamIntegrationState
    extends State<ExampleLivestreamIntegration> {
  String? _currentRecordingId;
  RecordingStatus _recordingStatus = RecordingStatus.idle;

  @override
  Widget build(BuildContext context) {
    return BlocListener<RecordingBloc, RecordingState>(
      listener: (context, state) {
        if (state is RecordingStarted) {
          setState(() {
            _currentRecordingId = state.recording.recordingId;
            _recordingStatus = RecordingStatus.recording;
          });
          // Show record started notification
          _showRecordStartedNotification();
        } else if (state is RecordingStopped) {
          setState(() {
            _recordingStatus = RecordingStatus.stopped;
          });
          // Show download file container
          _showDownloadContainer(
            state.recording.recordingId,
            state.recording.downloadUrl ?? '',
            state.recording.duration,
          );
        } else if (state is RecordingError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Recording error: ${state.message}')),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Livestream with Recording'),
          actions: [
            // Recording indicator in app bar
            RecordingIndicator(
              isRecording: _recordingStatus == RecordingStatus.recording,
              onTap: _showRecordingControlsSheet,
            ),
            // Hamburger menu for recording controls
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: _showRecordingControlsSheet,
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Room ID: ${widget.roomId}'),
              const SizedBox(height: 20),
              Text('Recording Status: ${_recordingStatus.name}'),
              const SizedBox(height: 20),

              // Flow 1: PopRecord on livestream creation
              ElevatedButton(
                onPressed: _showPopRecordDialog,
                child: const Text('Start Livestream (Flow 1)'),
              ),

              const SizedBox(height: 20),

              // Flow 2: Direct recording controls via hamburger
              ElevatedButton(
                onPressed: _showRecordingControlsSheet,
                child: const Text('Recording Controls (Flow 2)'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Flow 1: PopRecord -> ConfirmVariant -> RecordStartedNotification -> DownloadFileContainer
  void _showPopRecordDialog() {
    showDialog(
      context: context,
      builder: (context) => PopRecord(
        onYes: () {
          Navigator.pop(context);
          _showConfirmVariantDialog();
        },
        onNo: () => Navigator.pop(context),
        onLater: () => Navigator.pop(context),
      ),
    );
  }

  void _showConfirmVariantDialog() {
    showDialog(
      context: context,
      builder: (context) => ConfirmVariant(
        onConfirm: () {
          Navigator.pop(context);
          _startRecording();
        },
        onCancel: () => Navigator.pop(context),
      ),
    );
  }

  void _showRecordStartedNotification() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => RecordStartedNotification(
        onDismiss: () => Navigator.pop(context),
      ),
    );

    // Auto-dismiss after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    });
  }

  void _showDownloadContainer(
      String recordingId, String downloadUrl, int? duration) {
    showDialog(
      context: context,
      builder: (context) => DownloadFileContainer(
        recordingId: recordingId,
        downloadUrl: downloadUrl,
        duration: duration,
        onClose: () => Navigator.pop(context),
      ),
    );
  }

  /// Flow 2: Hamburger menu -> RecordingControlsSheet
  void _showRecordingControlsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => RecordingControlsSheet(
        recordingStatus: _recordingStatus,
        recordingId: _currentRecordingId,
        onScreenShare: () => Navigator.pop(context),
        onStartRecording: () {
          Navigator.pop(context);
          _startRecording();
        },
        onStopRecording: () {
          Navigator.pop(context);
          _stopRecording();
        },
        onClose: () => Navigator.pop(context),
      ),
    );
  }

  void _startRecording() {
    context.read<RecordingBloc>().add(
          StartRecording(roomId: widget.roomId),
        );
  }

  void _stopRecording() {
    if (_currentRecordingId != null) {
      context.read<RecordingBloc>().add(
            StopRecording(recordingId: _currentRecordingId!),
          );
    }
  }
}
