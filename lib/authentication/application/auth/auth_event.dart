part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class CheckStatus extends AuthEvent {
  const CheckStatus();
  @override
  List<Object?> get props => [];
}

class Logout extends AuthEvent {
  const Logout();
  @override
  List<Object?> get props => [];
}
