part of 'register_bloc.dart';

class RegisterState extends Equatable {
  const RegisterState({
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.validating,
    required this.errorEmail,
    required this.errorPassword,
    required this.errorConfirmPassword,
    required this.successful,
    required this.error,
  });

  final Email email;
  final Password password;
  final Password confirmPassword;
  final bool validating;
  final bool errorEmail;
  final bool errorPassword;
  final bool errorConfirmPassword;
  final bool successful;
  final bool error;

  RegisterState copyWith({
    Email? email,
    Password? password,
    Password? confirmPassword,
    bool? validating,
    bool? errorEmail,
    bool? errorPassword,
    bool? errorConfirmPassword,
    bool? successful,
    bool? error,
  }) {
    return RegisterState(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      validating: validating ?? this.validating,
      errorEmail: errorEmail ?? this.errorEmail,
      errorPassword: errorPassword ?? this.errorPassword,
      errorConfirmPassword: errorConfirmPassword ?? this.errorConfirmPassword,
      successful: successful ?? this.successful,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        email,
        password,
        confirmPassword,
        validating,
        errorEmail,
        errorPassword,
        errorConfirmPassword,
        successful,
        error,
      ];
}
