import 'package:equatable/equatable.dart';

/// {@template AuthCredential}
/// AuthCredential model
///
/// [AuthCredential.empty] represents an unauthenticated AuthCredential.
/// {@endtemplate}
class AuthCredential extends Equatable {
  /// {@macro AuthCredential}
  const AuthCredential({required this.id, this.email});

  /// The current AuthCredential's email address.
  final String? email;

  /// The current AuthCredential's id.
  final String id;

  /// Empty AuthCredential which represents an unauthenticated AuthCredential.
  static const empty = AuthCredential(id: '');

  /// Check if the AuthCredential is empty.
  bool get isEmpty => this == empty;

  @override
  List<Object?> get props => [email, id];
}
