// lib/mascot_provider.dart
import 'package:flutter/material.dart';

class MascotProvider extends ChangeNotifier {
  // Store a map where each mascot name points to another map
  // containing its static image path and its speaking GIF path.
  final Map<String, Map<String, dynamic>> _mascotAssets = {
    'Coco': {
      'static': 'assets/mascot/Coco.png', // Static image path
      'speaking': 'assets/mascot/CocoTalking.gif',
      'description': 'Coco is a cheerful blue and amber space bunny who zooms around the galaxy to learn about healthy food and strong bodies. With space boots and a suit, Coco helps kids stay happy, active, and smart—one planet at a time!',
      'tone': 'Coco speaks very energetically and enthusiastically.',
      'ttsVoice': {
        'name': 'en-US-Wavenet-C',
        'language': 'en-US',
        'pitch': 1,
      },
    },
    'Melonzo': {
      'static': 'assets/mascot/Melonzo.png',
      'speaking': 'assets/mascot/MelonzoTalking.gif',
      'description': 'Melonzo is a lively watermelon who came to life after sipping a magical health potion! Now with arms and legs, he spreads juicy tips about eating right and staying cool and strong.',
      'tone': 'Melonzo speaks normally.',
      'ttsVoice': {
        'name': 'Karen',
        'language': 'en-AU',
        'pitch': 1,
      },
    },
    'Sage Broccoli': {
      'static': 'assets/mascot/Sage Broccoli.png',
      'speaking': 'assets/mascot/SageBroccoliTalking.gif',
      'description': 'Sage Broccoli is a wise, old veggie who knows all about healthy living. With his leafy beard and calm voice, he shares green wisdom to help everyone grow strong and smart.',
      'tone': 'Sage Broccoli speaks very calmly and uses old language.',
      'ttsVoice': {
        'name': 'en-gb-x-gbb-local',
        'language': 'en-GB',
        'pitch': 1,
      },
    },
  };

  String _currentMascotName = 'Coco'; // Default mascot

  String get currentMascotName => _currentMascotName;

  // Getters for the current mascot's specific asset paths
  String get currentMascotStaticPath => _mascotAssets[_currentMascotName]!['static']!;
  String get currentMascotSpeakingPath => _mascotAssets[_currentMascotName]!['speaking']!;
  String get currentMascotDesc => _mascotAssets[_currentMascotName]!['description']!;
  String get currentMascotTone => _mascotAssets[_currentMascotName]!['tone']!;
  Map<String, dynamic> get currentMascotTtsVoiceSettings => _mascotAssets[_currentMascotName]!['ttsVoice']!;


  Map<String, String> get allMascotStaticPaths {
    return _mascotAssets.map((name, paths) => MapEntry(name, paths['static']!));
  }

  void setMascot(String newMascotName) {
    if (_mascotAssets.containsKey(newMascotName) && _currentMascotName != newMascotName) {
      _currentMascotName = newMascotName;
      notifyListeners();
    }
  }
}