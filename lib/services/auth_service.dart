import 'dart:developer' as developer;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isInitialized = false;

  Future<void> _ensureGoogleSignInInitialized() async {
    if (_isInitialized) {
      return;
    }
    try {
      await _googleSignIn.initialize();
      _isInitialized = true;
    } catch (e, st) {
      developer.log(
        'Google Sign-In initialization error',
        name: 'AuthService',
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  /// Register with email and store user profile in Firestore
  Future<User?> registerWithEmail({
    required String email,
    required String password,
    required String fullName,
    required String role, // 'patient' or 'doctor'
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = result.user;
      if (user != null) {
        // Store user profile in Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': email,
          'fullName': fullName,
          'role': role,
          'createdAt': FieldValue.serverTimestamp(),
          'lastLogin': FieldValue.serverTimestamp(),
          ...?additionalData,
        });
      }
      return user;
    } on FirebaseAuthException catch (e, st) {
      developer.log(
        'Email registration error: ${e.code}',
        name: 'AuthService',
        error: e,
        stackTrace: st,
      );
      return null;
    } catch (e, st) {
      developer.log(
        'Unexpected registration error',
        name: 'AuthService',
        error: e,
        stackTrace: st,
      );
      return null;
    }
  }

  /// Sign in with Email and Password
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = result.user;
      if (user != null) {
        final DocumentReference<Map<String, dynamic>> ref =
            _firestore.collection('users').doc(user.uid);
        final DocumentSnapshot<Map<String, dynamic>> doc = await ref.get();
        if (doc.exists) {
          await ref.update({'lastLogin': FieldValue.serverTimestamp()});
        }
      }
      return user;
    } on FirebaseAuthException catch (e, st) {
      developer.log(
        'Email sign-in error: ${e.code}',
        name: 'AuthService',
        error: e,
        stackTrace: st,
      );
      rethrow;
    } catch (e, st) {
      developer.log(
        'Unexpected email sign-in error',
        name: 'AuthService',
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  /// Sign in with Google and store/update profile in Firestore
  Future<User?> signInWithGoogle({
    String? role,
  }) async {
    try {
      await _ensureGoogleSignInInitialized();

      final GoogleSignInAccount? googleUser = await _googleSignIn.authenticate();
      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      if (googleAuth.idToken == null) {
        throw FirebaseAuthException(
          code: 'missing-id-token',
          message: 'Google Sign-In did not return an idToken.',
        );
      }

      final OAuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final UserCredential result = await _auth.signInWithCredential(credential);
      final user = result.user;
      if (user == null) {
        throw FirebaseAuthException(
          code: 'null-user',
          message: 'Firebase Sign-In returned no user.',
        );
      }

      final DocumentReference<Map<String, dynamic>> ref =
          _firestore.collection('users').doc(user.uid);
      final DocumentSnapshot<Map<String, dynamic>> userDoc = await ref.get();

      if (!userDoc.exists) {
        await ref.set({
          'uid': user.uid,
          'email': user.email,
          'fullName': user.displayName ?? 'User',
          'photoUrl': user.photoURL,
          'role': role ?? 'patient',
          'createdAt': FieldValue.serverTimestamp(),
          'lastLogin': FieldValue.serverTimestamp(),
        });
      } else {
        await ref.update({'lastLogin': FieldValue.serverTimestamp()});
      }

      return user;
    } on FirebaseAuthException catch (e, st) {
      developer.log(
        'Google sign-in Firebase error: ${e.code}',
        name: 'AuthService',
        error: e,
        stackTrace: st,
      );
      rethrow;
    } catch (e, st) {
      developer.log(
        'Unexpected Google sign-in error',
        name: 'AuthService',
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  /// Get user profile from Firestore
  Future<DocumentSnapshot?> getUserProfile(String uid) async {
    try {
      return await _firestore.collection('users').doc(uid).get();
    } catch (e, st) {
      developer.log(
        'Error fetching user profile',
        name: 'AuthService',
        error: e,
        stackTrace: st,
      );
      return null;
    }
  }

  /// Sign Out
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      developer.log('Google sign-out error', name: 'AuthService', error: e);
    }
    await _auth.signOut();
  }
}
