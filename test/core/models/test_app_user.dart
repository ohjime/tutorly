// import 'package:equatable/equatable.dart';

// enum UserRole { tutor, student, none }

// class AppUser extends Equatable {
//   final String id;
//   final String email;
//   final UserRole role;
//   final bool isAdmin;

//   const AppUser({
//     required this.id,
//     required this.email,
//     this.role = UserRole.none,
//     this.isAdmin = false,
//   });

//   static const empty = AppUser(id: '', email: '');

//   bool get isEmpty => this == AppUser.empty;
//   bool get isNotEmpty => this != AppUser.empty;

//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'email': email,
//       'role': role.toString().split('.').last,
//       'isAdmin': isAdmin,
//     };
//   }

//   factory AppUser.fromMap(Map<String, dynamic> map) {
//     return AppUser(
//       id: map['id'] ?? '',
//       email: map['email'],
//       role: _mapStringToUserRole(map['role'] ?? 'none'),
//       isAdmin: map['isAdmin'] ?? false,
//     );
//   }

//   static UserRole _mapStringToUserRole(String roleStr) {
//     switch (roleStr) {
//       case 'tutor':
//         return UserRole.tutor;
//       case 'student':
//         return UserRole.student;
//       default:
//         return UserRole.none;
//     }
//   }

//   @override
//   List<Object?> get props => [id, email, role, isAdmin];
// }
