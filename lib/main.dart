import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:netflix_enhanced/controllers/auth_controller.dart';
import 'package:netflix_enhanced/controllers/mood_controller.dart';
import 'package:netflix_enhanced/screens/splash_screen.dart';
import 'package:netflix_enhanced/screens/login_screen.dart';
import 'package:netflix_enhanced/screens/signup_screen.dart';
import 'package:netflix_enhanced/screens/home_screen.dart';
import 'package:netflix_enhanced/screens/profile_screen.dart';
import 'package:netflix_enhanced/screens/mood_detection_screen.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: dotenv.env['apiKey']!,
      authDomain: dotenv.env['authDomain']!,
      projectId: dotenv.env['projectId']!,
      storageBucket: dotenv.env['storageBucket']!,
      messagingSenderId: dotenv.env['messagingSenderId']!,
      appId: dotenv.env['appId']!,
    ),
  );

  Get.put(AuthController());
  Get.put(MoodController());

  runApp(const NetflixEnhanced());
}

class NetflixEnhanced extends StatelessWidget {
  const NetflixEnhanced({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Netflix Enhanced',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.red,
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => SplashScreen()),
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/signup', page: () => SignupScreen()),
        GetPage(name: '/home', page: () => HomeScreen()),
        GetPage(name: '/profile', page: () => ProfileScreen()),
        GetPage(
            name: '/mood_detection', page: () => const MoodDetectionScreen()),
      ],
    );
  }
}
