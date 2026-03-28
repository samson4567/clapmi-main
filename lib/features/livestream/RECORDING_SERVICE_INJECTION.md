# Recording Service Dependency Injection Setup

## Add to lib/core/di/injector.dart

Add the following imports at the top of the file (after existing imports):

```dart
import 'package:clapmi/features/livestream/data/datasources/recording_remote_datasource.dart';
import 'package:clapmi/features/livestream/data/services/recording_service.dart';
import 'package:clapmi/features/livestream/presentation/blocs/recording/recording_bloc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
```

Add the following registrations in the `init()` function (before `await getItInstance.allReady();`):

```dart
// RecordingBloc
getItInstance.registerLazySingleton<RecordingRemoteDataSource>(
  () => RecordingRemoteDataSource(socket: getItInstance<IO.Socket>()),
);

getItInstance.registerLazySingleton<RecordingService>(
  () => RecordingService(remoteDataSource: getItInstance<RecordingRemoteDataSource>()),
);

getItInstance.registerFactory<RecordingBloc>(
  () => RecordingBloc(recordingDataSource: getItInstance<RecordingRemoteDataSource>()),
);
```

## Usage in Widgets

### Using RecordingBloc

```dart
BlocProvider<RecordingBloc>(
  create: (context) => getItInstance<RecordingBloc>(),
  child: YourLivestreamWidget(),
)
```

### Using RecordingService

```dart
final recordingService = getItInstance<RecordingService>();

// Check if recording
if (recordingService.isRecording) {
  // Recording is active
}

// Listen to recording state changes
StreamBuilder<RecordingModel?>(
  stream: recordingService.recordingStream,
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      final recording = snapshot.data!;
      // Update UI based on recording state
    }
    return YourWidget();
  },
)
```

## Complete Example

```dart
import 'package:clapmi/core/di/injector.dart';
import 'package:clapmi/features/livestream/presentation/blocs/recording/recording_bloc.dart';
import 'package:clapmi/features/livestream/presentation/widgets/recording_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LivestreamScreen extends StatelessWidget {
  final String roomId;

  const LivestreamScreen({super.key, required this.roomId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RecordingBloc>(
      create: (context) => getItInstance<RecordingBloc>(),
      child: _LivestreamContent(roomId: roomId),
    );
  }
}

class _LivestreamContent extends StatelessWidget {
  final String roomId;

  const _LivestreamContent({required this.roomId});

  @override
  Widget build(BuildContext context) {
    return BlocListener<RecordingBloc, RecordingState>(
      listener: (context, state) {
        if (state is RecordingStarted) {
          // Show notification
          showDialog(
            context: context,
            builder: (context) => RecordStartedNotification(
              onDismiss: () => Navigator.pop(context),
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
      child: Scaffold(
        appBar: AppBar(
          title: Text('Livestream'),
          actions: [
            // Recording indicator
            BlocBuilder<RecordingBloc, RecordingState>(
              builder: (context, state) {
                return RecordingIndicator(
                  isRecording: state is RecordingStarted,
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => RecordingControlsSheet(
                        recordingStatus: state is RecordingStarted
                            ? RecordingStatus.recording
                            : RecordingStatus.idle,
                        recordingId: state is RecordingStarted
                            ? state.recording.recordingId
                            : null,
                        onStartRecording: () {
                          context.read<RecordingBloc>().add(
                            StartRecording(roomId: roomId),
                          );
                          Navigator.pop(context);
                        },
                        onStopRecording: () {
                          if (state is RecordingStarted) {
                            context.read<RecordingBloc>().add(
                              StopRecording(
                                recordingId: state.recording.recordingId,
                              ),
                            );
                          }
                          Navigator.pop(context);
                        },
                        onClose: () => Navigator.pop(context),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
        body: Center(
          child: Text('Livestream Content'),
        ),
      ),
    );
  }
}
```
