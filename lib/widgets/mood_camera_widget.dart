import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netflix_enhanced/controllers/mood_controller.dart';
import 'package:netflix_enhanced/services/gemini_service.dart';
import 'package:camera/camera.dart';

class MoodCameraWidget extends StatefulWidget {
  const MoodCameraWidget({super.key});

  @override
  _MoodCameraWidgetState createState() => _MoodCameraWidgetState();
}

class _MoodCameraWidgetState extends State<MoodCameraWidget> {
  CameraController? _cameraController;
  final GeminiService _geminiService = GeminiService();
  final MoodController _moodController = Get.find();
  bool _isInitialized = false;
  bool _isDetecting = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        return;
      }
      _cameraController = CameraController(
        cameras.first,
        ResolutionPreset.medium,
        enableAudio: false,
      );
      await _cameraController!.initialize();
      if (!mounted) return;
      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      print('Camera initialization failed: $e');
    }
  }

  Future<void> _captureAndDetect() async {
    if (_isDetecting) return;
    setState(() {
      _isDetecting = true;
    });

    try {
      Uint8List? imageBytes;
      if (_isInitialized && _cameraController != null) {
        try {
          final XFile imageFile = await _cameraController!.takePicture();
          imageBytes = await imageFile.readAsBytes();
        } catch (e) {
          print('Error capturing image: $e');
        }
      }

      if (imageBytes != null) {
        final detectedMood =
            await _geminiService.detectMoodFromImage(imageBytes);

        Get.snackbar(
          'Mood Detected!',
          'You seem to be feeling $detectedMood. We\'ve updated your recommendations.',
          colorText: Colors.white,
          backgroundColor: Colors.green.withOpacity(0.7),
          duration: const Duration(seconds: 3),
        );

        _moodController.updateMood(detectedMood);
      }

      await Future.delayed(const Duration(seconds: 1));

      Get.offNamed('/home');
    } catch (e) {
      print('Detection error: $e');
      Get.snackbar(
        'Error',
        'Failed to detect mood, please try again.',
        colorText: Colors.white,
        backgroundColor: const Color(0XFFE50914),
      );
    } finally {
      setState(() {
        _isDetecting = false;
      });
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget cameraPreview = Container(
      height: 300,
      width: 300,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[800]!, width: 2),
      ),
      child: _isInitialized && _cameraController != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: CameraPreview(_cameraController!),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt, size: 50, color: Colors.grey[600]),
                  const SizedBox(height: 10),
                  Text(
                    'Camera preview unavailable',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
    );

    return Column(
      children: [
        cameraPreview,
        const SizedBox(height: 20),
        const Text(
          'Look at the camera for mood detection',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0XFFE50914),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
          ),
          icon: const Icon(
            Icons.camera_alt,
            color: Colors.white,
          ),
          label: Text(
            _isDetecting ? 'Analyzing...' : 'Detect My Mood',
            style: const TextStyle(color: Colors.white),
          ),
          onPressed: _isDetecting ? null : _captureAndDetect,
        ),
      ],
    );
  }
}
