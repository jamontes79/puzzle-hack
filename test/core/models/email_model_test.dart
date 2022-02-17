import 'package:flutter_test/flutter_test.dart';
import 'package:puzzle/core/domain/models/email_model.dart';

void main() {
  test('Empty email throws Exception', () {
    expect(
      () => Email(''),
      throwsA(
        predicate(
          (e) => e is Exception && e.toString() == 'Exception: Email not valid',
        ),
      ),
    );
  });
  test('Empty email constructor is empty', () {
    const email = Email.empty();
    expect(
      email.value,
      '',
    );
  });
  test('Email not valid throws Exception', () {
    expect(
      () => Email('test'),
      throwsA(
        predicate(
          (e) => e is Exception && e.toString() == 'Exception: Email not valid',
        ),
      ),
    );
  });

  test('Email valid get valid value', () {
    const validEmail = 'test1@prueba.net';
    final email = Email(validEmail);
    expect(
      email.value,
      validEmail,
    );
  });

  test('Email valid is equatable', () {
    const validEmail = 'test1@prueba.net';
    final email = Email(validEmail);
    expect(
      email.props,
      [validEmail],
    );
  });
}
