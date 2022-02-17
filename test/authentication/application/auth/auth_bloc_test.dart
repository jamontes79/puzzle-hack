import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:puzzle/authentication/application/auth/auth_bloc.dart';
import 'package:puzzle/authentication/domain/failures/failures.dart';
import 'package:puzzle/authentication/domain/models/puzzle_user.dart';
import 'package:puzzle/authentication/domain/usecases/i_auth.dart';

class MockAuth extends Mock implements IAuth {}

void main() {
  late IAuth auth;
  late AuthBloc authBloc;
  setUp(() {
    auth = MockAuth();
    authBloc = AuthBloc(auth);
  });
  group('Check authentication status', () {
    const user = PuzzleUser(id: 'id', username: 'username');
    test('Initial states is Unauthenticated', () {
      expect(
        authBloc.state,
        const Unauthenticated(),
      );
    });
    blocTest<AuthBloc, AuthState>(
      'Emits Authenticated when user is authenticated',
      build: () {
        when(
          () => auth.getSignedUser(),
        ).thenAnswer(
          (_) async => right(user),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const CheckStatus(),
      ),
      expect: () => <AuthState>[
        const Authenticated(),
      ],
    );
    blocTest<AuthBloc, AuthState>(
      'Emits Unauthenticated when user is not authenticated',
      build: () {
        when(
          () => auth.getSignedUser(),
        ).thenAnswer(
          (_) async => left(const NotLoggedUserFailure()),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const CheckStatus(),
      ),
      expect: () => <AuthState>[
        const Unauthenticated(),
      ],
    );
  });
  group('Logout', () {
    blocTest<AuthBloc, AuthState>(
      'Emits Unauthenticated when user logs out',
      build: () {
        when(
          () => auth.logout(),
        ).thenAnswer(
          (_) async => unit,
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const Logout(),
      ),
      expect: () => <AuthState>[
        const Unauthenticated(),
      ],
      verify: (_) {
        verify(
          () => auth.logout(),
        ).called(1);
      },
    );
  });
}
