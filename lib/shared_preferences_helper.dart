// lib/utils/shared_preferences_helper.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_data.dart';

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
Future<void> saveLastVisitedOrgan(String name, String image) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_lastVisitedOrganNameKey, name);
  await prefs.setString(_lastVisitedOrganImagePathKey, image);
  lastVisitedOrganNotifier.value = {'name': name, 'image': image};
  print('Saved last visited organ: $name');
}

/// Loads the last visited organ's name and image path from SharedPreferences.
/// Returns a Map with 'name' and 'imagePath', or null if not found.
Future<Map<String, String>?> loadLastVisitedOrgan() async {
  final prefs = await SharedPreferences.getInstance();
  final name = prefs.getString(_lastVisitedOrganNameKey);
  final image = prefs.getString(_lastVisitedOrganImagePathKey);
  if (name != null && image != null) {
    return {'name': name, 'image': image};
  }
  return null;
}

/// Saves the last visited nutrition item's name and image path to SharedPreferences.
Future<void> saveLastVisitedNutritionItem(String name, String image) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_lastVisitedNutritionItemNameKey, name);
  await prefs.setString(_lastVisitedNutritionItemImagePathKey, image);
  lastVisitedNutritionNotifier.value = {'name': name, 'image': image};
  print('Saved last visited nutrition item: $name');
}

/// Loads the last visited nutrition item's name and image path from SharedPreferences.
/// Returns a Map with 'name' and 'imagePath', or null if not found.
Future<Map<String, String>?> loadLastVisitedNutritionItem() async {
  final prefs = await SharedPreferences.getInstance();
  final name = prefs.getString(_lastVisitedNutritionItemNameKey);
  final image = prefs.getString(_lastVisitedNutritionItemImagePathKey);
  if (name != null && image != null) {
    return {'name': name, 'image': image};
  }
  return null;
}

/// Initializes the notifiers by loading the last visited items when the app starts.
Future<void> initializeLastVisitedNotifiers() async {
  lastVisitedOrganNotifier.value = await loadLastVisitedOrgan();
  lastVisitedNutritionNotifier.value = await loadLastVisitedNutritionItem();
}