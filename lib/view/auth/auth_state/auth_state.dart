import '../model/user_model.dart';

sealed class AuthState {}

class Initial extends AuthState {}

class Loading extends AuthState {}

class PasswordReset extends AuthState {}

class VerifyingOtp extends AuthState {}

class OtpVerified extends AuthState {
  final User user;

  OtpVerified({required this.user});
}

class Verified extends AuthState {
  final User user;

  Verified({required this.user});
}

class UserUpdated extends AuthState {
  final User user;

  UserUpdated({required this.user});
}

class SignUpVerified extends AuthState {
  final User user;
  SignUpVerified({required this.user});
}

class LogoutLoading extends AuthState {}

class Logout extends AuthState {
  final String message;

  Logout({required this.message});
}

class Deleted extends AuthState {}

class Error extends AuthState {
  final Object? error;

  Error({required this.error});
}
