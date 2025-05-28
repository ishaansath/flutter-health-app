// lib/data/auth_firebase_data.dart (UPDATED FOR FIRESTORE)

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // NEW: Import Cloud Firestore

// (Optional) If you have custom exceptions, keep this import:
// import 'package:ishaan/core/error/exceptions.dart';

// Abstract interface to define the contract for authentication operations
abstract interface class AuthFirebaseDataSource {
  Future<String?> googleSignIn();
  Future<String?> logout();
  Future<String?> signUpWithEmailAndPassword(String email, String password, String firstName, String lastName, String gender); // NEW: Added name and gender
  Future<String?> signInWithEmailAndPassword(String email, String password);
}

// Implementation of the authentication service
class AuthFirebaseDataSourceImpl implements AuthFirebaseDataSource {
  final GoogleSignIn _googleSignIn = GoogleSignIn( scopes: <String>['email'], );
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const String _userUidKey = 'user_uid';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // NEW: Firestore instance

  // --- NEW: Helper method to save user data to Firestore ---
  Future<void> _saveUserDataToFirestore(User user, String firstName, String lastName, String gender) async {
    try {
      print('Attempting to save user data for UID: ${user.uid}'); // ADD THIS
      await _firestore.collection('users').doc(user.uid).set({
        'firstName': firstName,
        'lastName': lastName,
        'email': user.email,
        'gender': gender,
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      print('User data saved to Firestore for UID: ${user.uid}'); // THIS ALREADY EXISTS
    } catch (e) {
      print('CRITICAL ERROR: Failed to save user data to Firestore for UID ${user.uid}: $e'); // MAKE THIS MORE PROMINENT
      // CONSIDER re-throwing or notifying user
    }
  }


  // --- Existing Google Sign-In Method ---
  @override
  Future<String?> googleSignIn() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount == null) {
        print('Google Sign-In cancelled by user.');
        return null;
      }
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        print('Successfully signed in with Google: ${user.displayName} (UID: ${user.uid})');
        await _storage.write(key: _userUidKey, value: user.uid);

        // For Google Sign-In, we might not have first/last/gender directly.
        // You might prompt the user for this info after their first sign-in,
        // or extract from displayName if consistent (e.g., first last).
        // For simplicity, we'll just set an empty string or 'Not Specified' for now.
        // Or you can check if a document exists and update if not.
        // A more robust approach might be to use a separate flow for initial profile setup.
        // For now, we'll just attempt to save with placeholder info if not exists.
        final userDoc = await _firestore.collection('users').doc(user.uid).get();
        if (!userDoc.exists) {
          // Attempt to split display name for first/last, or use default
          final displayNameParts = user.displayName?.split(' ') ?? ['Google User'];
          final firstName = displayNameParts.isNotEmpty ? displayNameParts[0] : 'Google User';
          final lastName = displayNameParts.length > 1 ? displayNameParts.sublist(1).join(' ') : '';
          await _saveUserDataToFirestore(user, firstName, lastName, 'Not Specified');
        }


        return user.uid;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Error during Google Sign-In: ${e.code} - ${e.message}');
      return null;
    } catch (e) {
      print('General Error during Google Sign-In: $e');
      return null;
    }
  }

  @override
  Future<String?> logout() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      await _storage.delete(key: _userUidKey);
      print('User successfully logged out.');
      return 'Logged out';
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Error during logout: ${e.code} - ${e.message}');
      return 'Logout failed due to Firebase error: ${e.message}';
    } catch (e) {
      print('General Error during logout: $e');
      return 'Logout failed: $e';
    }
  }

  // --- MODIFIED: Email/Password Sign Up to save additional data ---
  @override
  Future<String?> signUpWithEmailAndPassword(String email, String password, String firstName, String lastName, String gender) async {
    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User? user = userCredential.user;
      if (user != null) {
        print('Successfully signed up with Email: ${user.email} (UID: ${user.uid})');

        // NEW: Save additional user data to Firestore
        await _saveUserDataToFirestore(user, firstName, lastName, gender);

        // Optionally, update Firebase user display name
        await user.updateDisplayName('$firstName $lastName');
        // Reload user to ensure display name is updated immediately
        await user.reload();


        await _storage.write(key: _userUidKey, value: user.uid);
        return user.uid;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Error during Email Sign-Up: ${e.code} - ${e.message}');
      if (e.code == 'weak-password') {
        throw FirebaseAuthException(code: e.code, message: 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw FirebaseAuthException(code: e.code, message: 'An account already exists with that email.');
      }
      throw FirebaseAuthException(code: e.code, message: e.message);
    } catch (e) {
      print('General Error during Email Sign-Up: $e');
      throw Exception('An unexpected error occurred during sign-up.');
    }
  }

  // --- Existing Email/Password Sign In ---
  @override
  Future<String?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User? user = userCredential.user;
      if (user != null) {
        print('Successfully signed in with Email: ${user.email} (UID: ${user.uid})');
        await _storage.write(key: _userUidKey, value: user.uid);
        return user.uid;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Error during Email Sign-In: ${e.code} - ${e.message}');
      if (e.code == 'user-not-found') {
        throw FirebaseAuthException(code: e.code, message: 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw FirebaseAuthException(code: e.code, message: 'Wrong password provided for that user.');
      } else if (e.code == 'invalid-credential') {
        throw FirebaseAuthException(code: e.code, message: 'Invalid email or password.');
      }
      throw FirebaseAuthException(code: e.code, message: e.message);
    } catch (e) {
      print('General Error during Email Sign-In: $e');
      throw Exception('An unexpected error occurred during sign-in.');
    }
  }

  Future<String?> getStoredUserUid() async {
    return await _storage.read(key: _userUidKey);
  }
}