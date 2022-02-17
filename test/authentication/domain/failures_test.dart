import 'package:flutter_test/flutter_test.dart';
import 'package:puzzle/authentication/domain/failures/failures.dart';

void main() {
  test('NotLoggedUserFailure', () {
    const failure = NotLoggedUserFailure();
    expect(
      failure.props,
      <Object?>[],
    );
  });

  test('LoginFailure', () {
    const failure = LoginFailure('code');
    expect(
      failure.props,
      ['code'],
    );
  });

  test('RegisterFailure', () {
    const failure = RegisterFailure('code');
    expect(
      failure.props,
      ['code'],
    );
  });
}
