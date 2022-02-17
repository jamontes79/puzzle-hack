import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:puzzle/authentication/application/register/register_bloc.dart';
import 'package:puzzle/authentication/domain/failures/failures.dart';
import 'package:puzzle/authentication/domain/usecases/i_register.dart';
import 'package:puzzle/core/domain/models/email_model.dart';
import 'package:puzzle/core/domain/models/password_model.dart';

class MockRegister extends Mock implements IRegister {}

void main() {
  group('Register Bloc', () {
    late RegisterBloc bloc;
    late IRegister registerMock;

    setUp(() {
      registerMock = MockRegister();
      bloc = RegisterBloc(registerMock);
    });
    test('Initial state is correct', () {
      expect(
        bloc.state,
        const RegisterState(
          email: Email.empty(),
          password: Password.empty(),
          confirmPassword: Password.empty(),
          validating: false,
          errorEmail: false,
          errorPassword: false,
          errorConfirmPassword: false,
          successful: false,
          error: false,
        ),
      );
    });
    blocTest<RegisterBloc, RegisterState>(
      'Invalid email emits errorEmail state',
      build: () {
        return bloc;
      },
      act: (bloc) => bloc.add(
        const EmailChanged('not_valid'),
      ),
      expect: () => [
        const RegisterState(
          email: Email.empty(),
          password: Password.empty(),
          confirmPassword: Password.empty(),
          validating: false,
          errorEmail: true,
          errorPassword: false,
          errorConfirmPassword: false,
          successful: false,
          error: false,
        ),
      ],
    );
    blocTest<RegisterBloc, RegisterState>(
      'Valid email emits non error state',
      build: () {
        return bloc;
      },
      act: (bloc) => bloc.add(
        const EmailChanged('test@test.com'),
      ),
      expect: () => [
        RegisterState(
          email: Email('test@test.com'),
          password: const Password.empty(),
          confirmPassword: const Password.empty(),
          validating: false,
          errorEmail: false,
          errorPassword: false,
          errorConfirmPassword: false,
          successful: false,
          error: false,
        ),
      ],
    );
    blocTest<RegisterBloc, RegisterState>(
      'Invalid password with empty confirm password emits errorPassword state',
      build: () {
        return bloc;
      },
      act: (bloc) => bloc.add(
        const PasswordChanged(password: 'not_valid', confirmPassword: ''),
      ),
      expect: () => [
        const RegisterState(
          email: Email.empty(),
          password: Password.empty(),
          confirmPassword: Password.empty(),
          validating: false,
          errorEmail: false,
          errorPassword: true,
          errorConfirmPassword: false,
          successful: false,
          error: false,
        ),
      ],
    );
    blocTest<RegisterBloc, RegisterState>(
      'Invalid password with different confirm password emits'
      ' [errorPassword,errorConfirmPassword] state',
      build: () {
        return bloc;
      },
      act: (bloc) => bloc.add(
        const PasswordChanged(
          password: 'not_valid',
          confirmPassword: 'neither_valid',
        ),
      ),
      expect: () => [
        const RegisterState(
          email: Email.empty(),
          password: Password.empty(),
          confirmPassword: Password.empty(),
          validating: false,
          errorEmail: false,
          errorPassword: true,
          errorConfirmPassword: true,
          successful: false,
          error: false,
        ),
      ],
    );
    blocTest<RegisterBloc, RegisterState>(
      'Valid password emits with empty confirm password '
      'emits errorConfirmPassword state',
      build: () {
        return bloc;
      },
      act: (bloc) => bloc.add(
        const PasswordChanged(password: 'Val1dPassword@', confirmPassword: ''),
      ),
      expect: () => [
        RegisterState(
          email: const Email.empty(),
          password: Password('Val1dPassword@'),
          confirmPassword: const Password.empty(),
          validating: false,
          errorEmail: false,
          errorPassword: false,
          errorConfirmPassword: false,
          successful: false,
          error: false,
        ),
      ],
    );
    blocTest<RegisterBloc, RegisterState>(
      'Valid password emits with non valid confirm password '
      'emits errorConfirmPassword state',
      build: () {
        return bloc;
      },
      act: (bloc) => bloc.add(
        const PasswordChanged(
          password: 'Val1dPassword@',
          confirmPassword: 'not_valid',
        ),
      ),
      expect: () => [
        RegisterState(
          email: const Email.empty(),
          password: Password('Val1dPassword@'),
          confirmPassword: const Password.empty(),
          validating: false,
          errorEmail: false,
          errorPassword: false,
          errorConfirmPassword: true,
          successful: false,
          error: false,
        ),
      ],
    );
    blocTest<RegisterBloc, RegisterState>(
      'Valid password emits with valid different confirm password '
      'emits errorConfirmPassword state',
      build: () {
        return bloc
          ..add(
            const ConfirmPasswordChanged(
              password: '',
              confirmPassword: 'Val1dPassword@2',
            ),
          );
      },
      act: (bloc) => bloc.add(
        const PasswordChanged(
          password: 'Val1dPassword@',
          confirmPassword: 'Val1dPassword@2',
        ),
      ),
      skip: 1,
      expect: () => [
        RegisterState(
          email: const Email.empty(),
          password: Password('Val1dPassword@'),
          confirmPassword: Password('Val1dPassword@2'),
          validating: false,
          errorEmail: false,
          errorPassword: false,
          errorConfirmPassword: true,
          successful: false,
          error: false,
        ),
      ],
    );
    blocTest<RegisterBloc, RegisterState>(
      'Valid confirm password  with non valid password '
      'emits errorConfirmPassword state',
      build: () {
        return bloc;
      },
      act: (bloc) => bloc.add(
        const ConfirmPasswordChanged(
          password: 'not_valid',
          confirmPassword: 'Val1dPassword@',
        ),
      ),
      expect: () => [
        RegisterState(
          email: const Email.empty(),
          password: const Password.empty(),
          confirmPassword: Password('Val1dPassword@'),
          validating: false,
          errorEmail: false,
          errorPassword: false,
          errorConfirmPassword: true,
          successful: false,
          error: false,
        ),
      ],
    );

    blocTest<RegisterBloc, RegisterState>(
      'Non Valid confirm password with non valid password '
      'emits errorConfirmPassword state',
      build: () {
        return bloc;
      },
      act: (bloc) => bloc.add(
        const ConfirmPasswordChanged(
          password: 'not_valid',
          confirmPassword: 'not_valid2',
        ),
      ),
      expect: () => [
        const RegisterState(
          email: Email.empty(),
          password: Password.empty(),
          confirmPassword: Password.empty(),
          validating: false,
          errorEmail: false,
          errorPassword: false,
          errorConfirmPassword: true,
          successful: false,
          error: false,
        ),
      ],
    );

    final email = Email('test@test.com');
    final password = Password('Val1dPassword@');
    blocTest<RegisterBloc, RegisterState>(
      'Register with valid credentials',
      build: () {
        when(() => registerMock.register(email, password)).thenAnswer(
          (_) async => right(unit),
        );
        return bloc
          ..add(
            const EmailChanged('test@test.com'),
          )
          ..add(
            const PasswordChanged(
              password: 'Val1dPassword@',
              confirmPassword: '',
            ),
          )
          ..add(
            const ConfirmPasswordChanged(
              password: 'Val1dPassword@',
              confirmPassword: 'Val1dPassword@',
            ),
          );
      },
      skip: 4,
      act: (bloc) => bloc.add(const AttemptRegister()),
      expect: () {
        return [
          RegisterState(
            email: email,
            password: password,
            confirmPassword: password,
            validating: false,
            errorEmail: false,
            errorPassword: false,
            errorConfirmPassword: false,
            successful: true,
            error: false,
          ),
        ];
      },
    );
    blocTest<RegisterBloc, RegisterState>(
      'Register with wrong credentials',
      build: () {
        when(() => registerMock.register(email, password)).thenAnswer(
          (_) async => left(const RegisterFailure('email-already-in-use')),
        );
        return bloc
          ..add(
            const EmailChanged('test@test.com'),
          )
          ..add(
            const PasswordChanged(
              password: 'Val1dPassword@',
              confirmPassword: '',
            ),
          )
          ..add(
            const ConfirmPasswordChanged(
              password: 'Val1dPassword@',
              confirmPassword: 'Val1dPassword@',
            ),
          );
      },
      act: (bloc) => bloc..add(const AttemptRegister()),
      skip: 4,
      expect: () {
        return [
          RegisterState(
            email: email,
            password: password,
            confirmPassword: password,
            validating: false,
            errorEmail: false,
            errorPassword: false,
            errorConfirmPassword: false,
            successful: false,
            error: true,
          ),
        ];
      },
    );
  });
}
