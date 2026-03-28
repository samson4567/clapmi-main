# Livestream Recording Feature - Integration Guide

## Overview

This guide explains how to integrate the livestream recording feature into the ClapMi platform. The recording feature allows users to record live streams and save recordings to their local device.

## Architecture

The recording feature uses Mediasoup server-side recording:
- Server creates server-side consumers
- Pipes RTP streams to FFmpeg
- Produces a downloadable .webm file

## Components

### 1. Data Layer

#### RecordingRemoteDataSource
- Location: `lib/features/livestream/data/datasources/recording_remote_datasource.dart`
- Handles Socket.IO events for start/stop recording
- Methods:
  - `startRecording({required String roomId})` - Starts recording
  - `stopRecording({required String recordingId})` - Stops recording
  - `listenForRecordingStatus()` - Listens for status updates

#### RecordingModel
- Location: `lib/features/livestream/data/models/recording_model.dart`
- Represents a recording session
- Properties:
  - `recordingId` - Unique identifier for the recording
  - `roomId` - The room being recorded
  - `status` - Recording status (idle, recording, stopped, error)
  - `duration` - Recording duration in seconds
  - `downloadUrl` - URL to download the recording
  - `startedAt` - When recording started
  - `stoppedAt` - When recording stopped

#### RecordingService
- Location: `lib/features/livestream/data/services/recording_service.dart`
- Manages recording state and operations
- Provides stream of recording state changes

### 2. State Management

#### RecordingBloc
- Location: `lib/features/livestream/presentation/blocs/recording/recording_bloc.dart`
- Events:
  - `StartRecording` - Start recording a room
  - `StopRecording` - Stop recording
  - `RecordingStatusUpdated` - Status update from server
  - `ResetRecording` - Reset recording state
- States:
  - `RecordingInitial` - Initial state
  - `RecordingLoading` - Processing request
  - `RecordingStarted` - Recording is active
  - `RecordingStopped` - Recording stopped with download URL
  - `RecordingError` - Error occurred

### 3. UI Widgets

#### PopRecord
- Location: `lib/features/livestream/presentation/widgets/pop_record.dart`
- Popup that appears when users create a livestream
- Options: Yes, No, Later
- Usage:
```dart
showDialog(
  context: context,
  builder: (context) => PopRecord(
    onYes: () {
      // Show confirmation dialog
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) => ConfirmVariant(
          onConfirm: () {
            // Start recording
            context.read<RecordingBloc>().add(
              StartRecording(roomId: roomId),
            );
            Navigator.pop(context);
          },
          onCancel: () => Navigator.pop(context),
        ),
      );
    },
    onNo: () => Navigator.pop(context),
    onLater: () => Navigator.pop(context),
  ),
);
```

#### ConfirmVariant
- Location: `lib/features/livestream/presentation/widgets/confirm_variant.dart`
- Confirmation dialog after user selects "Yes"
- Confirms user wants to start recording

#### RecordStartedNotification
- Location: `lib/features/livestream/presentation/widgets/record_started_notification.dart`
- Shows when recording starts
- Displays record_started.svg icon
- Auto-dismisses after 2 seconds
- Usage:
```dart
showOverlay(
  context: context,
  builder: (context) => RecordStartedNotification(
    onDismiss: () {
      // Hide overlay
    },
  ),
);
```

#### RecordingIndicator
- Location: `lib/features/livestream/presentation/widgets/recording_indicator.dart`
- Shows in livestream header when recording is active
- Displays pulsing red dot and "REC" text
- Usage:
```dart
RecordingIndicator(
  isRecording: state is RecordingStarted,
  onTap: () {
    // Show recording controls
  },
)
```

#### RecordingControlsSheet
- Location: `lib/features/livestream/presentation/widgets/recording_controls_sheet.dart`
- Bottom sheet with recording controls
- Appears when user clicks hamburger menu
- Options: Start/Stop Recording, Close
- Usage:
```dart
showModalBottomSheet(
  context: context,
  builder: (context) => RecordingControlsSheet(
    recordingStatus: recordingService.currentRecording?.status ?? RecordingStatus.idle,
    recordingId: recordingService.currentRecording?.recordingId,
    onStartRecording: () {
      context.read<RecordingBloc>().add(
        StartRecording(roomId: roomId),
      );
      Navigator.pop(context);
    },
    onStopRecording: () {
      context.read<RecordingBloc>().add(
        StopRecording(recordingId: recordingId),
      );
      Navigator.pop(context);
    },
    onClose: () => Navigator.pop(context),
  ),
);
```

