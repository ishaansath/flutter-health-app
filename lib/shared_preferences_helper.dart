// lib/utils/shared_preferences_helper.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Keys for SharedPreferences
const String _lastVisitedOrganNameKey = 'lastVisitedOrganName';
const String _lastVisitedOrganImagePathKey = 'lastVisitedOrganImagePath';
const String _lastVisitedNutritionItemNameKey = 'lastVisitedNutritionItemName';
const String _lastVisitedNutritionItemImagePathKey = 'lastVisitedNutritionItemImagePath';

// Value Notifiers to allow HomePage to react to changes
final ValueNotifier<Map<String, String>?> lastVisitedOrganNotifier =
ValueNotifier<Map<String, String>?>(null);
final ValueNotifier<Map<String, String>?> lastVisitedNutritionNotifier =
ValueNotifier<Map<String, String>?>(null);

/// Saves the last visited organ's name and image path to SharedPreferences.
Future<void> saveLastVisitedOrgan(String name, String imagePath) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_lastVisitedOrganNameKey, name);
  await prefs.setString(_lastVisitedOrganImagePathKey, imagePath);
  lastVisitedOrganNotifier.value = {'name': name, 'imagePath': imagePath};
  print('Saved last visited organ: $name');
}

/// Loads the last visited organ's name and image path from SharedPreferences.
/// Returns a Map with 'name' and 'imagePath', or null if not found.
Future<Map<String, String>?> loadLastVisitedOrgan() async {
  final prefs = await SharedPreferences.getInstance();
  final name = prefs.getString(_lastVisitedOrganNameKey);
  final imagePath = prefs.getString(_lastVisitedOrganImagePathKey);
  if (name != null && imagePath != null) {
    return {'name': name, 'imagePath': imagePath};
  }
  return null;
}

/// Saves the last visited nutrition item's name and image path to SharedPreferences.
Future<void> saveLastVisitedNutritionItem(String name, String imagePath) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_lastVisitedNutritionItemNameKey, name);
  await prefs.setString(_lastVisitedNutritionItemImagePathKey, imagePath);
  lastVisitedNutritionNotifier.value = {'name': name, 'imagePath': imagePath};
  print('Saved last visited nutrition item: $name');
}

/// Loads the last visited nutrition item's name and image path from SharedPreferences.
/// Returns a Map with 'name' and 'imagePath', or null if not found.
Future<Map<String, String>?> loadLastVisitedNutritionItem() async {
  final prefs = await SharedPreferences.getInstance();
  final name = prefs.getString(_lastVisitedNutritionItemNameKey);
  final imagePath = prefs.getString(_lastVisitedNutritionItemImagePathKey);
  if (name != null && imagePath != null) {
    return {'name': name, 'imagePath': imagePath};
  }
  return null;
}

/// Initializes the notifiers by loading the last visited items when the app starts.
Future<void> initializeLastVisitedNotifiers() async {
  lastVisitedOrganNotifier.value = await loadLastVisitedOrgan();
  lastVisitedNutritionNotifier.value = await loadLastVisitedNutritionItem();
}