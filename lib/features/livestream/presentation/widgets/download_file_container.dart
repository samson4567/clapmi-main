import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

/// Widget that appears when livestream ends and recording is available
/// Allows users to download the recorded file to their local device
class DownloadFileContainer extends StatefulWidget {
  final String recordingId;
  final String downloadUrl;
  final int? duration;
  final VoidCallback onClose;
  final Function(String)? onDownloadComplete;

  const DownloadFileContainer({
    super.key,
    required this.recordingId,
    required this.downloadUrl,
    this.duration,
    required this.onClose,
    this.onDownloadComplete,
  });

  @override
  State<DownloadFileContainer> createState() => _DownloadFileContainerState();
}

class _DownloadFileContainerState extends State<DownloadFileContainer> {
  bool _isDownloading = false;
  double _downloadProgress = 0.0;
  String? _downloadedFilePath;
  String? _errorMessage;

  Future<void> _downloadFile() async {
    setState(() {
      _isDownloading = true;
      _downloadProgress = 0.0;
      _errorMessage = null;
    });

    try {
      // Get the downloads directory
      final directory = await getApplicationDocumentsDirectory();
      final downloadsDir = Directory('${directory.path}/recordings');

      // Create recordings directory if it doesn't exist
      if (!await downloadsDir.exists()) {
        await downloadsDir.create(recursive: true);
      }

      // Generate filename with timestamp
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'recording_${widget.recordingId}_$timestamp.webm';
      final filePath = '${downloadsDir.path}/$fileName';

      // Download the file
      final request = http.Request('GET', Uri.parse(widget.downloadUrl));
      final response = await http.Client().send(request);

      if (response.statusCode == 200) {
        final file = File(filePath);
        final sink = file.openWrite();
        int received = 0;
        final total = response.contentLength ?? 0;

        await response.stream.listen(
          (chunk) {
            sink.add(chunk);
            received += chunk.length;
            if (total > 0) {
              setState(() {
                _downloadProgress = received / total;
              });
            }
          },
          onDone: () async {
            await sink.close();
            setState(() {
              _isDownloading = false;
              _downloadedFilePath = filePath;
            });
            if (widget.onDownloadComplete != null) {
              widget.onDownloadComplete!(filePath);
            }
          },
          onError: (error) {
            setState(() {
              _isDownloading = false;
              _errorMessage = 'Download failed: $error';
            });
          },
        ).asFuture();
      } else {
        setState(() {
          _isDownloading = false;
          _errorMessage = 'Download failed: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _isDownloading = false;
        _errorMessage = 'Download failed: $e';
      });
    }
  }

  String _formatDuration(int? seconds) {
    if (seconds == null) return 'Unknown duration';
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes}m ${remainingSeconds}s';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with close button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recording Ready',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                ),
              ),
              GestureDetector(
                onTap: widget.onClose,
                child: Container(
                  width: 32.w,
                  height: 32.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Icon(
                    Icons.close,
                    color: Colors.grey[400],
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          // Recording icon
          Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(40.r),
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/icons/Record.svg',
                width: 40.w,
                height: 40.w,
                colorFilter: const ColorFilter.mode(
                  Color(0xFFFF4444),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          // Recording info
          Text(
            'Recording ID: ${widget.recordingId}',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 12.sp,
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            _formatDuration(widget.duration),
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 20.h),
          // Download progress or button
          if (_isDownloading) ...[
            // Progress indicator
            Column(
              children: [
                LinearProgressIndicator(
                  value: _downloadProgress,
                  backgroundColor: const Color(0xFF2A2A2A),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFFFF4444),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  '${(_downloadProgress * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12.sp,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ] else if (_downloadedFilePath != null) ...[
            // Download complete
            Column(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 40,
                ),
                SizedBox(height: 8.h),
                Text(
                  'Download Complete!',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Saved to: ${_downloadedFilePath!.split('/').last}',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 10.sp,
                    fontFamily: 'Poppins',
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ] else if (_errorMessage != null) ...[
            // Error message
            Column(
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 40,
                ),
                SizedBox(height: 8.h),
                Text(
                  _errorMessage!,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12.sp,
                    fontFamily: 'Poppins',
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ] else ...[
            // Download button
            GestureDetector(
              onTap: _downloadFile,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF4444),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/download.png',
                      width: 20.w,
                      height: 20.w,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Download Recording',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          SizedBox(height: 12.h),
          // Note about auto-deletion
          Text(
            'Note: Recordings are automatically deleted after 1 hour.',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 10.sp,
              fontFamily: 'Poppins',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