#### DownloadFileContainer
- Location: `lib/features/livestream/presentation/widgets/download_file_container.dart`
- Appears when livestream ends and recording is available
- Allows users to download recording to local device
- Shows download progress
- Usage:
```dart
showDialog(
  context: context,
  builder: (context) => DownloadFileContainer(
    recordingId: recording.recordingId,
    downloadUrl: recording.downloadUrl!,
    duration: recording.duration,
    onClose: () => Navigator.pop(context),
    onDownloadComplete: (filePath) {
      // Show success message
    },
  ),
);
```

## Integration Steps

### 1. Add Recording Service to Dependency Injection

Add to `lib/core/di/injector.dart`:

```dart
import 'package:clapmi/features/livestream/data/datasources/recording_remote_datasource.dart';
import 'package:clapmi/features/livestream/data/services/recording_service.dart';
import 'package:clapmi/features/livestream/presentation/blocs/recording/recording_bloc.dart';

// In your setup function:
final socket = getItInstance<IO.Socket>();

// Register recording data source
getItInstance.registerLazySingleton(
  () => RecordingRemoteDataSource(socket: socket),
);

// Register recording service
getItInstance.registerLazySingleton(
  () => RecordingService(remoteDataSource: getItInstance()),
);

// Register recording BLoC
getItInstance.registerFactory(
  () => RecordingBloc(recordingDataSource: getItInstance()),
);
```

### 2. Integrate Recording Indicator in Livestream Header

Update `lib/screens/challenge/widgets/livestream _header.dart`:

```dart
import 'package:clapmi/features/livestream/presentation/widgets/recording_indicator.dart';

// In the Row widget (around line 173), add after the livrec.svg:
RecordingIndicator(
  isRecording: recordingService?.isRecording ?? false,
  onTap: () {
    // Show recording controls sheet
    showModalBottomSheet(
      context: context,
      builder: (context) => RecordingControlsSheet(
        recordingStatus: recordingService?.currentRecording?.status ?? RecordingStatus.idle,
        recordingId: recordingService?.currentRecording?.recordingId,
        onStartRecording: () {
          context.read<RecordingBloc>().add(
            StartRecording(roomId: comboId),
          );
          Navigator.pop(context);
        },
        onStopRecording: () {
          if (recordingService?.currentRecording?.recordingId != null) {
            context.read<RecordingBloc>().add(
              StopRecording(
                recordingId: recordingService!.currentRecording!.recordingId,
              ),
            );
          }
          Navigator.pop(context);
        },
        onClose: () => Navigator.pop(context),
      ),
    );
  },
),
```

### 3. Show PopRecord When Livestream Starts

In your livestream creation screen:

```dart
import 'package:clapmi/features/livestream/presentation/widgets/pop_record.dart';

// After livestream is created successfully:
showDialog(
  context: context,
  builder: (context) => PopRecord(
    onYes: () {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) => ConfirmVariant(
          onConfirm: () {
            context.read<RecordingBloc>().add(
              StartRecording(roomId: roomId),
            );
            Navigator.pop(context);
          },
          onCancel: () => Navigator.pop(context),
        ),
      );
    },
    onNo: () => Navigator.pop(context),
    onLater: () => Navigator.pop(context),
  ),
);
```

### 4. Show RecordStartedNotification

Listen to RecordingBloc state changes:

```dart
BlocListener<RecordingBloc, RecordingState>(
  listener: (context, state) {
    if (state is RecordingStarted) {
      // Show notification
      showOverlay(
        context: context,
        builder: (context) => RecordStartedNotification(
          onDismiss: () {
            // Hide overlay
          },
        ),
      );
    } else if (state is RecordingStopped) {
      // Show download dialog
      showDialog(
        context: context,
        builder: (context) => DownloadFileContainer(
          recordingId: state.recording.recordingId,
          downloadUrl: state.recording.downloadUrl!,
          duration: state.recording.duration,
          onClose: () => Navigator.pop(context),
          onDownloadComplete: (filePath) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Recording saved to: $filePath')),
            );
          },
        ),
      );
    } else if (state is RecordingError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Recording error: ${state.message}')),
      );
    }
  },
  child: YourLivestreamWidget(),
)
```

