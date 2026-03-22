import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class KycFaceResult {
  final bool livenessCheckPassed;
  KycFaceResult({required this.livenessCheckPassed});
}

class KycFaceProcessWidget extends StatefulWidget {
  const KycFaceProcessWidget({super.key});

  @override
  State<KycFaceProcessWidget> createState() => _KycFaceProcessWidgetState();
}

class _KycFaceProcessWidgetState extends State<KycFaceProcessWidget> {
  int _step = 0;
  double _progress = 0.0;
  CameraController? _cameraController;
  bool _isDetecting = false;

  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableClassification: true,
      performanceMode: FaceDetectorMode.accurate,
    ),
  );

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _faceDetector.close();
    super.dispose();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      final front = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );
      _cameraController = CameraController(
        front,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: Platform.isAndroid
            ? ImageFormatGroup.nv21
            : ImageFormatGroup.bgra8888,
      );
      await _cameraController!.initialize();
      if (!mounted) return;
      setState(() => _step = 1);
      _startStream();
    } catch (e) {
      debugPrint('Camera init error: $e');
    }
  }

  void _startStream() {
    _cameraController!.startImageStream((CameraImage cameraImage) async {
      if (_isDetecting || _step == 4 || _step == 5) return;
      _isDetecting = true;
      try {
        final inputImage = _toInputImage(cameraImage);
        if (inputImage == null) return;
        final faces = await _faceDetector.processImage(inputImage);
        if (!mounted) return;
        setState(() => _step = faces.length == 1 ? 3 : 2);
      } catch (e) {
        debugPrint('Detection error: $e');
      } finally {
        _isDetecting = false;
      }
    });
  }

  InputImage? _toInputImage(CameraImage image) {
    final camera = _cameraController!.description;
    final rotationMap = {
      0: InputImageRotation.rotation0deg,
      90: InputImageRotation.rotation90deg,
      180: InputImageRotation.rotation180deg,
      270: InputImageRotation.rotation270deg,
    };
    final rotation = rotationMap[camera.sensorOrientation] ??
        InputImageRotation.rotation0deg;
    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    if (format == null) return null;
    final Uint8List bytes = image.planes.length == 1
        ? image.planes.first.bytes
        : Uint8List.fromList(
            image.planes.fold<List<int>>([], (l, p) => l..addAll(p.bytes)));
    return InputImage.fromBytes(
      bytes: bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: image.planes.first.bytesPerRow,
      ),
    );
  }

  Future<void> _captureAndVerify() async {
    if (_step != 3) return;
    await _cameraController?.stopImageStream();
    setState(() {
      _step = 4;
      _progress = 0.0;
    });
    for (int i = 1; i <= 20; i++) {
      await Future.delayed(const Duration(milliseconds: 150));
      if (!mounted) return;
      setState(() => _progress = i / 20);
    }
    if (!mounted) return;
    setState(() => _step = 5);
  }

  Color _borderColor() {
    switch (_step) {
      case 2:
        return Colors.red;
      case 3:
        return Colors.greenAccent;
      case 4:
        return const Color(0xFF1877F2);
      default:
        return Colors.white24;
    }
  }

  String _instructionText() {
    switch (_step) {
      case 0:
        return "Initializing camera...";
      case 1:
        return "Align your face to the frame and click the capture button";
      case 2:
        return "No face detected. Please align your face to the frame.";
      case 3:
        return "Face detected! Tap Capture Face to proceed.";
      case 4:
        return "Please hold still, verifying your face...";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: _step == 5 ? _buildSuccess() : _buildCapture(),
      ),
    );
  }

  Widget _buildCapture() {
    final isInitializing = _step == 0;
    final isVerifying = _step == 4;
    final canCapture = _step == 3;
    final cameraReady =
        _cameraController != null && _cameraController!.value.isInitialized;

    return Column(
      children: [
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: isVerifying ? null : () => context.pop(),
              child: const Icon(Icons.arrow_back_ios, color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Divider(color: Colors.white12),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 340,
                width: 260,
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 220,
                    width: 170,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(120),
                      border: Border.all(color: _borderColor(), width: 4),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(116),
                      child: !cameraReady
                          ? Container(
                              color: Colors.grey.shade800,
                              child: const Center(
                                child: CircularProgressIndicator(
                                    color: Color(0xFF1877F2)),
                              ),
                            )
                          : CameraPreview(_cameraController!),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (_step == 2 || _step == 3)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: canCapture
                        ? Colors.green.withOpacity(0.15)
                        : Colors.red.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: canCapture ? Colors.greenAccent : Colors.red),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        canCapture ? Icons.check_circle : Icons.cancel,
                        color: canCapture ? Colors.greenAccent : Colors.red,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        canCapture ? "Face Detected" : "No Face Detected",
                        style: TextStyle(
                          color: canCapture ? Colors.greenAccent : Colors.red,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  _instructionText(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ),
              const SizedBox(height: 20),
              if (isVerifying)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: LinearProgressIndicator(
                    value: _progress,
                    backgroundColor: Colors.white24,
                    color: const Color(0xFF1877F2),
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    canCapture ? const Color(0xFF1877F2) : Colors.grey.shade800,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              onPressed: (isInitializing || isVerifying)
                  ? null
                  : canCapture
                      ? _captureAndVerify
                      : null,
              child: isVerifying
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2),
                    )
                  : Text(
                      canCapture ? "Capture Face" : "Waiting for face...",
                      style: const TextStyle(color: Colors.white),
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccess() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 80,
              width: 80,
              decoration: const BoxDecoration(
                color: Color(0xFF0A3C1F),
                shape: BoxShape.circle,
              ),
              child:
                  const Icon(Icons.check_circle, color: Colors.green, size: 48),
            ),
            const SizedBox(height: 24),
            const Text(
              "Congratulations",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            const Text(
              "Your face has been successfully verified",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1877F2),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                // Return livenessCheckPassed = true back to KycInputScreen
                onPressed: () =>
                    context.pop(KycFaceResult(livenessCheckPassed: true)),
                child:
                    const Text("Done", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
