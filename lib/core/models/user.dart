import 'package:equatable/equatable.dart';
import 'package:tutorly/core/core.dart';

enum UserRole { tutor, student, unknown }

class User extends Equatable {
  final String email;
  final String name;
  final String? imageUrl;
  final String? coverUrl;
  final UserRole role;
  final Schedule? schedule;
  final bool isAdmin;

  const User({
    required this.email,
    required this.name,
    this.imageUrl,
    this.coverUrl,
    this.role = UserRole.unknown,
    this.isAdmin = false,
    this.schedule,
  });

  /// Create an empty user instance for initialization.

  static const empty = User(email: '', name: '');

  bool get isEmpty => this == User.empty;
  bool get isNotEmpty => this != User.empty;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'imageUrl': imageUrl,
      'coverUrl': coverUrl,
      'role': role.toString().split('.').last,
      'isAdmin': isAdmin,
      'schedule': schedule?.toJson(),
    };
  }

  factory User.fromJson(Map<String, dynamic> map) {
    return User(
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      coverUrl: map['coverUrl'] ?? '',
      role:
          map['role'] == 'tutor'
              ? UserRole.tutor
              : map['role'] == 'student'
              ? UserRole.student
              : UserRole.unknown,
      schedule: Schedule.fromJson(map['schedule'] ?? {}),
      isAdmin: map['isAdmin'] ?? false,
    );
  }

  User copyWith({
    String? email,
    String? name,
    String? imageUrl,
    String? coverUrl,
    UserRole? role,
    bool? isAdmin,
    Schedule? schedule,
  }) {
    return User(
      email: email ?? this.email,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      coverUrl: coverUrl ?? this.coverUrl,
      role: role ?? this.role,
      isAdmin: isAdmin ?? this.isAdmin,
      schedule: schedule ?? this.schedule,
    );
  }

  @override
  List<Object?> get props => [
    email,
    name,
    imageUrl,
    coverUrl,
    role,
    isAdmin,
    schedule,
  ];
}
