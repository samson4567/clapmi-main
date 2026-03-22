import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

// ─────────────────────────────────────────────────────────────────────────────
// MediaSFU Video Player Widget
//
// Renders a single MediaStreamTrack (video) coming from the
// mediasfu_mediasoup_client package.
//
// Usage:
//   MediasfuVideoPlayer(
//     track: remoteVideoTrack,          // MediaStreamTrack from mediasfu
//     label: 'Alice',                    // optional overlay label
//     mirror: false,                     // mirror for local camera
//     objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
//     placeholderBuilder: (_) => …,     // shown while track is inactive
//   )
// ─────────────────────────────────────────────────────────────────────────────

/// Thin wrapper that holds one [RTCVideoRenderer] for a given
/// [MediaStreamTrack] and keeps it in sync as the track is replaced.
class MediasfuVideoPlayer extends StatefulWidget {
  const MediasfuVideoPlayer({
    super.key,
    required this.track,
    this.label,
    this.mirror = false,
    this.objectFit = RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
    this.borderRadius = 12.0,
    this.showOverlay = true,
    this.overlayAlignment = Alignment.bottomLeft,
    this.placeholderBuilder,
    this.onRendererReady,
    this.backgroundColor = const Color(0xFF0D0D0D),
    this.labelStyle,
    this.muteAudio = false,
  });

  /// The video [MediaStreamTrack] produced by mediasfu_mediasoup_client.
  /// Pass `null` to show the placeholder.
  final MediaStreamTrack? track;

  /// Optional participant name shown as an overlay.
  final String? label;

  /// Mirror the video horizontally (useful for local camera preview).
  final bool mirror;

  /// How the video is fitted inside its container.
  final RTCVideoViewObjectFit objectFit;

  /// Corner radius of the widget.
  final double borderRadius;

  /// Whether to show the label / mute-indicator overlay.
  final bool showOverlay;

  /// Where the overlay badge is placed.
  final Alignment overlayAlignment;

  /// Widget shown when [track] is null or not yet active.
  final WidgetBuilder? placeholderBuilder;

  /// Called once the renderer is initialised and ready.
  final ValueChanged<RTCVideoRenderer>? onRendererReady;

  /// Background colour visible before the first video frame.
  final Color backgroundColor;

  /// Style for the name label text.
  final TextStyle? labelStyle;

  /// If true, the associated audio is muted (visual indicator only –
  /// actual muting is handled at the MediaStream level).
  final bool muteAudio;

  @override
  State<MediasfuVideoPlayer> createState() => _MediasfuVideoPlayerState();
}

