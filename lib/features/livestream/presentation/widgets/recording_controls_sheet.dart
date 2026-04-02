import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:clapmi/features/livestream/data/models/recording_model.dart';

/// Bottom sheet widget that appears when users click the hamburger menu
/// Provides controls to start/stop recording
class RecordingControlsSheet extends StatelessWidget {
  final RecordingStatus recordingStatus;
  final String? recordingId;
  final VoidCallback onScreenShare;
  final VoidCallback? onMini;
  final VoidCallback onStartRecording;
  final VoidCallback onStopRecording;
  final VoidCallback onClose;

  const RecordingControlsSheet({
    super.key,
    required this.recordingStatus,
    this.recordingId,
    required this.onScreenShare,
    this.onMini,
    required this.onStartRecording,
    required this.onStopRecording,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final bool isRecording = recordingStatus == RecordingStatus.recording;

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1C1C1E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Buttons row
          Row(
            children: [
              Expanded(
                child: _ControlButton(
                  svgAsset: 'assets/icons/screenshare.svg',
                  label: 'Screen share',
                  isActive: false,
                  onTap: onScreenShare,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ControlButton(
                  svgAsset: 'assets/icons/rec.svg',
                  label: isRecording ? 'Stop Recording' : 'Record',
                  isActive: isRecording,
                  onTap: isRecording ? onStopRecording : onStartRecording,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ControlButton(
                  svgAsset: 'assets/icons/mini.svg',
                  label: 'Mini',
                  isActive: false,
                  onTap: onMini ?? onClose,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final String svgAsset;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _ControlButton({
    required this.svgAsset,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color bgColor =
        isActive ? const Color(0xFFF0F0F0) : const Color(0xFF2C2C2E);
    final Color contentColor = isActive ? Colors.black : Colors.white;
    final Border? border = isActive
        ? null
        : Border.all(color: const Color(0xFF7B5EA7), width: 1.5);

    return GestureDetector(
      onTap: onTap,
        child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        height: 110,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
          border: border,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              svgAsset,
              width: 28,
              height: 28,
              colorFilter: ColorFilter.mode(contentColor, BlendMode.srcIn),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: contentColor,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
