import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;

class GeminiService {
  static String API_KEY = dotenv.env['API_KEY']!;
  final GenerativeModel _model;

  GeminiService()
      : _model = GenerativeModel(
          model: dotenv.env['model']!,
          apiKey: API_KEY,
        );

  Future<String> detectMoodFromImage(Uint8List imageBytes) async {
    try {
      final promptPart = TextPart(
        '${dotenv.env['prompt']}',
      );

      final imagePart = DataPart('image/jpeg', imageBytes);

      final content = Content.multi([promptPart, imagePart]);

      final response = await _model.generateContent([content]);

      final text = response.text?.toLowerCase().trim() ?? 'neutral';

      if (text.contains('happy') ||
          text.contains('joy') ||
          text.contains('excited')) {
        return 'happy';
      } else if (text.contains('sad') ||
          text.contains('angry') ||
          text.contains('fear')) {
        return 'sad';
      } else {
        return 'neutral';
      }
    } catch (e) {
      print('Gemini API error: $e');
      return 'neutral';
    }
  }

  Future<String> detectMoodWithHttp(Uint8List imageBytes) async {
    try {
      final base64Image = base64Encode(imageBytes);

      final response = await http.post(
        Uri.parse(
            'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$API_KEY'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {
                  'text':
                      'Analyze this facial image and determine the emotion. Respond with EXACTLY ONE WORD from these options: happy, sad, neutral. Nothing else.'
                },
                {
                  'inline_data': {
                    'mime_type': 'image/jpeg',
                    'data': base64Image
                  }
                }
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text =
            data['candidates'][0]['content']['parts'][0]['text'] ?? 'neutral';

        final normalizedText = text.toLowerCase().trim();
        if (normalizedText.contains('happy') ||
            normalizedText.contains('joy')) {
          return 'happy';
        } else if (normalizedText.contains('sad') ||
            normalizedText.contains('anger')) {
          return 'sad';
        } else {
          return 'neutral';
        }
      } else {
        print('API error: ${response.statusCode} - ${response.body}');
        return 'neutral';
      }
    } catch (e) {
      print('HTTP error: $e');
      return 'neutral';
    }
  }
}
