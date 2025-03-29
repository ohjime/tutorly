// provider_firebase_auth.dart

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';

class AuthProvider {
  final firebase_auth.FirebaseAuth auth;

  AuthProvider({firebase_auth.FirebaseAuth? instance})
    : auth = instance ?? firebase_auth.FirebaseAuth.instance;

  /// Returns a stream of user data as a raw [Map] with native types,
  /// or null if no user is signed in.
  Stream<firebase_auth.User?> get user {
    return auth.authStateChanges().map((firebaseUser) {
      if (firebaseUser == null) return null;
      return firebaseUser;
    });
  }

  /// Creates a new user with the provided [email] and [password].
  Future<void> createFirebaseUserWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      debugPrint('Error code: ${e.message}');
      throw Exception(_signUpErrorMessage(e.code));
    }
  }

  /// Signs in with the provided [email] and [password].
  Future<void> signInUsingFirebase({
    required String email,
    required String password,
  }) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } on firebase_auth.FirebaseAuthException catch (e) {
      debugPrint('Error code: ${e.message}');
      throw Exception(_logInErrorMessage(e.code));
    }
  }

  /// Signs out the current user.
  Future<void> logOut() async {
    try {
      await auth.signOut();
    } catch (_) {
      throw Exception('An error occurred during log out.');
    }
  }

  String _signUpErrorMessage(String code) {
    switch (code) {
      case 'invalid-email':
        return 'Email is not valid or badly formatted.';
      case 'user-disabled':
        return 'This user has been disabled. Please contact support for help.';
      case 'email-already-in-use':
        return 'An account already exists for that email.';
      case 'operation-not-allowed':
        return 'Operation is not allowed. Please contact support.';
      case 'weak-password':
        return 'Please enter a stronger password.';
      default:
        return 'An unknown error occurred during sign up.';
    }
  }

  String _logInErrorMessage(String code) {
    switch (code) {
      case 'invalid-email':
        return 'Email is not valid or badly formatted.';
      case 'user-disabled':
        return 'This user has been disabled. Please contact support for help.';
      case 'invalid-credential':
        return 'Invalid credentials. Please try again.';
      case 'wrong-password':
        return 'Incorrect password, please try again.';
      default:
        return 'An unknown error occurred during log in.';
    }
  }
}
