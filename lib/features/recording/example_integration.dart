/// Example: How to integrate the recording feature into your livestream screen
/// 
/// This file demonstrates both ways to implement recording:
/// 1. PopRecord widget (automatic prompt after creating livestream)
/// 2. RecordingControlsSheet (manual control via hamburger button)
///
/// Follow the steps below to integrate into your existing livestream screen.

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:clapmi/features/recording/services/recording_service.dart';
import 'package:clapmi/features/recording/widgets/index.dart';

/// This is an example widget showing how to integrate recording features.
/// Do NOT use this directly in your app - instead, follow the integration
/// steps at the bottom of this file to add recording to your existing
/// SingleLiveStreaming screen.
class ExampleLivestreamIntegration extends StatefulWidget {
  final String roomId;
  final io.Socket socket;

  const ExampleLivestreamIntegration({
    super.key,
    required this.roomId,
    required this.socket,
  });

  @override
  State<ExampleLivestreamIntegration> createState() =>
      _ExampleLivestreamIntegrationState();
}

class _ExampleLivestreamIntegrationState
    extends State<ExampleLivestreamIntegration> {
  late RecordingService _recordingService;
  bool _isRecording = false;
  bool _showRecordStartedNotification = false;
  String? _recordingId;
  String? _downloadUrl;
  int _recordingDuration = 0;

  @override
  void initState() {
    super.initState();
    _initializeRecording();
  }

  void _initializeRecording() {
    // Initialize recording service with socket connection
    _recordingService = RecordingService();
    _recordingService.initialize(widget.socket, widget.roomId);

    // Listen to recording state changes
    _recordingService.recordingStateStream.listen((state) {
      if (mounted) {
        setState(() {
          _isRecording = state == RecordingState.recording;
        });
      }
    });

    // Listen to recording started events
    _recordingService.recordingStartedStream.listen((event) {
      if (mounted) {
        setState(() {
          _recordingId = event.recordingId;
          _showRecordStartedNotification = true;
        });

        // Hide notification after 2 seconds
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              _showRecordStartedNotification = false;
            });
          }
        });
      }
    });

    // Listen to recording stopped events
    _recordingService.recordingStoppedStream.listen((event) {
      if (mounted) {
        setState(() {
          _recordingId = event.recordingId;
          _downloadUrl = event.downloadUrl;
          _recordingDuration = event.duration;
        });

        // Show download dialog when livestream ends
        _showDownloadDialog();
      }
    });

    // Listen to recording errors
    _recordingService.recordingErrorStream.listen((error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Recording error: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _recordingService.dispose();
    super.dispose();
  }

  // =========================================================================
  // WAY 1: PopRecord Widget (Automatic prompt after creating livestream)
  // =========================================================================
  void _showPopRecordDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopRecord(
        onYes: () {
          Navigator.pop(context);
          _showConfirmVariantDialog();
        },
        onNo: () {
          Navigator.pop(context);
          // User chose not to record
        },
        onLater: () {
          Navigator.pop(context);
          // User chose to decide later
        },
      ),
    );
  }

  void _showConfirmVariantDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ConfirmVariant(
        onConfirm: () async {
          Navigator.pop(context);
          await _startRecording();
        },
        onCancel: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  // =========================================================================
  // WAY 2: RecordingControlsSheet (Manual control via hamburger button)
  // =========================================================================
  void _showRecordingControlsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => RecordingControlsSheet(
        initialRecordingState: _isRecording,
        onRecordingStateChanged: (isRecording) async {
          if (isRecording) {
            await _startRecording();
          } else {
            await _stopRecording();
          }
        },
      ),
    );
  }

  // =========================================================================
  // Recording Actions
  // =========================================================================
  Future<void> _startRecording() async {
    final result = await _recordingService.startRecording();
    
    if (!result.success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.errorMessage ?? 'Failed to start recording'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _stopRecording() async {
    final result = await _recordingService.stopRecording();
    
    if (!result.success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.errorMessage ?? 'Failed to stop recording'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showDownloadDialog() {
    if (_downloadUrl == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => DownloadFileContainer(
        downloadUrl: _downloadUrl!,
        recordingId: _recordingId ?? '',
        duration: _recordingDuration,
        onClose: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Livestream'),
        actions: [
          // Recording indicator in header
          if (_isRecording)
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: StaticRecordingIndicator(isRecording: true),
            ),
        ],
      ),
      body: Stack(
        children: [
          // Your livestream content here
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _isRecording ? 'Recording...' : 'Not Recording',
                  style: TextStyle(
                    fontSize: 24,
                    color: _isRecording ? Colors.red : Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                
                // Button to show PopRecord dialog (Way 1)
                ElevatedButton(
                  onPressed: _showPopRecordDialog,
                  child: const Text('Show PopRecord Dialog'),
                ),
                const SizedBox(height: 10),
                
                // Button to show RecordingControlsSheet (Way 2)
                ElevatedButton(
                  onPressed: _showRecordingControlsSheet,
                  child: const Text('Show Recording Controls'),
                ),
              ],
            ),
          ),

          // Record started notification overlay
          if (_showRecordStartedNotification)
            RecordStartedNotification(
              onComplete: () {
                setState(() {
                  _showRecordStartedNotification = false;
                });
              },
            ),
        ],
      ),
    );
  }
}

/// Integration Steps for your existing SingleLiveStreaming screen:
/// 
/// 1. Add recording service to your state:
///    ```dart
///    late RecordingService _recordingService;
///    bool _isRecording = false;
///    bool _showRecordStartedNotification = false;
///    String? _recordingId;
///    String? _downloadUrl;
///    int _recordingDuration = 0;
///    ```
/// 
/// 2. Initialize recording service in initState():
///    ```dart
///    @override
///    void initState() {
///      super.initState();
///      _recordingService = RecordingService();
///      _recordingService.initialize(socket, roomId);
///      
///      // Listen to streams
///      _recordingService.recordingStateStream.listen((state) {
///        setState(() => _isRecording = state == RecordingState.recording);
///      });
///      
///      _recordingService.recordingStartedStream.listen((event) {
///        setState(() {
///          _recordingId = event.recordingId;
///          _showRecordStartedNotification = true;
///        });
///        Future.delayed(const Duration(seconds: 2), () {
///          setState(() => _showRecordStartedNotification = false);
///        });
///      });
///      
///      _recordingService.recordingStoppedStream.listen((event) {
///        setState(() {
///          _recordingId = event.recordingId;
///          _downloadUrl = event.downloadUrl;
///          _recordingDuration = event.duration;
///        });
///        _showDownloadDialog();
///      });
///    }
///    ```
/// 
/// 3. Add recording indicator to your header:
///    ```dart
///    // In your header Row, add:
///    if (_isRecording) const StaticRecordingIndicator(isRecording: true),
///    ```
/// 
/// 4. Update LiveStreamBottomSession to pass recording state:
///    ```dart
///    LiveStreamBottomSession(
///      // ... existing parameters
///      isLiveRecording: _isRecording,
///      onLiveRecordingPressed: (isRecording) async {
///        if (isRecording) {
///          await _startRecording();
///        } else {
///          await _stopRecording();
///        }
///      },
///    )
///    ```
/// 
/// 5. Add notification overlay to your Stack:
///    ```dart
///    Stack(
///      children: [
///        // ... your existing content
///        if (_showRecordStartedNotification)
///          RecordStartedNotification(
///            onComplete: () => setState(() => _showRecordStartedNotification = false),
///          ),
///      ],
///    )
///    ```
/// 
/// 6. Call _showPopRecordDialog() after creating a livestream (Way 1)
///    or let users use the hamburger button (Way 2)
