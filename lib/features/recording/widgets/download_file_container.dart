import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

/// DownloadFileContainer widget - Shown when livestream ends to allow users to save the recording
class DownloadFileContainer extends StatefulWidget {
  final String downloadUrl;
  final String recordingId;
  final int duration;
  final VoidCallback onClose;

  const DownloadFileContainer({
    super.key,
    required this.downloadUrl,
    required this.recordingId,
    required this.duration,
    required this.onClose,
  });

  @override
  State<DownloadFileContainer> createState() => _DownloadFileContainerState();
}

class _DownloadFileContainerState extends State<DownloadFileContainer> {
  bool _isDownloading = false;
  double _downloadProgress = 0.0;
  String? _errorMessage;
  String? _savedFilePath;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 320.w,
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1E),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: const Color(0xFF7B5EA7),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Download icon
            Container(
              width: 60.w,
              height: 60.w,
              decoration: BoxDecoration(
                color: const Color(0xFF2C2C2E),
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: Center(
                child: _isDownloading
                    ? SizedBox(
                        width: 32.w,
                        height: 32.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            const Color(0xFF7B5EA7),
                          ),
                          value: _downloadProgress > 0 ? _downloadProgress : null,
                        ),
                      )
                    : _savedFilePath != null
                        ? Icon(
                            Icons.check_circle,
                            size: 32.w,
                            color: Colors.green,
                          )
                        : SvgPicture.asset(
                            'assets/icons/download.png',
                            width: 32.w,
                            height: 32.w,
                            colorFilter: const ColorFilter.mode(
                              Color(0xFF7B5EA7),
                              BlendMode.srcIn,
                            ),
                          ),
              ),
            ),
            SizedBox(height: 20.h),

            // Title
            Text(
              _savedFilePath != null
                  ? 'Recording Saved!'
                  : 'Save Recording?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),

            // Description
            if (_savedFilePath != null) ...[
              Text(
                'Your recording has been saved to:',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14.sp,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF2C2C2E),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  _savedFilePath!,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ] else ...[
              Text(
                'Duration: ${_formatDuration(widget.duration)}',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14.sp,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
              Text(
                'Save this recording to your device?',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14.sp,
                ),
                textAlign: TextAlign.center,
              ),
            ],

            // Error message
            if (_errorMessage != null) ...[
              SizedBox(height: 12.h),
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: Colors.red, width: 1),
                ),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],

            SizedBox(height: 24.h),

            // Progress indicator
            if (_isDownloading) ...[
              LinearProgressIndicator(
                value: _downloadProgress > 0 ? _downloadProgress : null,
                backgroundColor: const Color(0xFF2C2C2E),
                valueColor: AlwaysStoppedAnimation<Color>(
                  const Color(0xFF7B5EA7),
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                '${(_downloadProgress * 100).toStringAsFixed(0)}%',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 12.h),
            ],

            // Buttons
            Row(
              children: [
                // Close button
                Expanded(
                  child: GestureDetector(
                    onTap: widget.onClose,
                    child: Container(
                      height: 44.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2C2C2E),
                        borderRadius: BorderRadius.circular(22.r),
                        border: Border.all(
                          color: const Color(0xFF7B5EA7),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          _savedFilePath != null ? 'Done' : 'Cancel',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Download button (only show if not saved yet)
                if (_savedFilePath == null) ...[
                  SizedBox(width: 12.w),
                  Expanded(
                    child: GestureDetector(
                      onTap: _isDownloading ? null : _downloadRecording,
                      child: Container(
                        height: 44.h,
                        decoration: BoxDecoration(
                          color: _isDownloading
                              ? Colors.grey
                              : const Color(0xFF7B5EA7),
                          borderRadius: BorderRadius.circular(22.r),
                        ),
                        child: Center(
                          child: Text(
                            _isDownloading ? 'Downloading...' : 'Save',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    }
  }

  Future<void> _downloadRecording() async {
    setState(() {
      _isDownloading = true;
      _errorMessage = null;
    });

    try {
      // Request storage permission
      if (Platform.isAndroid) {
        final status = await Permission.storage.request();
        if (!status.isGranted) {
          setState(() {
            _isDownloading = false;
            _errorMessage = 'Storage permission denied';
          });
          return;
        }
      }

      // Get download directory
      Directory? directory;
      if (Platform.isAndroid) {
        directory = await getExternalStorageDirectory();
      } else if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = await getDownloadsDirectory();
      }

      if (directory == null) {
        setState(() {
          _isDownloading = false;
          _errorMessage = 'Could not access storage';
        });
        return;
      }

      // Create file path
      final fileName = 'livestream_recording_${widget.recordingId}.webm';
      final filePath = '${directory.path}/$fileName';

      // Download file
      final response = await http.get(Uri.parse(widget.downloadUrl));
      
      if (response.statusCode == 200) {
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        
        setState(() {
          _isDownloading = false;
          _savedFilePath = filePath;
          _downloadProgress = 1.0;
        });
      } else {
        setState(() {
          _isDownloading = false;
          _errorMessage = 'Download failed: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _isDownloading = false;
        _errorMessage = 'Download error: $e';
      });
    }
  }
}
