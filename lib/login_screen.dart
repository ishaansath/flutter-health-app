// lib/login_screen.dart (MODIFIED to include Google Sign-In again)

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart'; // <--- RE-ADD: Import Google Sign-In
import 'package:ishaan/help_page.dart'; // Import HelpPage for navigation
import 'package:shared_preferences/shared_preferences.dart'; // To set guest status
import 'package:ishaan/body_screen.dart'; // Assuming BodyScreen is in lib/

// Assuming your custom button colors extension is defined elsewhere or in main.dart
// extension CustomButtonColors on ColorScheme { ... }

class LoginScreen extends StatefulWidget {
  final ValueNotifier<ThemeMode> themeModeNotifier;

  const LoginScreen({super.key, required this.themeModeNotifier});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GoogleSignIn _googleSignIn = GoogleSignIn(); // <--- RE-ADD: GoogleSignIn instance
  bool _isLogin = true; // To toggle between login and signup
  bool _isLoading = false; // To show loading state
  // String? _errorMessage; // Removed, using _showSnackBar directly

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Helper to show snackbar messages
  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  // --- Existing Email/Password Submit Form ---
  Future<void> _submitAuthForm() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (_isLogin) {
        await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        // StreamBuilder in main.dart will handle navigation on successful login
      } else {
        await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        // For new user, set hasCompletedTour to false to show the tour
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('hasCompletedTour', false);
        _showSnackBar('Account created successfully! Please log in.');
        setState(() {
          _isLogin = true; // Switch to login mode after successful sign-up
        });
      }
    } on FirebaseAuthException catch (e) {
      String message = 'An error occurred, please check your credentials!';
      if (e.message != null) {
        message = e.message!;
      }
      _showSnackBar(message); // Show specific Firebase Auth error
    } catch (e) {
      _showSnackBar('An unexpected error occurred.'); // Show general error
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // --- RE-ADD: Google Sign-In Function ---
  Future<void> _handleGoogleSignIn() async {
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

      await _auth.signInWithCredential(credential);
      // If we reach here, signInWithCredential was successful.
      // The StreamBuilder in main.dart will handle navigation.
      // So, we do NOT show a success snackbar here.
      // We only show error snackbars if an exception is caught.

    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Error: ${e.code} - ${e.message}');
      String errorMessage = 'Sign-In Error: ${e.message ?? 'Unknown error'}';
      if (e.code == 'account-exists-with-different-credential') {
        errorMessage = 'An account already exists with the same email address but different sign-in credentials. Please try signing in with another method or linking the accounts.';
      } else if (e.code == 'network-request-failed') {
        errorMessage = 'Network error. Please check your internet connection.';
      }
      _showSnackBar(errorMessage); // Only show error snackbar
    } catch (e) {
      print('Google Sign-In Error: $e');
      _showSnackBar('An unexpected error occurred. Please try again.'); // Only show error snackbar
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  // --- Existing Guest Login Function ---
  Future<void> _signInAsGuest() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isGuest', true); // Mark as guest in SharedPreferences
      await prefs.setBool('hasCompletedTour', prefs.getBool('hasCompletedTour') ?? false); // Preserve existing tour status

      bool hasCompletedTour = prefs.getBool('hasCompletedTour') ?? false;

      // Navigate directly for guest. Note: This bypasses the main.dart StreamBuilder
      // for authentication state, as guest users are not Firebase authenticated.
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => hasCompletedTour
              ? HelpPage(themeModeNotifier: widget.themeModeNotifier)
              : HelpPage(themeModeNotifier: widget.themeModeNotifier),
        ),
            (Route<dynamic> route) => false,
      );

    } catch (e) {
      _showSnackBar('Failed to sign in as guest: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
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
              // Logo/App Title
              Text(
                'Health App',
                style: theme.textTheme.displayLarge?.copyWith(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSecondary,
                ),
              ),
              const SizedBox(height: 40),
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
              const SizedBox(height: 24),

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
                  ? const SizedBox.shrink() // Hide if loading any auth method
                  : SizedBox(
                width: double.infinity, // Make it full width
                child: ElevatedButton.icon(
                  onPressed: _handleGoogleSignIn,
                  icon: Image.asset(
                    'assets/google logo.png', // Ensure this asset exists
                    height: 24,
                  ),
                  label: Text(
                    'Sign in with Google',
                    style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 18,
                        color: colorScheme.onPrimary // Adjusted for white background
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary, // Typically white/light for Google button
                    foregroundColor: colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // Match other buttons
                      side: BorderSide(color: colorScheme.onPrimary.withOpacity(0.2)), // Light border
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
                    _emailController.clear(); // Clear fields on toggle
                    _passwordController.clear();
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
              const SizedBox(height: 10), // Space before OR

              // --- OR Divider ---
              Text(
                'OR',
                style: theme.textTheme.bodyLarge?.copyWith(color: colorScheme.onSecondary),
              ),
              const SizedBox(height: 10),

              // --- RE-ADD: Google Sign-In Button ---

              // --- Existing "Continue as Guest" Button ---
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

              // Optional: Theme toggle button on login screen
            ],
          ),
        ),
      ),
    );
  }
}