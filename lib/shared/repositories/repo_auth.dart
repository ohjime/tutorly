// authentication_repository.dart

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart' show kIsWeb;
import '../exports.dart';

class AuthenticationRepository {
  final AuthProvider _firebaseAuthClient;

  /// Whether or not the current environment is web.
  bool isWeb = kIsWeb;

  AuthenticationRepository({
    AuthProvider? firebaseAuthClient,
  }) : _firebaseAuthClient = firebaseAuthClient ?? AuthProvider();

  /// Stream of Firebase Users (or null if not signed in).
  Stream<firebase_auth.User?> get user {
    return _firebaseAuthClient.user;
  }

  Future<String?> getuid() async {
    final user =
        await this.user.firstWhere((user) => user != null, orElse: () => null);
    return user?.uid;
  }

  Stream<firebase_auth.User?> get userBroadcast => user.asBroadcastStream();

  /// Signs in with email and password.
  Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuthClient.signInUsingFirebase(
      email: email,
      password: password,
    );
  }

  /// Signs in with email and password.
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuthClient.createFirebaseUserWithEmail(
      email: email,
      password: password,
    );
  }

  /// Signs out the current user.
  Future<void> logOut() async {
    await Future.wait([
      _firebaseAuthClient.logOut(),
    ]);
  }
}
