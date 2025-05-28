// lib/data/auth_firebase_data.dart (UPDATED for First Name, Last Name, Gender, Age, and Profile Management)

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Cloud Firestore

// NEW: Define a simple model for user profile data fetched from Firestore
class UserProfile {
  final String uid;
  final String firstName;
  final String lastName;
  final String gender;
  final int? age; // Age can be null if not provided
  final String? email;
  final String? photoURL;
  final String? displayName;

  UserProfile({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.gender,
    this.age,
    this.email,
    this.photoURL,
    this.displayName,
  });

  // Factory constructor to create a UserProfile from a Firestore document
  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?; // Handle null data
    if (data == null) {
      // Handle case where document exists but data is null (unlikely for a doc.exists check)
      return UserProfile(uid: doc.id, firstName: '', lastName: '', gender: 'Not Specified');
    }
    return UserProfile(
      uid: doc.id,
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      gender: data['gender'] ?? 'Not Specified',
      age: data['age'] as int?, // Cast to int?
      email: data['email'] as String?,
      photoURL: data['photoURL'] as String?,
      displayName: data['displayName'] as String?,
    );
  }

  // Method to convert UserProfile to a Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'age': age,
      'email': email,
      'photoURL': photoURL,
      'displayName': displayName,
    };
  }
}


// Abstract interface to define the contract for authentication operations
abstract interface class AuthFirebaseDataSource {
  Future<String?> googleSignIn();
  Future<String?> logout();
  // MODIFIED: Added firstName, lastName, gender, age
  Future<String?> signUpWithEmailAndPassword(String email, String password, String firstName, String lastName, String gender, int? age);
  Future<String?> signInWithEmailAndPassword(String email, String password);
  // NEW: Method to update user profile data in Firestore
  Future<void> updateUserData(String uid, String firstName, String lastName, String gender, int? age);
  // NEW: Method to fetch user profile data from Firestore
  Future<UserProfile?> getUserProfile(String uid);
}

// Implementation of the authentication service
class AuthFirebaseDataSourceImpl implements AuthFirebaseDataSource {
  final GoogleSignIn _googleSignIn = GoogleSignIn( scopes: <String>['email'], );
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const String _userUidKey = 'user_uid';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // MODIFIED: Helper method to save/update user data to Firestore
  // Now accepts all profile fields, and gets user.photoURL and user.displayName
  Future<void> _saveUserDataToFirestore(User user, String firstName, String lastName, String gender, int? age) async {
    try {
      await _firestore.collection('users').doc(user.uid).set({
        'firstName': firstName,
        'lastName': lastName,
        'email': user.email,
        'gender': gender,
        'age': age,
        'createdAt': FieldValue.serverTimestamp(), // Timestamp of creation
        'photoURL': user.photoURL, // Store photoURL from Firebase Auth
        'displayName': user.displayName, // Store display name from Firebase Auth
      }, SetOptions(merge: true)); // Use merge: true to avoid overwriting existing data if user signs up with Google later
      print('User data saved/updated to Firestore for UID: ${user.uid}');
    } catch (e) {
      print('Error saving/updating user data to Firestore: $e');
      // Consider throwing a custom exception or logging to a crashlytics service
      rethrow; // Re-throw to be caught by UI
    }
  }

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

        // For Google Sign-In, we'll try to get first/last from display name
        // and set default for gender/age if not already in Firestore.
        final userDoc = await _firestore.collection('users').doc(user.uid).get();
        if (!userDoc.exists) {
          final displayNameParts = user.displayName?.split(' ') ?? ['Google User'];
          final firstName = displayNameParts.isNotEmpty ? displayNameParts[0] : 'Google User';
          final lastName = displayNameParts.length > 1 ? displayNameParts.sublist(1).join(' ') : '';
          // For Google sign-in, we don't have gender/age, so default them
          await _saveUserDataToFirestore(user, firstName, lastName, 'Not Specified', null);
        } else {
          // If document exists, ensure photoURL and displayName are updated if they changed
          await _firestore.collection('users').doc(user.uid).set({
            'photoURL': user.photoURL,
            'displayName': user.displayName,
          }, SetOptions(merge: true));
        }

        return user.uid;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Error during Google Sign-In: ${e.code} - ${e.message}');
      rethrow; // Re-throw to be caught by UI
    } catch (e) {
      print('General Error during Google Sign-In: $e');
      rethrow; // Re-throw to be caught by UI
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
      rethrow;
    } catch (e) {
      print('General Error during logout: $e');
      rethrow;
    }
  }

  // MODIFIED: Email/Password Sign Up to save additional data
  @override
  Future<String?> signUpWithEmailAndPassword(String email, String password, String firstName, String lastName, String gender, int? age) async {
    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User? user = userCredential.user;
      if (user != null) {
        print('Successfully signed up with Email: ${user.email} (UID: ${user.uid})');

        // NEW: Save additional user data to Firestore
        await _saveUserDataToFirestore(user, firstName, lastName, gender, age);

        // Optionally, update Firebase user display name
        await user.updateDisplayName('$firstName $lastName');
        await user.reload(); // Reload user to ensure display name is updated immediately

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
      rethrow; // Re-throw to be caught by UI
    } catch (e) {
      print('General Error during Email Sign-Up: $e');
      rethrow; // Re-throw to be caught by UI
    }
  }

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
      rethrow; // Re-throw to be caught by UI
    } catch (e) {
      print('General Error during Email Sign-In: $e');
      rethrow; // Re-throw to be caught by UI
    }
  }

  // NEW: Implementation for updating user profile data in Firestore
  @override
  Future<void> updateUserData(String uid, String firstName, String lastName, String gender, int? age) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'firstName': firstName,
        'lastName': lastName,
        'gender': gender,
        'age': age,
        'updatedAt': FieldValue.serverTimestamp(), // Track last update
      }, SetOptions(merge: true)); // Use merge: true to only update specified fields
      print('User data updated in Firestore for UID: $uid');

      // Also update Firebase Auth display name if it's an email/password user
      final user = _auth.currentUser;
      if (user != null && (user.providerData.isEmpty || user.providerData.any((info) => info.providerId == 'password'))) {
        await user.updateDisplayName('$firstName $lastName');
        await user.reload(); // Reload user to ensure display name is updated immediately
      }

    } catch (e) {
      print('Error updating user data in Firestore: $e');
      rethrow; // Re-throw to be caught by UI
    }
  }

  // NEW: Implementation to fetch user profile data from Firestore
  @override
  Future<UserProfile?> getUserProfile(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserProfile.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Error fetching user profile from Firestore for UID $uid: $e');
      rethrow; // Re-throw to be caught by UI
    }
  }

  Future<String?> getStoredUserUid() async {
    return await _storage.read(key: _userUidKey);
  }
}