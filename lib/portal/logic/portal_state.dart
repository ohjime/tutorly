part of 'portal_cubit.dart';

enum PortalStatus { intial, requesting, success, error }

enum PortalMode { login, signup }

@immutable
class PortalState extends Equatable {
  final PortalMode mode;
  final PortalStatus status;
  final String message;
  final bool obscurePassword;

  const PortalState({
    required this.mode,
    required this.status,
    required this.message,
    this.obscurePassword = true,
  });

  const PortalState.initial()
      : this(
            mode: PortalMode.login,
            status: PortalStatus.intial,
            message: '',
            obscurePassword: true);

  PortalState reset() {
    return PortalState(
      mode: mode,
      status: PortalStatus.intial,
      message: "",
      obscurePassword: true,
    );
  }

  PortalState requesting() {
    return PortalState(
      mode: mode,
      status: PortalStatus.requesting,
      message: "",
      obscurePassword: true,
    );
  }

  PortalState error({required String error}) {
    return PortalState(
      mode: mode,
      status: PortalStatus.error,
      message: error,
      obscurePassword: true,
    );
  }

  PortalState success() {
    return PortalState(
      mode: mode,
      status: PortalStatus.success,
      message: "",
      obscurePassword: true,
    );
  }

  PortalState copyWith({
    PortalMode? mode,
    PortalStatus? status,
    String? message,
    bool? obscurePassword,
  }) {
    return PortalState(
      mode: mode ?? this.mode,
      status: status ?? this.status,
      message: message ?? this.message,
      obscurePassword: obscurePassword ?? this.obscurePassword,
    );
  }

  @override
  List<Object> get props => [status, message, obscurePassword, mode];
}
