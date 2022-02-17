import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:puzzle/authentication/domain/failures/failures.dart';
import 'package:puzzle/authentication/infrastructure/login_repository.dart';
import 'package:puzzle/core/domain/usecases/i_secure_storage.dart';

class MockAuth extends Mock implements FirebaseAuth {}

class MockStorage extends Mock implements ISecureStorage {}

void main() {
  group('LoginRepository correct credentials', () {
    late MockFirebaseAuth firebaseAuth;
    late LoginRepository loginRepository;
    late ISecureStorage secureStorage;
    final user = MockUser(
      uid: 'someuid',
      email: 'bob@somedomain.com',
      displayName: 'Bob',
    );

    setUp(() {
      firebaseAuth = MockFirebaseAuth(mockUser: user);
      secureStorage = MockStorage();
      loginRepository = LoginRepository(firebaseAuth, secureStorage);
    });
    test('doLogin returns right part', () async {
      when(() => secureStorage.write(key: 'username', value: 'email'))
          .thenAnswer(
        (_) async => unit,
      );
      when(() => secureStorage.write(key: 'password', value: 'password'))
          .thenAnswer(
        (_) async => unit,
      );
      final failureOrUser = await loginRepository.doLogin('email', 'password');
      expect(
        true,
        failureOrUser.isRight(),
      );
    });
    test('doLogin returns correct user id', () async {
      when(() => secureStorage.write(key: 'username', value: 'email'))
          .thenAnswer(
        (_) async => unit,
      );
      when(() => secureStorage.write(key: 'password', value: 'password'))
          .thenAnswer(
        (_) async => unit,
      );

      final failureOrUser = await loginRepository.doLogin('email', 'password');

      failureOrUser.fold(
        (l) => null,
        (user) => expect(
          'someuid',
          user.id,
        ),
      );
    });
    test('doLogin returns correct user email', () async {
      when(() => secureStorage.write(key: 'username', value: 'email'))
          .thenAnswer(
        (_) async => unit,
      );
      when(() => secureStorage.write(key: 'password', value: 'password'))
          .thenAnswer(
        (_) async => unit,
      );

      final failureOrUser = await loginRepository.doLogin('email', 'password');

      failureOrUser.fold(
        (l) => null,
        (user) => expect(
          'Bob',
          user.username,
        ),
      );
    });
  });
  group('LoginRepository non-correct credentials', () {
    late MockAuth firebaseAuth;
    late LoginRepository loginRepository;
    late ISecureStorage secureStorage;
    setUp(() {
      firebaseAuth = MockAuth();
      secureStorage = MockStorage();
      loginRepository = LoginRepository(firebaseAuth, secureStorage);
    });
    test('doLogin returns left part', () async {
      when(
        () => firebaseAuth.signInWithEmailAndPassword(
          email: 'email',
          password: 'password',
        ),
      ).thenThrow(
        FirebaseAuthException(code: 'user-not-found'),
      );

      final failureOrUser = await loginRepository.doLogin('email', 'password');
      expect(
        true,
        failureOrUser.isLeft(),
      );
    });
    test('doLogin returns loginFailure', () async {
      when(
        () => firebaseAuth.signInWithEmailAndPassword(
          email: 'email',
          password: 'password',
        ),
      ).thenThrow(
        FirebaseAuthException(code: 'user-not-found'),
      );

      final failureOrUser = await loginRepository.doLogin('email', 'password');
      failureOrUser.fold(
        (l) => expect(true, l is LoginFailure),
        (r) => null,
      );
    });
    test('doLogin returns loginFailure', () async {
      when(
        () => firebaseAuth.signInWithEmailAndPassword(
          email: 'email',
          password: 'password',
        ),
      ).thenThrow(
        FirebaseAuthException(code: 'user-not-found'),
      );

      final failureOrUser = await loginRepository.doLogin('email', 'password');
      failureOrUser.fold(
        (l) => expect('user-not-found', (l as LoginFailure).code),
        (r) => null,
      );
    });
  });
}
