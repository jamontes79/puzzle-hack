part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();
}

class Unauthenticated extends AuthState {
  const Unauthenticated();
  @override
  List<Object> get props => [];
}

class Authenticated extends AuthState {
  const Authenticated();
  @override
  List<Object> get props => [];
}
