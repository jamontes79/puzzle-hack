import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:puzzle/authentication/application/login/login_bloc.dart';
import 'package:puzzle/authentication/domain/failures/failures.dart';
import 'package:puzzle/authentication/domain/models/puzzle_user.dart';
import 'package:puzzle/authentication/domain/usecases/i_login.dart';

class MockLogin extends Mock implements ILogin {}

void main() {
  group('LoginBloc', () {
    late ILogin login;
    late LoginBloc loginBloc;
    setUp(() {
      login = MockLogin();
      loginBloc = LoginBloc(login);
    });
    test('Initial state is correct', () {
      expect(
        loginBloc.state,
        const LoginState(),
      );
    });

    blocTest<LoginBloc, LoginState>(
      'emits formstate with error when credentials are not valid',
      build: () {
        when(
          () => login.doLogin('', ''),
        ).thenAnswer(
          (_) async => left(const LoginFailure('error')),
        );
        return loginBloc;
      },
      act: (bloc) => bloc.add(
        const AttemptLogin(),
      ),
      expect: () => [
        const LoginState(
          validating: true,
        ),
        const LoginState(
          error: true,
        ),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      'emits [validating, loginSuccessful] when credentials are  valid',
      build: () {
        when(
          () => login.doLogin('', ''),
        ).thenAnswer(
          (_) async => right(
            const PuzzleUser(id: 'id', username: 'username'),
          ),
        );
        return loginBloc;
      },
      act: (bloc) => bloc.add(
        const AttemptLogin(),
      ),
      expect: () => [
        const LoginState(
          validating: true,
        ),
        const LoginState(
          successful: true,
        ),
      ],
    );
  });
}
