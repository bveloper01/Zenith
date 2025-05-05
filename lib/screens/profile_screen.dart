import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netflix_enhanced/controllers/auth_controller.dart';
import 'package:netflix_enhanced/controllers/mood_controller.dart';

class ProfileScreen extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final MoodController moodController = Get.find<MoodController>();

  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authController.signOut();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundColor: Colors.red,
              child: Icon(Icons.person, size: 80, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Text(
              authController.user.value?.email ?? 'User',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            const Text(
              'How are you feeling right now?',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _moodButton('Happy', '😊', 'happy'),
                    _moodButton('Neutral', '😐', 'neutral'),
                    _moodButton('Sad', '😢', 'sad'),
                  ],
                )),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
              icon: const Icon(
                Icons.camera_alt,
                color: Colors.white,
              ),
              label: const Text(
                'AI Mood Detection',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () => Get.toNamed('/mood_detection'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              ),
              onPressed: () => Get.offNamed('/home'),
              child: const Text('View Recommendations',
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _moodButton(String label, String emoji, String mood) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => moodController.setMood(mood),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: moodController.currentMood.value == mood
                    ? Colors.red
                    : Colors.grey[800],
                shape: BoxShape.circle,
              ),
              child: Text(emoji, style: const TextStyle(fontSize: 30)),
            ),
          ),
          const SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }
}
