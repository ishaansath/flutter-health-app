// lib/account_settings.dart (MODIFIED - Triggers full app refresh on save)

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ishaan/auth_firebase_data.dart';
import 'package:ishaan/login_screen.dart';
import 'package:ishaan/main.dart';
import 'package:lottie/lottie.dart'; // Ensure Lottie is imported

class AccountSettingsPage extends StatefulWidget {
  final ValueNotifier<ThemeMode> themeModeNotifier;

  const AccountSettingsPage({super.key, required this.themeModeNotifier});

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthFirebaseDataSource _authService = AuthFirebaseDataSourceImpl();

  User? _currentUser;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  String? _selectedGender;

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser;
    _loadUserData();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  void _clearError() {
    setState(() {
      _errorMessage = null;
    });
  }

  Future<void> _loadUserData() async {
    if (_currentUser == null) {
      _showSnackBar('User not logged in.');
      return;
    }

    _clearError();
    setState(() {
      _isLoading = true;
    });

    try {
      final userProfile = await _authService.getUserProfile(_currentUser!.uid);

      if (userProfile != null) {
        _firstNameController.text = userProfile.firstName;
        _lastNameController.text = userProfile.lastName;
        _selectedGender = userProfile.gender;
        _ageController.text = userProfile.age?.toString() ?? '';
      } else {
        final String? displayName = _currentUser?.displayName;
        List<String> nameParts = displayName?.split(' ') ?? [];

        _firstNameController.text = nameParts.isNotEmpty ? nameParts[0] : '';
        _lastNameController.text = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
        _selectedGender = 'Prefer not to say';
        _ageController.text = '';
      }
    } on FirebaseException catch (e) {
      _errorMessage = 'Failed to load user data: ${e.message}';
      print('Firebase Error loading user data: $e');
    } catch (e) {
      _errorMessage = 'Failed to load user data: $e';
      print('General Error loading user data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveChanges() async {
    if (_currentUser == null) {
      _showSnackBar('User not logged in.');
      return;
    }

    _clearError();
    setState(() {
      _isLoading = true;
    });

    try {
      final String newFirstName = _firstNameController.text.trim();
      final String newLastName = _lastNameController.text.trim();
      final String newGender = _selectedGender ?? 'Prefer not to say';
      final int? newAge = int.tryParse(_ageController.text.trim());

      if (newFirstName.isEmpty || newLastName.isEmpty || _selectedGender == null || _ageController.text.isEmpty) {
        _showSnackBar('Please fill in all required fields.');
        setState(() { _isLoading = false; });
        return;
      }

      if (newAge == null || newAge <= 0 || newAge > 100) {
        _showSnackBar('Please enter a valid age (1-100).');
        setState(() { _isLoading = false; });
        return;
      }

      await _authService.updateUserData(
        _currentUser!.uid,
        newFirstName,
        newLastName,
        newGender,
        newAge,
      );

      await _currentUser!.reload();
      _currentUser = _auth.currentUser;

      _showSnackBar('Changes saved successfully!');
      print('User details saved to Firestore and Firebase Auth updated.');

      appRefreshTriggerNotifier.value++;
      print('AccountSettingsPage: Triggered full app refresh.');

    } on FirebaseAuthException catch (e) {
      _errorMessage = 'Failed to save changes: ${e.message}';
      print('Firebase Auth Error saving changes: $e');
    } on FirebaseException catch (e) {
      _errorMessage = 'Failed to save changes: ${e.message}';
      print('Firebase Error saving changes: $e');
    } catch (e) {
      _errorMessage = '';
      print('General Error saving changes: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    _clearError();
    setState(() {
      _isLoading = true;
    });
    try {
      await _authService.logout();

      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginScreen(themeModeNotifier: widget.themeModeNotifier)),
              (Route<dynamic> route) => false,
        );
      }
      print('Successfully logged out and navigated to login screen.');
    } on FirebaseAuthException catch (e) {
      _errorMessage = 'Logout failed: ${e.message}';
      print('Firebase Auth Error during logout: $e');
    } catch (e) {
      _errorMessage = 'Logout failed: $e';
      print('General Error during logout: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine Lottie animation path based on current theme brightness
    final isDarkMode = theme.brightness == Brightness.dark;
    final String lottieAssetPath = isDarkMode
        ? 'assets/animations/dark/loading.json'
        : 'assets/animations/light/loading.json';

    return Scaffold(
      backgroundColor: colorScheme.primary,
      appBar: AppBar(
        title: Text(
          'Account Settings',
          style: theme.textTheme.titleLarge?.copyWith(color: colorScheme.onSecondary),
        ),
        backgroundColor: colorScheme.primary,
        iconTheme: IconThemeData(color: colorScheme.onSecondary),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(
        // NEW: Replace CircularProgressIndicator with Lottie animation
        child: Lottie.asset(
          lottieAssetPath,
          width: 200, // Adjust size as needed
          height: 200, // Adjust size as needed
          fit: BoxFit.contain,
          repeat: true, // Make the animation loop
        ),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profile Information',
              style: theme.textTheme.headlineSmall?.copyWith(color: colorScheme.onSecondary),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: _firstNameController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                labelText: 'First Name',
                labelStyle: theme.textTheme.headlineSmall,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                prefixIcon: Icon(Icons.person, color: colorScheme.secondary),
              ),
              style: theme.textTheme.bodyLarge?.copyWith(color: colorScheme.onSecondary),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _lastNameController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                labelText: 'Last Name',
                labelStyle: theme.textTheme.headlineSmall,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                prefixIcon: Icon(Icons.person, color: colorScheme.secondary),
              ),
              style: theme.textTheme.bodyLarge?.copyWith(color: colorScheme.onSecondary),
            ),
            const SizedBox(height: 16),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  child: Text(
                    'Gender:',
                    style: theme.textTheme.headlineSmall?.copyWith(color: colorScheme.onSecondary),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                        title: Text('Male', style: theme.textTheme.bodyLarge?.copyWith(color: colorScheme.onSecondary)),
                        value: 'Male',
                        groupValue: _selectedGender,
                        onChanged: (String? value) {
                          setState(() {
                            _selectedGender = value;
                          });
                        },
                        activeColor: colorScheme.secondary,
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        title: Text('Female', style: theme.textTheme.bodyLarge?.copyWith(color: colorScheme.onSecondary)),
                        value: 'Female',
                        groupValue: _selectedGender,
                        onChanged: (String? value) {
                          setState(() {
                            _selectedGender = value;
                          });
                        },
                        activeColor: colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Age',
                labelStyle: theme.textTheme.headlineSmall,
                hintText: 'Enter your age',
                hintStyle: theme.textTheme.bodyMedium,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                prefixIcon: Icon(Icons.cake, color: colorScheme.secondary),
              ),
              style: theme.textTheme.bodyLarge?.copyWith(color: colorScheme.onSecondary),
            ),
            const SizedBox(height: 32),

            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.error),
                textAlign: TextAlign.center,
              ),
            if (_errorMessage != null) const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.secondary,
                  foregroundColor: colorScheme.onSecondary,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: _isLoading
                    ? Lottie.asset( // NEW: Lottie for Save Changes button
                  lottieAssetPath, // Reusing the same loading animation
                  height: 30, // Smaller size for button
                  width: 30,
                  fit: BoxFit.contain,
                  repeat: true,
                )
                    : Text(
                  'Save Changes',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSecondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _isLoading ? null : _logout,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: colorScheme.error, width: 2),
                  foregroundColor: colorScheme.error,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: _isLoading
                    ? Lottie.asset( // NEW: Lottie for Log Out button
                  lottieAssetPath, // Reusing the same loading animation
                  height: 30, // Smaller size for button
                  width: 30,
                  fit: BoxFit.contain,
                  repeat: true,
                )
                    : Text(
                  'Log Out',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}