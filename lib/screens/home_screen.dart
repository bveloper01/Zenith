import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netflix_enhanced/controllers/auth_controller.dart';
import 'package:netflix_enhanced/controllers/mood_controller.dart';
import 'package:netflix_enhanced/widgets/content_row.dart';
import 'package:netflix_enhanced/widgets/mood_based_content_row.dart';

class HomeScreen extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final MoodController moodController = Get.find<MoodController>();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        foregroundColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Image.network(
          "https://upload.wikimedia.org/wikipedia/commons/7/7a/Logonetflix.png",
          height: 35,
          width: 120,
          color: Colors.red,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          GestureDetector(
            onTap: () => Get.toNamed('/profile'),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.red,
                child: Icon(Icons.person, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 700,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      "https://images.bauerhosting.com/legacy/empire-images/features/57f4e2860c6437272f60243b/Stranger%20Things%20poster.jpg?ar=16%3A9&fit=crop&crop=top&auto=format&w=undefined&q=80"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.2),
                          Colors.black,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 80,
                    left: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'STRANGER THINGS',
                          style: TextStyle(
                              fontSize: 36, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black,
                                  ),
                                  icon: const Icon(Icons.play_arrow),
                                  label: const Text('Play'),
                                  onPressed: () {},
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Colors.white.withOpacity(0.3),
                                    foregroundColor: Colors.white,
                                  ),
                                  icon: const Icon(Icons.info_outline),
                                  label: const Text('More Info'),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            const Text(
                                '''Stranger Things is a sci-fi horror series set in the 1980s, centered on a group of kids uncovering supernatural mysteries in their small town.
It follows the disappearance of a boy, the appearance of a girl with psychokinetic powers, and a secret government lab linked to a parallel dimension called the Upside Down.
The show blends nostalgia, suspense, and emotional character arcs, creating a gripping mix of horror, adventure, and friendship'''),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Obx(() {
              final moodText = moodController.currentMood.value.capitalizeFirst;
              return Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Text(
                            'Because You\'re Feeling $moodText',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            moodController.currentMood.value == 'happy'
                                ? Icons.sentiment_very_satisfied
                                : moodController.currentMood.value == 'sad'
                                    ? Icons.sentiment_very_dissatisfied
                                    : Icons.sentiment_neutral,
                            color: moodController.currentMood.value == 'happy'
                                ? Colors.yellow
                                : moodController.currentMood.value == 'sad'
                                    ? Colors.blue
                                    : Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Colors.blue, Colors.purple],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.smart_toy,
                                    color: Colors.white, size: 12),
                                SizedBox(width: 4),
                                Text(
                                  'AI',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    MoodBasedContentRow(),
                  ],
                ),
              );
            }),
            const ContentRow(title: "Trending Now"),
            const ContentRow(title: "New Releases"),
            const ContentRow(title: "Watch It Again"),
            const ContentRow(title: "My List"),
          ],
        ),
      ),
    );
  }
}
