# Livestream Recording Feature

This feature allows users to record live streams and save them to their local device. It uses **server-side recording** with Mediasoup - the server handles all the recording complexity, so no platform-specific recording APIs are needed for Web or Mobile.

## Architecture

### How It Works

1. **Client** emits `start-recording` → **Server** creates recording infrastructure
2. **Server** pipes RTP streams to FFmpeg → produces a `.webm` file
3. **Client** emits `stop-recording` → **Server** stops FFmpeg and returns download URL
4. **Client** downloads the recording via HTTP endpoint

### Socket.IO Events

**start-recording:**
- Client sends: `{ roomId }`
- Server responds: `{ success: true, recordingId: "..." }`
- Errors: "Room not found", "Already recording", "No active streams to record"

**stop-recording:**
- Client sends: `{ recordingId }`
- Server responds: `{ success: true, recordingId: "...", duration: 145, downloadUrl: "/recordings/..." }`
- Errors: "No active recording found"

### HTTP Download Endpoint

- `GET /recordings/:recordingId`
- Returns: `.webm` file with headers for download
- **Important:** Recordings are auto-deleted after 1 hour

## Key Benefits

- **Cross-platform:** Same implementation works for Web, React Native, Flutter, Swift
- **Server-side:** No client-side recording APIs needed
- **Simple:** Just emit socket events and download the file

## Implementation

### Two Ways to Start Recording

#### Way 1: PopRecord Widget (Automatic Prompt)

After creating a livestream, a `PopRecord` widget appears asking users if they want to record:

1. User sees `PopRecord` dialog with options: Yes, No, Later
2. If user selects "Yes", `ConfirmVariant` dialog appears for confirmation
3. If confirmed, `record_started.svg` notification appears briefly
4. `livrec.svg` indicator appears in header and pulses while recording
5. When livestream ends, `DownloadFileContainer` widget appears for saving

#### Way 2: RecordingControlsSheet (Manual Control)

Users can manually control recording via the hamburger button:

1. User clicks the hamburger button in the livestream controls
2. `RecordingControlsSheet` bottom sheet appears
3. User can start/stop recording from the sheet
4. Recording indicator appears in header while recording is active

## File Structure

```
lib/features/recording/
├── services/
│   └── recording_service.dart          # Socket.IO service for recording
├── widgets/
│   ├── index.dart                       # Export all widgets
│   ├── pop_record.dart                  # Initial recording prompt
│   ├── confirm_variant.dart             # Confirmation dialog
│   ├── download_file_container.dart     # Save recording dialog
│   ├── recording_indicator.dart         # Pulsing indicator for header
│   └── record_started_notification.dart # Start notification overlay
└── example_integration.dart             # Integration example
```

## Usage

### 1. Initialize Recording Service

```dart
import 'package:clapmi/features/recording/services/recording_service.dart';

late RecordingService _recordingService;
bool _isRecording = false;

@override
void initState() {
  super.initState();
  _recordingService = RecordingService();
  _recordingService.initialize(socket, roomId);
  
  // Listen to recording state changes
  _recordingService.recordingStateStream.listen((state) {
    setState(() => _isRecording = state == RecordingState.recording);
  });
}
```

### 2. Start Recording

```dart
final result = await _recordingService.startRecording();
if (result.success) {
  print('Recording started: ${result.recordingId}');
} else {
  print('Error: ${result.errorMessage}');
}
```

### 3. Stop Recording

```dart
final result = await _recordingService.stopRecording();
if (result.success) {
  print('Recording stopped');
  print('Download URL: ${result.downloadUrl}');
  print('Duration: ${result.duration} seconds');
}
```

### 4. Show PopRecord Dialog (Way 1)

```dart
import 'package:clapmi/features/recording/widgets/index.dart';

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
```

### 5. Show RecordingControlsSheet (Way 2)

```dart
import 'package:clapmi/features/recording/widgets/index.dart';

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
```

### 6. Add Recording Indicator to Header

```dart
import 'package:clapmi/features/recording/widgets/index.dart';

// In your header Row:
if (_isRecording) const StaticRecordingIndicator(isRecording: true),
```

### 7. Show Download Dialog

```dart
import 'package:clapmi/features/recording/widgets/index.dart';

showDialog(
  context: context,
  builder: (context) => DownloadFileContainer(
    downloadUrl: downloadUrl,
    recordingId: recordingId,
    duration: duration,
    onClose: () => Navigator.pop(context),
  ),
);
```

## Integration with Existing Livestream

See `example_integration.dart` for a complete example of how to integrate this feature into your existing livestream screen.

## Dependencies

The following packages are required:

```yaml
dependencies:
  socket_io_client: ^2.0.0
  path_provider: ^2.0.0
  http: ^1.0.0
  permission_handler: ^11.0.0
  flutter_svg: ^2.0.0
  flutter_screenutil: ^5.0.0
```

## Notes

- Recordings are stored on the server and auto-deleted after 1 hour
- The recording service uses the same socket connection as the livestream
- No platform-specific recording APIs are needed
- The recording indicator pulses to show active recording
- Users can download recordings to their device when the livestream ends
