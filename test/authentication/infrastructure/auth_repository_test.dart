import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:puzzle/authentication/domain/failures/failures.dart';
import 'package:puzzle/authentication/domain/models/puzzle_user.dart';
import 'package:puzzle/authentication/infrastructure/auth_repository.dart';
import 'package:puzzle/core/domain/usecases/i_secure_storage.dart';

class MockAuth extends Mock implements FirebaseAuth {}

class MockStorage extends Mock implements ISecureStorage {}

void main() {
  late MockAuth firebaseAuth;
  late AuthRepository authRepository;
  late ISecureStorage secureStorage;

  final user = MockUser(
    uid: 'someuid',
    email: 'bob@somedomain.com',
    displayName: 'Bob',
  );
  setUp(() {
    firebaseAuth = MockAuth();
    secureStorage = MockStorage();
    authRepository = AuthRepository(firebaseAuth, secureStorage);
  });

  group('isAuthenticated', () {
    test('When is unauthenticated returns NotLoggedUserFailure', () async {
      when(() => firebaseAuth.currentUser).thenReturn(null);
      when(() => secureStorage.contains(key: 'password')).thenAnswer(
        (_) async => false,
      );
      when(() => secureStorage.contains(key: 'username')).thenAnswer(
        (_) async => false,
      );
      final failureOrUser = await authRepository.getSignedUser();
      failureOrUser.fold(
        (failure) => expect(
          failure,
          const NotLoggedUserFailure(),
        ),
        (r) => null,
      );
    });

    test('When is Authenticated returns user', () async {
      const puzzleUser = PuzzleUser(id: 'someuid', username: 'Bob');
      when(() => firebaseAuth.currentUser).thenReturn(user);

      final failureOrUser = await authRepository.getSignedUser();
      failureOrUser.fold(
        (l) => null,
        (user) => expect(
          user,
          puzzleUser,
        ),
      );
    });
  });
  group('Logout', () {
    test('Logout calls signOut from firebaseauth', () async {
      when(() => firebaseAuth.signOut()).thenAnswer((_) async {});
      when(() => secureStorage.delete(key: 'username')).thenAnswer(
        (_) async => unit,
      );
      when(() => secureStorage.delete(key: 'password')).thenAnswer(
        (_) async => unit,
      );
      await authRepository.logout();
      verify(() => firebaseAuth.signOut()).called(1);
    });

    test('Logout returns unit', () async {
      when(() => firebaseAuth.signOut()).thenAnswer((_) async {});
      when(() => secureStorage.delete(key: 'username')).thenAnswer(
        (_) async => unit,
      );
      when(() => secureStorage.delete(key: 'password')).thenAnswer(
        (_) async => unit,
      );
      final logout = await authRepository.logout();
      expect(
        logout,
        unit,
      );
    });
  });
}
