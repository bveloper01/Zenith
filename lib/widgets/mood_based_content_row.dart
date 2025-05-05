import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netflix_enhanced/controllers/mood_controller.dart';

class MoodBasedContentRow extends StatelessWidget {
  MoodBasedContentRow({super.key});

  final MoodController moodController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final movieImages = _getMoodBasedContent(moodController.getCurrentMood());

      return SizedBox(
        height: 160,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: movieImages.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: _getMoodColor(moodController.getCurrentMood())
                        .withOpacity(0.5),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  movieImages[index],
                  height: 140,
                  width: 220,
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
      );
    });
  }

  List<String> _getMoodBasedContent(String mood) {
    switch (mood) {
      case 'happy':
        return [
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS8fmebP0HTbJ5NhfT0mgY9Yn7hu6lzXQiJQQ&s',
          'https://rukminim2.flixcart.com/image/850/1000/poster/t/j/b/the-hangover-strips-maxi-poster-pp32366-medium-original-imadaygvyjgqs6gs.jpeg?q=90&crop=false'
        ];
      case 'sad':
        return [
          'https://i.ytimg.com/vi/fWfuedqtdi8/hq720.jpg?sqp=-oaymwEhCK4FEIIDSFryq4qpAxMIARUAAAAAGAElAADIQj0AgKJD&rs=AOn4CLDGwlhWqKOiG9k4e7BCc5KZddtpzQ',
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTKfAj5v3mQ6cGZC0lZy_q3dsrCJQsKf8_43g&s'
        ];
      default:
        return [
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRiHITW3WyOvx5mQ0nwgtpQNiEuYawikS_NgQ&s',
          'https://i0.wp.com/www.thehollywoodoutsider.com/wp-content/uploads/Anne-with-an-E.jpg?resize=660%2C330&ssl=1'
        ];
    }
  }

  Color _getMoodColor(String mood) {
    switch (mood) {
      case 'happy':
        return Colors.yellow;
      case 'sad':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
