enum AppMode { admin, user }

extension AppModeExtension on AppMode {
  bool get isAdmin => this == AppMode.admin;
  bool get isUser => this == AppMode.user;

  String get displayName {
    switch (this) {
      case AppMode.admin:
        return 'Admin Mode';
      case AppMode.user:
        return 'User Mode';
    }
  }
}
