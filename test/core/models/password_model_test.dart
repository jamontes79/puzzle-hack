import 'package:flutter_test/flutter_test.dart';
import 'package:puzzle/core/domain/models/password_model.dart';

void main() {
  test('Empty password throws Exception', () {
    expect(
      () => Password(''),
      throwsA(
        predicate(
          (e) =>
              e is Exception && e.toString() == 'Exception: Password not valid',
        ),
      ),
    );
  });
  test('Empty password constructor is empty', () {
    const email = Password.empty();
    expect(
      email.value,
      '',
    );
  });
  test('Password not valid throws Exception', () {
    expect(
      () => Password('test'),
      throwsA(
        predicate(
          (e) =>
              e is Exception && e.toString() == 'Exception: Password not valid',
        ),
      ),
    );
  });

  test('Password valid get valid value', () {
    const validPassword = 'Aa12345678@';
    final password = Password(validPassword);
    expect(
      password.value,
      validPassword,
    );
  });

  test('Password valid is equatable', () {
    const validPassword = 'Aa12345678@';
    final password = Password(validPassword);
    expect(
      password.props,
      [validPassword],
    );
  });
}
