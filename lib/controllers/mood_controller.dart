import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:netflix_enhanced/controllers/auth_controller.dart';

class MoodController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthController _authController = Get.find();  RxString currentMood = 'neutral'.obs;

  void updateMood(String newMood) {
    currentMood.value = newMood;
  }

  String getCurrentMood() {
    return currentMood.value;
  }


  @override
   void onInit() {
    super.onInit();
    ever(_authController.user, (_) {
      if (_authController.user.value != null) {
        _loadUserMood();
      }
    });
  }

  Future _loadUserMood() async {
    if (_authController.user.value != null) {
      try {
        final doc = await _firestore
            .collection('users')
            .doc(_authController.user.value!.uid)
            .get();
        if (doc.exists && doc.data()!.containsKey('lastMood')) {
          currentMood.value = doc.data()!['lastMood'];
        }
      } catch (e) {
        print('Error loading mood: $e');
      }
    }
  }

  Future setMood(String mood) async {
    currentMood.value = mood;
    if (_authController.user.value != null) {
      await _firestore.collection('users').doc(_authController.user.value!.uid).set({
        'lastMood': mood,
        'lastMoodTimestamp': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
  }

  List getMoodBasedCategories() {
    switch (currentMood.value) {
      case 'happy':
        return ['Comedy', 'Action', 'Adventure'];
      case 'sad':
        return ['Feel-Good', 'Inspirational', 'Romance'];
      case 'neutral':
      default:
        return ['Trending', 'Popular', 'New Releases'];
    }
  }

  List getMoodBasedContent() {
    switch (currentMood.value) {
      case 'happy':
        return [
          'https://occ-0-1068-92.1.nflxso.net/dnm/api/v6/X194eJsgWBDE2aQbaNdmCXGUP-Y/AAAABeLVkcxLMcpHOSZaseUVN2rbJfJOHCXggh1BzH5uq8wVSS2IuihM9GnrxxN2-yJNmFkJ4SnZUQ-OjJX6NQz2v40A28A.jpg?r=e35',
          'https://occ-0-1068-92.1.nflxso.net/dnm/api/v6/X194eJsgWBDE2aQbaNdmCXGUP-Y/AAAABQkXrF2FQDSKpvurhLpZSr5h79DJJhTiiFGwmQIlbXmQEZheCnuFDT2JFmEP8rCiURTG-GUHCscZOxnDmozK_c4XTTc.jpg?r=7ed',
          'https://occ-0-1068-92.1.nflxso.net/dnm/api/v6/X194eJsgWBDE2aQbaNdmCXGUP-Y/AAAABaKfxwbpKYKYWlnyi8-hsVmQJXrTarYxgznV1yYZQgp-c-r2o9YKnUMV3Vh0UN4hcnH9lf1ivI3Ty2FKz4uPaYA_4xg.jpg?r=867'
        ];
      case 'sad':
        return [
          'https://occ-0-1068-92.1.nflxso.net/dnm/api/v6/X194eJsgWBDE2aQbaNdmCXGUP-Y/AAAABW3A_IwMbOIghSm6DAZeIkNsn8jOI_u5-QPNY-4MRTUXYJJbpUkEOPj9BC_i9-ozPJxXz4wXBWnOWY-BTYFdviTfRgo.jpg?r=6c8',
          'https://occ-0-1068-92.1.nflxso.net/dnm/api/v6/X194eJsgWBDE2aQbaNdmCXGUP-Y/AAAABZs6KL5YvhjlHwXFVYOLFyBgQRHvFhLzNF5a0Cjl3fXmhJrXGGYc1BQ9MFLB2cGUUmAJC89-P41jPbOpI1y42EwI38Q.jpg?r=4f5',
          'https://occ-0-1068-92.1.nflxso.net/dnm/api/v6/X194eJsgWBDE2aQbaNdmCXGUP-Y/AAAABTcVkwBCJ2j_yQUovM2MlkGWVdl5BfzYO_PNiWfIJxjSgueU2wPGFfY5b8-JmQK_56crM-ZdF2a4MoXA-CLNKlWLDQA.jpg?r=c68'
        ];
      default:
        return [
          'https://occ-0-1068-92.1.nflxso.net/dnm/api/v6/X194eJsgWBDE2aQbaNdmCXGUP-Y/AAAABQkXrF2FQDSKpvurhLpZSr5h79DJJhTiiFGwmQIlbXmQEZheCnuFDT2JFmEP8rCiURTG-GUHCscZOxnDmozK_c4XTTc.jpg?r=7ed',
          'https://occ-0-1068-92.1.nflxso.net/dnm/api/v6/X194eJsgWBDE2aQbaNdmCXGUP-Y/AAAABW3A_IwMbOIghSm6DAZeIkNsn8jOI_u5-QPNY-4MRTUXYJJbpUkEOPj9BC_i9-ozPJxXz4wXBWnOWY-BTYFdviTfRgo.jpg?r=6c8',
          'https://occ-0-1068-92.1.nflxso.net/dnm/api/v6/X194eJsgWBDE2aQbaNdmCXGUP-Y/AAAABZs6KL5YvhjlHwXFVYOLFyBgQRHvFhLzNF5a0Cjl3fXmhJrXGGYc1BQ9MFLB2cGUUmAJC89-P41jPbOpI1y42EwI38Q.jpg?r=4f5'
        ];
    }
  }
}
