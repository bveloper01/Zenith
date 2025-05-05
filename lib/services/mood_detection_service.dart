import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:netflix_enhanced/controllers/mood_controller.dart';
import 'package:netflix_enhanced/services/gemini_service.dart';

class MoodDetectionService {
  final MoodController moodController = Get.find<MoodController>();
  final GeminiService _geminiService = GeminiService();
  
  Future<String> detectMoodFromImage(Uint8List imageBytes) async {
    try {
      String detectedMood = await _geminiService.detectMoodFromImage(imageBytes);
      await moodController.setMood(detectedMood);
      
      return detectedMood;
    } catch (e) {
      print('Error in mood detection: $e');
      String fallbackMood = 'neutral';
      await moodController.setMood(fallbackMood);
      return fallbackMood;
    }
  }
}