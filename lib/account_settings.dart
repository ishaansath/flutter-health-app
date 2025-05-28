import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ishaan/auth_firebase_data.dart'; // Make sure this is imported
import 'package:ishaan/login_screen.dart'; // Import your LoginScreen

class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({super.key});

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _currentUser;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  String? _selectedGender;
  bool _isLoading = false;

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
    super.dispose();
  }

  Future<void> _loadUserData() async {
    if (_currentUser == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final userDoc = await _firestore.collection('users').doc(_currentUser!.uid).get();
      if (userDoc.exists) {
        final data = userDoc.data();
        _firstNameController.text = data?['firstName'] ?? '';
        _lastNameController.text = data?['lastName'] ?? '';
        _selectedGender = data?['gender'];
      } else {
        // Corrected null-safety for displayName and splitting
        // This was likely the source of "The operator '>' can't be unconditionally invoked because the receiver can be 'null'."
        final String? displayName = _currentUser?.displayName;
        List<String> nameParts = displayName?.split(' ') ?? [];

        _firstNameController.text = nameParts.isNotEmpty ? nameParts[0] : '';
        _lastNameController.text = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
        _selectedGender = 'Prefer not to say'; // Default if not found
      }
    } catch (e) {
      print('Error loading user data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load user data: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveChanges() async {
    if (_currentUser == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final String newFirstName = _firstNameController.text.trim();
      final String newLastName = _lastNameController.text.trim();
      final String newGender = _selectedGender ?? 'Prefer not to say';

      // 1. Update Firebase Auth profile (displayName)
      String newDisplayName = '';
      if (newFirstName.isNotEmpty) newDisplayName += newFirstName;
      if (newLastName.isNotEmpty) {
        if (newDisplayName.isNotEmpty) newDisplayName += ' ';
        newDisplayName += newLastName;
      }

      if (newDisplayName.isNotEmpty && _currentUser!.displayName != newDisplayName) {
        await _currentUser!.updateDisplayName(newDisplayName);
        print('Updated Firebase Auth display name: $newDisplayName');
      }

      // 2. Save data to Firestore
      await _firestore.collection('users').doc(_currentUser!.uid).set({
        'firstName': newFirstName,
        'lastName': newLastName,
        'gender': newGender,
        'email': _currentUser!.email,
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // 3. Reload current user to reflect latest changes locally
      await _currentUser!.reload();
      _currentUser = _auth.currentUser; // Update the local _currentUser instance

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Changes saved successfully!')),
      );
      print('User details saved to Firestore and Firebase Auth updated.');

    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Error saving changes: ${e.code} - ${e.message}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save changes: ${e.message}')),
      );
    } catch (e) {
      print('General Error saving changes: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save changes: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // --- LOGOUT BUTTON IMPLEMENTATION ---
  Future<void> _logout() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final AuthFirebaseDataSourceImpl authDataSource = AuthFirebaseDataSourceImpl();
      await authDataSource.logout();

      if (mounted) {
        // Navigate to LoginScreen and remove all previous routes
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginScreen(themeModeNotifier: ValueNotifier(ThemeMode.system))),
              (Route<dynamic> route) => false, // This predicate ensures all previous routes are removed
        );
      }
      print('Successfully logged out and navigated to login screen.');
    } catch (e) {
      print('Error during logout: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout failed: $e')),
      );
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

    return Scaffold(
      backgroundColor: colorScheme.primary,
      appBar: AppBar(
        title: Text(
          'Account Settings',
          style: theme.textTheme.titleLarge?.copyWith(color: colorScheme.onPrimary),
        ),
        backgroundColor: colorScheme.primary,
        iconTheme: IconThemeData(color: colorScheme.onPrimary),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: colorScheme.secondary))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profile Information',
              style: theme.textTheme.headlineSmall?.copyWith(color: colorScheme.onBackground),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _firstNameController,
              decoration: InputDecoration(
                labelText: 'First Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                prefixIcon: Icon(Icons.person, color: colorScheme.onSurfaceVariant),
              ),
              style: TextStyle(color: colorScheme.onBackground),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _lastNameController,
              decoration: InputDecoration(
                labelText: 'Last Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                prefixIcon: Icon(Icons.person, color: colorScheme.onSurfaceVariant),
              ),
              style: TextStyle(color: colorScheme.onSecondary),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedGender,
              decoration: InputDecoration(
                labelText: 'Gender',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                prefixIcon: Icon(Icons.transgender, color: colorScheme.onSurfaceVariant),
              ),
              items: <String>['Male', 'Female', 'None']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedGender = newValue;
                });
              },
              style: TextStyle(color: colorScheme.onBackground),
              dropdownColor: colorScheme.surface,
            ),
            const SizedBox(height: 32),
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
                    ? CircularProgressIndicator(
                  color: colorScheme.onSecondary,
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
            // --- LOGOUT BUTTON ---
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
                    ? CircularProgressIndicator(
                  color: colorScheme.error,
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