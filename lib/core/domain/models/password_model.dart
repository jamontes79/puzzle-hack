import 'package:equatable/equatable.dart';

class Password extends Equatable {
  Password(this._password) {
    if (!_verifyPassword(_password)) {
      throw Exception('Password not valid');
    }
  }

  const Password.empty() : _password = '';

  final String _password;

  String get value => _password;

  bool _verifyPassword(String password) {
    const emailRegex =
        r'''^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$''';
    return RegExp(emailRegex).hasMatch(password);
  }

  @override
  List<Object?> get props => [_password];
}
