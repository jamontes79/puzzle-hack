part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();
}

class EmailChanged extends RegisterEvent {
  const EmailChanged(this.email);

  final String email;

  @override
  List<Object?> get props => [email];
}

class PasswordChanged extends RegisterEvent {
  const PasswordChanged({
    required this.password,
    required this.confirmPassword,
  });

  final String password;
  final String confirmPassword;

  @override
  List<Object?> get props => [password];
}

class ConfirmPasswordChanged extends RegisterEvent {
  const ConfirmPasswordChanged({
    required this.password,
    required this.confirmPassword,
  });

  final String password;
  final String confirmPassword;

  @override
  List<Object?> get props => [password];
}

class AttemptRegister extends RegisterEvent {
  const AttemptRegister();

  @override
  List<Object?> get props => [];
}