class _MediasfuVideoPlayerState extends State<MediasfuVideoPlayer>
    with SingleTickerProviderStateMixin {
  late final RTCVideoRenderer _renderer;
  bool _rendererReady = false;
  bool _hasVideoFrame = false;

  // Simple pulse animation for the "live" indicator dot.
  late final AnimationController _pulseCtrl;
  late final Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );

    _initRenderer();
  }

  Future<void> _initRenderer() async {
    _renderer = RTCVideoRenderer();
    await _renderer.initialize();

    _renderer.onFirstFrameRendered = () {
      if (mounted) setState(() => _hasVideoFrame = true);
    };

    await _attachTrack(widget.track);

    if (mounted) {
      setState(() => _rendererReady = true);
      widget.onRendererReady?.call(_renderer);
    }
  }

  /// Wraps the raw [MediaStreamTrack] in an [RTCVideoRenderer]-compatible
  /// [MediaStream] and assigns it to the renderer.
  Future<void> _attachTrack(MediaStreamTrack? track) async {
    if (track == null) {
      _renderer.srcObject = null;
      if (mounted) setState(() => _hasVideoFrame = false);
      return;
    }

    // mediasfu_mediasoup_client exposes a standard flutter_webrtc
    // MediaStreamTrack – wrap it in a fresh MediaStream so that
    // RTCVideoRenderer can consume it.
    final stream = await createLocalMediaStream('mediasfu_${track.id}');
    await stream.addTrack(track);
    _renderer.srcObject = stream;
  }

  @override
  void didUpdateWidget(covariant MediasfuVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.track?.id != widget.track?.id) {
      // Track changed – re-attach.
      _hasVideoFrame = false;
      _attachTrack(widget.track);
    }
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    // Detach the stream before disposing to avoid dangling renderer refs.
    _renderer.srcObject = null;
    _renderer.dispose();
    super.dispose();
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: ColoredBox(
        color: widget.backgroundColor,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ── Video layer ──────────────────────────────────────────────
            if (_rendererReady && widget.track != null)
              RTCVideoView(
                _renderer,
                mirror: widget.mirror,
                objectFit: widget.objectFit,
                placeholderBuilder: widget.placeholderBuilder ??
                    (_) => _DefaultPlaceholder(label: widget.label),
              )
            else
              (widget.placeholderBuilder != null)
                  ? Builder(builder: widget.placeholderBuilder!)
                  : _DefaultPlaceholder(label: widget.label),

            // ── Gradient scrim (bottom) ──────────────────────────────────
            if (widget.showOverlay && _hasVideoFrame)
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.6, 1.0],
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.55),
                      ],
                    ),
                  ),
                ),
              ),

            // ── Overlay badge ────────────────────────────────────────────
            if (widget.showOverlay)
              Positioned(
                left: widget.overlayAlignment == Alignment.bottomLeft ||
                        widget.overlayAlignment == Alignment.topLeft
                    ? 10
                    : null,
                right: widget.overlayAlignment == Alignment.bottomRight ||
                        widget.overlayAlignment == Alignment.topRight
                    ? 10
                    : null,
                bottom: widget.overlayAlignment.y > 0 ? 10 : null,
                top: widget.overlayAlignment.y < 0 ? 10 : null,
                child: _OverlayBadge(
                  label: widget.label,
                  muted: widget.muteAudio,
                  isLive: _hasVideoFrame,
                  pulseAnim: _pulseAnim,
                  labelStyle: widget.labelStyle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _DefaultPlaceholder
// ─────────────────────────────────────────────────────────────────────────────

class _DefaultPlaceholder extends StatelessWidget {
  const _DefaultPlaceholder({this.label});
  final String? label;

  @override
  Widget build(BuildContext context) {
    final initials = label != null && label!.isNotEmpty
        ? label!.trim().split(RegExp(r'\s+')).map((w) => w[0]).take(2).join()
        : '?';

    return ColoredBox(
      color: const Color(0xFF1A1A2E),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Avatar circle
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF252545),
                border: Border.all(
                  color: const Color(0xFF4A4AFF).withOpacity(0.6),
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  initials.toUpperCase(),
                  style: const TextStyle(
                    color: Color(0xFFB0B0FF),
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),
            if (label != null) ...[
              const SizedBox(height: 10),
              Text(
                label!,
                style: const TextStyle(
                  color: Color(0xFF8888BB),
                  fontSize: 13,
                  letterSpacing: 0.4,
                ),
              ),
            ],
            const SizedBox(height: 6),
            const Text(
              'Camera off',
              style: TextStyle(
                color: Color(0xFF555577),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _OverlayBadge
// ─────────────────────────────────────────────────────────────────────────────

class _OverlayBadge extends StatelessWidget {
  const _OverlayBadge({
    required this.muted,
    required this.isLive,
    required this.pulseAnim,
    this.label,
    this.labelStyle,
  });

  final String? label;
  final bool muted;
  final bool isLive;
  final Animation<double> pulseAnim;
  final TextStyle? labelStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Live indicator dot
        if (isLive)
          FadeTransition(
            opacity: pulseAnim,
            child: Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(right: 6),
              decoration: const BoxDecoration(
                color: Color(0xFF00E676),
                shape: BoxShape.circle,
              ),
            ),
          ),

        // Name chip
        if (label != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label!,
                  style: labelStyle ??
                      const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                ),
                if (muted) ...[
                  const SizedBox(width: 5),
                  const Icon(
                    Icons.mic_off_rounded,
                    color: Color(0xFFFF5252),
                    size: 13,
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }
}
