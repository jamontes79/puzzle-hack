import 'package:puzzle/core/domain/failures.dart';

class NotLoggedUserFailure extends Failure {
  const NotLoggedUserFailure();
  @override
  List<Object?> get props => [];
}

class LoginFailure extends Failure {
  const LoginFailure(this.code);
  final String code;

  @override
  List<Object?> get props => [code];
}
