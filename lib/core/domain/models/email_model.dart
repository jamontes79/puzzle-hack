import 'package:equatable/equatable.dart';

class Email extends Equatable {
  Email(this._email) {
    if (!_verifyEmailAddress(_email)) {
      throw Exception('Email not valid');
    }
  }

  const Email.empty() : _email = '';
  final String _email;
  String get value => _email;

  bool _verifyEmailAddress(String email) {
    const emailRegex =
        r"""^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+""";
    return RegExp(emailRegex).hasMatch(email);
  }

  @override
  List<Object?> get props => [_email];
}
