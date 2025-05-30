// lib/mascot_provider.dart
import 'package:flutter/material.dart';

class MascotProvider extends ChangeNotifier {
  // Store a map where each mascot name points to another map
  // containing its static image path and its speaking GIF path.
  final Map<String, Map<String, String>> _mascotAssets = {
    'Coco': {
      'static': 'assets/mascot/Coco.png', // Static image path
      'speaking': 'assets/mascot/CocoTalking.gif', // GIF path when speaking
    },
    'Melonzo': {
      'static': 'assets/mascot/Melonzo.png',
      'speaking': 'assets/mascot/MelonzoTalking.gif',
    },
  };

  String _currentMascotName = 'Coco'; // Default mascot

  String get currentMascotName => _currentMascotName;

  // Getters for the current mascot's specific asset paths
  String get currentMascotStaticPath => _mascotAssets[_currentMascotName]!['static']!;
  String get currentMascotSpeakingPath => _mascotAssets[_currentMascotName]!['speaking']!;

  // This getter will be used for the selection dialog to show static previews
  Map<String, String> get allMascotStaticPaths {
    return _mascotAssets.map((name, paths) => MapEntry(name, paths['static']!));
  }

  void setMascot(String newMascotName) {
    if (_mascotAssets.containsKey(newMascotName) && _currentMascotName != newMascotName) {
      _currentMascotName = newMascotName;
      notifyListeners(); // Notify all listening widgets to rebuild
    }
  }
}