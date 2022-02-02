part of 'login_bloc.dart';

class LoginState extends Equatable {
  const LoginState({
    this.email = '',
    this.password = '',
    this.validating = false,
    this.error = false,
    this.successful = false,
  });
  final String email;
  final String password;
  final bool validating;
  final bool error;
  final bool successful;

  LoginState copyWith({
    String? email,
    String? password,
    bool? validating,
    bool? error,
    bool? successful,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      validating: validating ?? this.validating,
      error: error ?? this.error,
      successful: successful ?? this.successful,
    );
  }

  @override
  List<Object?> get props => [
        email,
        password,
        validating,
        error,
        successful,
      ];
}
