# Livestream Recording Feature - Debug Analysis & Refactored Documentation

## Table of Contents
1. [Overview](#overview)
2. [Architecture](#architecture)
3. [Two Implementation Approaches](#two-implementation-approaches)
4. [Socket.IO Events](#socketio-events)
5. [HTTP Download Endpoint](#http-download-endpoint)
6. [Critical Bugs Found](#critical-bugs-found)
7. [Documentation vs Implementation Mismatch](#documentation-vs-implementation-mismatch)
8. [Fix Recommendations](#fix-recommendations)

---

## Overview

The recording feature allows users to record live streams and save recordings to their local device. It uses Mediasoup server-side recording — the Mediasoup server creates server-side consumers, pipes RTP streams to FFmpeg, and produces a downloadable .webm file.

This approach works identically for Web (Nuxt 3) and Mobile (React Native / Flutter / Swift) — no platform-specific recording APIs are needed.

---

## Architecture

```
Client (Web / Mobile)              Mediasoup Server (Node.js)
─────────────────────              ─────────────────────────────

emit('start-recording')  ────►    1. Create PlainTransport per producer
                                  2. Create server-side Consumer per producer
                                  3. Generate SDP file
                                  4. Pipe RTP → FFmpeg via UDP
                                  5. FFmpeg muxes audio+video → /tmp/recordings/xxx.webm

emit('stop-recording')   ────►    6. Send 'q' to FFmpeg for graceful stop
                                  7. Close consumers & transports
                         ◄────    8. Return { recordingId, duration, downloadUrl }

GET /recordings/:id      ────►    9. Stream .webm file to client
                         ◄────   10. Client saves to local device
```

---

## Two Implementation Approaches

### Approach 1: Automatic Recording Prompt on Livestream Creation

**Flow:**
1. User creates a livestream
2. **PopRecord** widget appears with options: Yes, No, Later
3. User clicks "Yes"
4. **ConfirmVariant** widget appears for confirmation
5. User clicks "Yes" again
6. **record_started.svg** notification appears (auto-dismisses after 2 seconds)
7. **RecordingIndicator** (pulsing red dot) appears in livestream header beside screen share icon
8. Recording continues while livestream is active
9. When livestream ends, **DownloadFileContainer** widget appears
10. User can save the video recording to their local device

**Widgets Involved:**
- [`PopRecord`](lib/features/livestream/presentation/widgets/pop_record.dart) - Initial recording prompt
- [`ConfirmVariant`](lib/features/livestream/presentation/widgets/confirm_variant.dart) - Confirmation dialog
- [`RecordStartedNotification`](lib/features/livestream/presentation/widgets/record_started_notification.dart) - Recording started notification
- [`RecordingIndicator`](lib/features/livestream/presentation/widgets/recording_indicator.dart) - Pulsing indicator in header
- [`DownloadFileContainer`](lib/features/livestream/presentation/widgets/download_file_container.dart) - Download dialog

### Approach 2: Manual Recording via Hamburger Menu

**Flow:**
1. User is in a livestream
2. User clicks the hamburger menu button (hanbumger.svg)
3. **RecordingControlsSheet** widget appears
4. User can select "Start Recording" or "Stop Recording"
5. Recording starts/stops based on user selection
6. When livestream ends, **DownloadFileContainer** widget appears
7. User can save the video recording to their local device

**Widgets Involved:**
- [`RecordingControlsSheet`](lib/features/livestream/presentation/widgets/recording_controls_sheet.dart) - Bottom sheet with recording controls
- [`RecordingIndicator`](lib/features/livestream/presentation/widgets/recording_indicator.dart) - Pulsing indicator in header
- [`DownloadFileContainer`](lib/features/livestream/presentation/widgets/download_file_container.dart) - Download dialog

---

## Socket.IO Events

### Client → Server

#### start-recording
```dart
socket.emit('start-recording', {'roomId': roomId});
```

**Payload:**
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| roomId | string | Yes | The combo ground / room UUID |

**Callback Response (Success):**
```json
{
  "success": true,
  "recordingId": "room-123-socket-abc-1711234567890"
}
```

**Callback Response (Error):**
```json
{
  "error": "No active streams to record"
}
```

**Possible Errors:**
- "Room not found" — roomId doesn't exist
- "Already recording" — a recording is already in progress for this session
- "No active streams to record" — no producers are active in the room

#### stop-recording
```dart
socket.emit('stop-recording', {'recordingId': recordingId});
```

**Payload:**
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| recordingId | string | Yes | The recording ID received from start-recording |

**Callback Response (Success):**
```json
{
  "success": true,
  "recordingId": "room-123-socket-abc-1711234567890",
  "duration": 145,
  "downloadUrl": "/recordings/room-123-socket-abc-1711234567890"
}
```

**Callback Response (Error):**
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

---

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

---

## Critical Bugs Found

### Bug #1: RecordingRemoteDataSource Not Connected to Socket

**Location:** [`lib/core/di/injector.dart`](lib/core/di/injector.dart:373-374)

**Problem:**
```dart
getItInstance.registerLazySingleton<RecordingRemoteDataSource>(
    () => RecordingRemoteDataSource());
```

The `RecordingRemoteDataSource` is registered without a socket instance. The class has a `setSocket()` method that must be called with the actual socket instance, but this never happens.

**Impact:** Recording operations will fail with "Socket not connected" error.

**Fix Required:**
```dart
// In injector.dart, after socket is created:
final socket = getItInstance<IO.Socket>();
final recordingDataSource = RecordingRemoteDataSource();
recordingDataSource.setSocket(socket);
getItInstance.registerLazySingleton<RecordingRemoteDataSource>(
    () => recordingDataSource);
```

### Bug #2: RecordingService Not Registered in DI

**Location:** [`lib/core/di/injector.dart`](lib/core/di/injector.dart)

**Problem:** The documentation mentions `RecordingService` should be registered, but it's not in the injector. The BLoC is registered but the service layer is missing.

**Impact:** The service layer architecture is incomplete, leading to tight coupling between BLoC and data source.

**Fix Required:**
```dart
// Register RecordingService
getItInstance.registerLazySingleton(
  () => RecordingService(remoteDataSource: getItInstance<RecordingRemoteDataSource>()),
);
```

### Bug #3: PopRecord Widget Not Integrated in Livestream Flow

**Location:** [`lib/screens/challenge/others/Live_combo_three_image_present.dart`](lib/screens/challenge/others/Live_combo_three_image_present.dart)

**Problem:** The `PopRecord` widget exists in [`live_buy_point_button.dart`](lib/screens/challenge/others/widgets/live_buy_point_button.dart:362) but is never shown when a livestream is created. There's no code that triggers the recording prompt.

**Impact:** Users are never prompted to record their livestream automatically.

**Fix Required:** Add code in the livestream creation success callback to show `PopRecord` dialog.

### Bug #4: DownloadFileContainer Not Integrated

**Location:** [`lib/screens/challenge/others/Live_combo_three_image_present.dart`](lib/screens/challenge/others/Live_combo_three_image_present.dart)

**Problem:** The `DownloadFileContainer` widget exists but is never shown when a livestream ends. There's no code that triggers the download dialog.

**Impact:** Users cannot download their recordings after the livestream ends.

**Fix Required:** Add code in the livestream end handler to show `DownloadFileContainer` dialog.

### Bug #5: RecordingBloc Listener Missing in Livestream Screen

**Location:** [`lib/screens/challenge/others/Live_combo_three_image_present.dart`](lib/screens/challenge/others/Live_combo_three_image_present.dart)

**Problem:** The livestream screen doesn't have a `BlocListener<RecordingBloc>` to handle recording state changes. The header has a `BlocBuilder` but there's no listener to show notifications or download dialogs.

**Impact:** Recording state changes don't trigger UI feedback (notifications, download dialogs).

**Fix Required:** Add `BlocListener<RecordingBloc>` in the livestream screen to handle:
- `RecordingStarted` → Show `RecordStartedNotification`
- `RecordingStopped` → Show `DownloadFileContainer`
- `RecordingError` → Show error snackbar

### Bug #6: Socket Instance Not Shared with RecordingRemoteDataSource

**Location:** [`lib/screens/challenge/others/Live_combo_three_image_present.dart`](lib/screens/challenge/others/Live_combo_three_image_present.dart:115-230)

**Problem:** The socket is created in the livestream screen but never passed to the `RecordingRemoteDataSource`. The data source needs the socket to emit recording events.

**Impact:** Recording operations cannot communicate with the server.

**Fix Required:** After socket connection, call:
```dart
final recordingDataSource = getItInstance<RecordingRemoteDataSource>();
recordingDataSource.setSocket(socket!);
```

---

## Documentation vs Implementation Mismatch

### Mismatch #1: RecordingService Architecture

**Documentation Says:**
- `RecordingService` should manage recording state and operations
- `RecordingService` should provide stream of recording state changes
- `RecordingService` should be registered in DI

**Actual Implementation:**
- `RecordingService` exists but is not used
- `RecordingBloc` directly uses `RecordingRemoteDataSource`
- `RecordingService` is not registered in DI

**Verdict:** Documentation is ahead of implementation. The service layer exists but isn't integrated.

### Mismatch #2: Socket Connection Flow

**Documentation Says:**
- Socket should be passed to `RecordingRemoteDataSource` via constructor or setter
- Example shows: `RecordingRemoteDataSource(socket: socket)`

**Actual Implementation:**
- `RecordingRemoteDataSource` has empty constructor: `RecordingRemoteDataSource()`
- Has `setSocket()` method but it's never called
- Socket is created in livestream screen but not shared

**Verdict:** Implementation is incomplete. The setter exists but is never used.

### Mismatch #3: PopRecord Integration

**Documentation Says:**
- `PopRecord` should show when livestream is created
- Example code shows `showDialog()` call after livestream creation

**Actual Implementation:**
- `PopRecord` widget exists in `live_buy_point_button.dart`
- No code triggers this dialog in the livestream flow
- The widget is defined but never used

**Verdict:** Widget exists but integration is missing.

### Mismatch #4: DownloadFileContainer Integration

**Documentation Says:**
- `DownloadFileContainer` should show when livestream ends
- Example code shows `showDialog()` call in `BlocListener`

**Actual Implementation:**
- `DownloadFileContainer` widget exists
- No code triggers this dialog when livestream ends
- The widget is defined but never used

**Verdict:** Widget exists but integration is missing.

### Mismatch #5: RecordingBloc Listener

**Documentation Says:**
- `BlocListener<RecordingBloc>` should handle state changes
- Should show notifications and download dialogs

**Actual Implementation:**
- Livestream header has `BlocBuilder<RecordingBloc>` for UI
- No `BlocListener<RecordingBloc>` in the main livestream screen
- State changes don't trigger side effects

**Verdict:** Listener is missing from the implementation.

---

## Fix Recommendations

### Priority 1: Critical Fixes (Recording Won't Work Without These)

1. **Connect Socket to RecordingRemoteDataSource**
   - File: `lib/screens/challenge/others/Live_combo_three_image_present.dart`
   - After socket connection, call `recordingDataSource.setSocket(socket!)`

2. **Register RecordingService in DI**
   - File: `lib/core/di/injector.dart`
   - Add `RecordingService` registration

3. **Add BlocListener in Livestream Screen**
   - File: `lib/screens/challenge/others/Live_combo_three_image_present.dart`
   - Wrap content with `BlocListener<RecordingBloc>`

### Priority 2: Feature Integration (UI Won't Work Without These)

4. **Integrate PopRecord Dialog**
   - File: `lib/screens/challenge/others/Live_combo_three_image_present.dart`
   - Show `PopRecord` after livestream creation success

5. **Integrate DownloadFileContainer**
   - File: `lib/screens/challenge/others/Live_combo_three_image_present.dart`
   - Show `DownloadFileContainer` when `RecordingStopped` state is emitted

6. **Integrate RecordStartedNotification**
   - File: `lib/screens/challenge/others/Live_combo_three_image_present.dart`
   - Show `RecordStartedNotification` when `RecordingStarted` state is emitted

### Priority 3: Code Quality Improvements

7. **Use RecordingService Instead of Direct DataSource Access**
   - Refactor `RecordingBloc` to use `RecordingService` instead of `RecordingRemoteDataSource`
   - This follows the documented architecture

8. **Add Error Handling**
   - Add proper error handling for all recording operations
   - Show user-friendly error messages

9. **Add Loading States**
   - Show loading indicators during recording operations
   - Prevent multiple simultaneous recording requests

---

## Summary

The recording feature has **6 critical bugs** that prevent it from working:

1. ❌ Socket not connected to RecordingRemoteDataSource
2. ❌ RecordingService not registered in DI
3. ❌ PopRecord widget not integrated
4. ❌ DownloadFileContainer widget not integrated
5. ❌ RecordingBloc listener missing
6. ❌ Socket instance not shared with RecordingRemoteDataSource

The documentation is **ahead of the implementation** — it describes the desired architecture but the code hasn't been fully integrated. The widgets exist but aren't wired up to the livestream flow.

**To make recording work, you need to:**
1. Connect the socket to RecordingRemoteDataSource
2. Add BlocListener in the livestream screen
3. Integrate PopRecord, RecordStartedNotification, and DownloadFileContainer dialogs
4. Register RecordingService in DI (optional but recommended for architecture)

---

## Files Reference

### Core Files
- [`lib/features/livestream/data/datasources/recording_remote_datasource.dart`](lib/features/livestream/data/datasources/recording_remote_datasource.dart) - Socket.IO event handling
- [`lib/features/livestream/data/services/recording_service.dart`](lib/features/livestream/data/services/recording_service.dart) - Recording state management
- [`lib/features/livestream/data/models/recording_model.dart`](lib/features/livestream/data/models/recording_model.dart) - Recording data model
- [`lib/features/livestream/presentation/blocs/recording/recording_bloc.dart`](lib/features/livestream/presentation/blocs/recording/recording_bloc.dart) - BLoC state management

### UI Widgets
- [`lib/features/livestream/presentation/widgets/pop_record.dart`](lib/features/livestream/presentation/widgets/pop_record.dart) - Recording prompt dialog
- [`lib/features/livestream/presentation/widgets/confirm_variant.dart`](lib/features/livestream/presentation/widgets/confirm_variant.dart) - Confirmation dialog
- [`lib/features/livestream/presentation/widgets/record_started_notification.dart`](lib/features/livestream/presentation/widgets/record_started_notification.dart) - Recording started notification
- [`lib/features/livestream/presentation/widgets/recording_indicator.dart`](lib/features/livestream/presentation/widgets/recording_indicator.dart) - Pulsing indicator
- [`lib/features/livestream/presentation/widgets/recording_controls_sheet.dart`](lib/features/livestream/presentation/widgets/recording_controls_sheet.dart) - Recording controls bottom sheet
- [`lib/features/livestream/presentation/widgets/download_file_container.dart`](lib/features/livestream/presentation/widgets/download_file_container.dart) - Download dialog

### Integration Points
- [`lib/core/di/injector.dart`](lib/core/di/injector.dart) - Dependency injection setup
- [`lib/screens/challenge/widgets/livestream _header.dart`](lib/screens/challenge/widgets/livestream%20_header.dart) - Livestream header with RecordingIndicator
- [`lib/screens/challenge/others/Live_combo_three_image_present.dart`](lib/screens/challenge/others/Live_combo_three_image_present.dart) - Main livestream screen
- [`lib/screens/challenge/others/widgets/live_buy_point_button.dart`](lib/screens/challenge/others/widgets/live_buy_point_button.dart) - Contains PopRecord widget

---

## Next Steps

1. Fix Bug #1: Connect socket to RecordingRemoteDataSource
2. Fix Bug #6: Share socket instance with RecordingRemoteDataSource
3. Fix Bug #5: Add BlocListener in livestream screen
4. Fix Bug #3: Integrate PopRecord dialog
5. Fix Bug #4: Integrate DownloadFileContainer dialog
6. Fix Bug #2: Register RecordingService in DI
7. Test recording flow end-to-end
8. Add error handling and loading states
