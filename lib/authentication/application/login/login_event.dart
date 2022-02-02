part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class EmailChanged extends LoginEvent {
  const EmailChanged(this.email);

  final String email;

  @override
  List<Object?> get props => [email];
}

class PasswordChanged extends LoginEvent {
  const PasswordChanged(this.password);

  final String password;

  @override
  List<Object?> get props => [password];
}

class AttemptLogin extends LoginEvent {
  const AttemptLogin();

  @override
  List<Object?> get props => [];
}

class AttemptLoginWithGoogle extends LoginEvent {
  const AttemptLoginWithGoogle();

  @override
  List<Object?> get props => [];
}