### 5. Add Hamburger Menu Integration

In your livestream screen, add a hamburger menu button:

```dart
IconButton(
  icon: SvgPicture.asset('assets/icons/hanbumger.svg'),
  onPressed: () {
    showModalBottomSheet(
      context: context,
      builder: (context) => RecordingControlsSheet(
        recordingStatus: recordingService?.currentRecording?.status ?? RecordingStatus.idle,
        recordingId: recordingService?.currentRecording?.recordingId,
        onStartRecording: () {
          context.read<RecordingBloc>().add(
            StartRecording(roomId: roomId),
          );
          Navigator.pop(context);
        },
        onStopRecording: () {
          if (recordingService?.currentRecording?.recordingId != null) {
            context.read<RecordingBloc>().add(
              StopRecording(
                recordingId: recordingService!.currentRecording!.recordingId,
              ),
            );
          }
          Navigator.pop(context);
        },
        onClose: () => Navigator.pop(context),
      ),
    );
  },
)
```

## Socket.IO Events

### Client → Server

#### start-recording
```dart
socket.emit('start-recording', {'roomId': roomId});
```

**Response:**
```json
{
  "success": true,
  "recordingId": "room-123-socket-abc-1711234567890"
}
```

**Error Response:**
```json
{
  "error": "No active streams to record"
}
```

#### stop-recording
```dart
socket.emit('stop-recording', {'recordingId': recordingId});
```

**Response:**
```json
{
  "success": true,
  "recordingId": "room-123-socket-abc-1711234567890",
  "duration": 145,
  "downloadUrl": "/recordings/room-123-socket-abc-1711234567890"
}
```

**Error Response:**
```json
{
  "error": "No active recording found"
}
```

### Server → Client

#### recording-status
```json
{
  "recordingId": "room-123-socket-abc-1711234567890",
  "status": "recording",
  "roomId": "room-123"
}
```

## HTTP Download Endpoint

### GET /recordings/:recordingId

Downloads the recorded file.

**Base URL:** The streaming server URL (e.g., `http://streaming-server:4000` or the public streaming URL)

**Response Headers:**
- `Content-Type: video/webm`
- `Content-Disposition: attachment; filename="recording-{recordingId}.webm"`

**Response:** Binary file stream (.webm)

**Error (404):**
```json
{
  "error": "Recording not found"
}
```

**Note:** Recordings are automatically deleted after 1 hour. Download promptly after stopping.

## Error Handling

### Possible Errors

1. **"Room not found"** - roomId doesn't exist
2. **"Already recording"** - a recording is already in progress for this session
3. **"No active streams to record"** - no producers are active in the room
4. **"No active recording found"** - trying to stop a recording that doesn't exist
5. **"Request timeout"** - server didn't respond in time

### Error Handling in UI

```dart
if (state is RecordingError) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(state.message),
      backgroundColor: Colors.red,
    ),
  );
}
```

## Best Practices

1. **Always check recording status** before starting/stopping
2. **Show clear feedback** to users when recording starts/stops
3. **Handle errors gracefully** with user-friendly messages
4. **Download recordings promptly** (auto-deleted after 1 hour)
5. **Test on both Web and Mobile** platforms
6. **Monitor recording duration** to avoid long recordings
7. **Clean up resources** when leaving livestream

## Testing

### Unit Tests
```dart
test('RecordingModel should parse status correctly', () {
  final model = RecordingModel.fromJson({
    'recordingId': 'test-123',
    'roomId': 'room-456',
    'status': 'recording',
  });
  
  expect(model.status, RecordingStatus.recording);
});
```

### Integration Tests
```dart
testWidgets('PopRecord should show three options', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: PopRecord(
        onYes: () {},
        onNo: () {},
        onLater: () {},
      ),
    ),
  );
  
  expect(find.text('Yes'), findsOneWidget);
  expect(find.text('No'), findsOneWidget);
  expect(find.text('Later'), findsOneWidget);
});
```

## Troubleshooting

### Recording not starting
- Check if Socket.IO is connected
- Verify roomId is correct
- Ensure producers are active in the room

### Download not working
- Check if downloadUrl is valid
- Verify server is accessible
- Check file permissions on device

### UI not updating
- Ensure BLoC is properly provided
- Check if state changes are being emitted
- Verify StreamBuilder is listening to correct stream

## Support

For issues or questions, contact the development team or refer to the Mediasoup documentation.
