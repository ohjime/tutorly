import 'package:equatable/equatable.dart';

class TutorlyUser extends Equatable {
  /// {@macro user}
  const TutorlyUser({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.imageUrl,
    required this.coverUrl,
    required this.lastSeen,
    required this.metaData,
    required this.createdAt,
    required this.updatedAt,
  });

  /// The current user's firebase uid.
  final String id;

  /// The current user's email address.
  final String email;

  /// The current user's first name
  final String firstName;

  /// The current user's first name
  final String lastName;

  /// Url for the current user's profile photo.
  final String? imageUrl;

  /// Url for the current user's cover photo.
  final String? coverUrl;

  /// The last time the user was seen.
  final DateTime? lastSeen;

  /// The user's metadata.
  final String? metaData;

  // The time the user was created.
  final DateTime? createdAt;

  /// The time the user was last updated.
  final DateTime? updatedAt;

  factory TutorlyUser.fromJson(Map<String, dynamic> json) {
    return TutorlyUser(
      id: json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      imageUrl: json['imageUrl'] as String?,
      coverUrl: json['coverUrl'] as String?,
      lastSeen: json['lastSeen'] as DateTime?,
      metaData: json['metaData'] as String?,
      createdAt: json['createdAt'] as DateTime?,
      updatedAt: json['updatedAt'] as DateTime?,
    );
  }

  /// Converts this [TutorlyUser] to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'imageUrl': imageUrl,
      'coverUrl': coverUrl,
    };
  }

  @override
  List<Object?> get props => [
    id,
    email,
    firstName,
    lastName,
    imageUrl,
    coverUrl,
    lastSeen,
    metaData,
    createdAt,
    updatedAt,
  ];
}
