// lib/login_screen.dart (MODIFIED for First Name, Last Name, Gender, Age in Sign Up)

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Note: Removed direct imports for HelpPage and BodyScreen, as main.dart manages navigation.
import 'package:ishaan/auth_firebase_data.dart'; // Ensure this is imported

class LoginScreen extends StatefulWidget {
  final ValueNotifier<ThemeMode> themeModeNotifier;

  const LoginScreen({super.key, required this.themeModeNotifier});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  String? _selectedGender; // Male, Female, or Not Specified

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool _isLogin = true;
  bool _isLoading = false;
  String? _errorMessage; // For local error display

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthFirebaseDataSource _authService = AuthFirebaseDataSourceImpl(); // Instantiate your service

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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

  Future<void> _submitAuthForm() async {
    _clearError();

    setState(() {
      _isLoading = true;
    });

    try {
      if (_isLogin) {
        await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      } else {
        // Sign Up Flow
        if (_passwordController.text != _confirmPasswordController.text) {
          _showSnackBar('Passwords do not match!');
          setState(() { _isLoading = false; });
          return;
        }
        if (_firstNameController.text.isEmpty ||
            _lastNameController.text.isEmpty ||
            _selectedGender == null ||
            _ageController.text.isEmpty) {
          _showSnackBar('Please fill in all required fields.');
          setState(() { _isLoading = false; });
          return;
        }

        final int? age = int.tryParse(_ageController.text.trim());
        if (age == null || age <= 0 || age > 120) { // Added age validation
          _showSnackBar('Please enter a valid age (1-120).');
          setState(() { _isLoading = false; });
          return;
        }

        await _authService.signUpWithEmailAndPassword(
          _emailController.text.trim(),
          _passwordController.text.trim(),
          _firstNameController.text.trim(),
          _lastNameController.text.trim(),
          _selectedGender!,
          age,
        );

        final prefs = await SharedPreferences.getInstance();
        if (!prefs.containsKey('hasCompletedTour')) {
          await prefs.setBool('hasCompletedTour', false);
        }
        _showSnackBar('Account created successfully! Please log in.');
        setState(() {
          _isLogin = true; // Switch to login mode after successful sign-up
          // Clear all fields after successful sign-up
          _emailController.clear();
          _passwordController.clear();
          _confirmPasswordController.clear();
          _firstNameController.clear();
          _lastNameController.clear();
          _ageController.clear();
          _selectedGender = null;
        });
      }
    } on FirebaseAuthException catch (e) {
      String message = 'An error occurred, please check your credentials!';
      if (e.message != null) {
        message = e.message!;
      }
      setState(() {
        _errorMessage = message;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'An unexpected error occurred.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleGoogleSignIn() async {
    _clearError();
    setState(() {
      _isLoading = true;
    });

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _showSnackBar('Google Sign-In cancelled.');
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        final prefs = await SharedPreferences.getInstance();
        if (!prefs.containsKey('hasCompletedTour')) {
          await prefs.setBool('hasCompletedTour', false);
        }
        // No direct navigation here. main.dart's StreamBuilder handles it.
      } else {
        setState(() {
          _errorMessage = 'Google Sign-In failed: No user found.';
        });
      }
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Error: ${e.code} - ${e.message}');
      String errorMessage = 'Sign-In Error: ${e.message ?? 'Unknown error'}';
      if (e.code == 'account-exists-with-different-credential') {
        errorMessage = 'An account already exists with the same email address but different sign-in credentials. Please try signing in with another method or linking the accounts.';
      } else if (e.code == 'network-request-failed') {
        errorMessage = 'Network error. Please check your internet connection.';
      }
      setState(() {
        _errorMessage = errorMessage;
      });
    } catch (e) {
      print('Google Sign-In Error: $e');
      setState(() {
        _errorMessage = 'An unexpected error occurred.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // CRITICAL CHANGE: _signInAsGuest now signs in anonymously with Firebase
  Future<void> _signInAsGuest() async {
    _clearError();
    setState(() {
      _isLoading = true;
    });
    try {
      // Perform anonymous sign-in with Firebase Authentication
      await _auth.signInAnonymously(); // THIS IS THE KEY CHANGE

      // The 'isGuest' SharedPreferences flag is no longer strictly needed
      // because Firebase Authentication will now track the anonymous user.
      // You can keep it if you have other app logic that specifically relies
      // on this flag, but for basic authentication, it's redundant.

      final prefs = await SharedPreferences.getInstance();
      if (!prefs.containsKey('hasCompletedTour')) {
        await prefs.setBool('hasCompletedTour', false);
      }
      // No direct navigation here. main.dart will now pick this up
      // because Firebase Auth state will change (user is now anonymously logged in).
    } on FirebaseAuthException catch (e) {
      String message = 'Failed to sign in as guest.';
      if (e.code == 'operation-not-allowed') {
        message = 'Anonymous sign-in is not enabled for your Firebase project. Please enable it in Firebase Console.';
      } else if (e.message != null) {
        message = e.message!;
      }
      setState(() {
        _errorMessage = message;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to sign in as guest: $e';
      });
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
          _isLogin ? 'Login' : 'Sign Up',
          style: theme.textTheme.titleLarge?.copyWith(color: colorScheme.onPrimary),
        ),
        backgroundColor: colorScheme.primary,
        iconTheme: IconThemeData(color: colorScheme.onPrimary),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Kokoro',
                style: theme.textTheme.displayLarge?.copyWith(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSecondary,
                ),
              ),
              const SizedBox(height: 40),

              // --- NEW: First Name, Last Name, Gender, Age fields for Sign Up ---
              if (!_isLogin) ...[
                TextField(
                  controller: _firstNameController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    labelText: 'First Name',
                    hintText: 'Enter your first name',
                    labelStyle: theme.textTheme.headlineSmall,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: Icon(Icons.person, color: colorScheme.secondary),
                  ),
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _lastNameController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    labelText: 'Last Name',
                    hintText: 'Enter your last name',
                    labelStyle: theme.textTheme.headlineSmall,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: Icon(Icons.person_outline, color: colorScheme.secondary),
                  ),
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                // Gender Selection
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
                            title: Text('Male', style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSecondary)),
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
                            title: Text('Female', style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSecondary)),
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
                    hintText: 'Enter your age',
                    labelStyle: theme.textTheme.headlineSmall,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: Icon(Icons.cake, color: colorScheme.secondary), // Cake icon for age
                  ),
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
              ], // End of new fields for sign-up

              // Email Field
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  labelStyle: theme.textTheme.headlineSmall,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: Icon(Icons.email, color: colorScheme.secondary),
                ),
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              // Password Field
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: theme.textTheme.headlineSmall,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: Icon(Icons.lock, color: colorScheme.secondary),
                ),
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 16), // Adjusted spacing

              // Confirm Password Field (only for Sign Up mode)
              if (!_isLogin) ...[
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    hintText: 'Re-enter your password',
                    labelStyle: theme.textTheme.headlineSmall,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: Icon(Icons.lock_reset, color: colorScheme.secondary),
                  ),
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 24), // Spacing after confirm password
              ] else ...[
                const SizedBox(height: 24), // Maintain spacing if not in sign-up mode
              ],

              // Error Message
              if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.error),
                  textAlign: TextAlign.center,
                ),
              if (_errorMessage != null) const SizedBox(height: 16),

              // Login/Signup Button
              _isLoading
                  ? CircularProgressIndicator(color: colorScheme.secondary)
                  : SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitAuthForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.secondary,
                    foregroundColor: colorScheme.onSecondary,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: Text(
                    _isLogin ? 'Login' : 'Sign Up',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _isLoading
                  ? const SizedBox.shrink()
                  : SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _handleGoogleSignIn,
                  icon: Image.asset(
                    'assets/google logo.png', // Corrected asset path
                    height: 24,
                  ),
                  label: Text(
                    'Sign in with Google',
                    style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 18,
                        color: colorScheme.onPrimary
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: colorScheme.onPrimary.withOpacity(0.2)),
                    ),
                    elevation: 3,
                  ),
                ),
              ),

              // Toggle Login/Signup
              TextButton(
                onPressed: () {
                  setState(() {
                    _isLogin = !_isLogin;
                    // Clear all fields when toggling mode
                    _emailController.clear();
                    _passwordController.clear();
                    _confirmPasswordController.clear(); // Clear confirm password
                    _firstNameController.clear();
                    _lastNameController.clear();
                    _ageController.clear();
                    _selectedGender = null; // Clear gender selection
                    _clearError(); // Clear error on toggle
                  });
                },
                style: TextButton.styleFrom(
                  foregroundColor: colorScheme.primary,
                ),
                child: Text(
                  _isLogin ? 'Create an account' : 'I already have an account',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    decoration: TextDecoration.underline,
                    decorationColor: colorScheme.tertiary,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              Text(
                'OR',
                style: theme.textTheme.bodyLarge?.copyWith(color: colorScheme.onSecondary),
              ),
              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _isLoading ? null : _signInAsGuest,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colorScheme.primary,
                    side: BorderSide(color: colorScheme.primary, width: 2),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: Text(
                    'Continue as Guest',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSecondary,
                      decoration: TextDecoration.underline,
                      decorationColor: colorScheme.tertiary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}