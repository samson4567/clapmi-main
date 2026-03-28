/// Model representing a recording session
class RecordingModel {
  final String recordingId;
  final String roomId;
  final RecordingStatus status;
  final int? duration; // in seconds
  final String? downloadUrl;
  final DateTime? startedAt;
  final DateTime? stoppedAt;

  RecordingModel({
    required this.recordingId,
    required this.roomId,
    required this.status,
    this.duration,
    this.downloadUrl,
    this.startedAt,
    this.stoppedAt,
  });

  factory RecordingModel.fromJson(Map<String, dynamic> json) {
    return RecordingModel(
      recordingId: json['recordingId'] as String,
      roomId: json['roomId'] as String? ?? '',
      status: parseStatus(json['status'] as String?),
      duration: json['duration'] as int?,
      downloadUrl: json['downloadUrl'] as String?,
      startedAt: json['startedAt'] != null
          ? DateTime.parse(json['startedAt'] as String)
          : null,
      stoppedAt: json['stoppedAt'] != null
          ? DateTime.parse(json['stoppedAt'] as String)
          : null,
    );
  }

  static RecordingStatus parseStatus(String? status) {
    switch (status) {
      case 'recording':
        return RecordingStatus.recording;
      case 'stopped':
        return RecordingStatus.stopped;
      case 'error':
        return RecordingStatus.error;
      default:
        return RecordingStatus.idle;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'recordingId': recordingId,
      'roomId': roomId,
      'status': status.name,
      'duration': duration,
      'downloadUrl': downloadUrl,
      'startedAt': startedAt?.toIso8601String(),
      'stoppedAt': stoppedAt?.toIso8601String(),
    };
  }

  RecordingModel copyWith({
    String? recordingId,
    String? roomId,
    RecordingStatus? status,
    int? duration,
    String? downloadUrl,
    DateTime? startedAt,
    DateTime? stoppedAt,
  }) {
    return RecordingModel(
      recordingId: recordingId ?? this.recordingId,
      roomId: roomId ?? this.roomId,
      status: status ?? this.status,
      duration: duration ?? this.duration,
      downloadUrl: downloadUrl ?? this.downloadUrl,
      startedAt: startedAt ?? this.startedAt,
      stoppedAt: stoppedAt ?? this.stoppedAt,
    );
  }

  @override
  String toString() {
    return 'RecordingModel(recordingId: $recordingId, roomId: $roomId, status: $status, duration: $duration, downloadUrl: $downloadUrl)';
  }
}

/// Enum representing the recording status
enum RecordingStatus {
  idle,
  recording,
  stopped,
  error,
}
