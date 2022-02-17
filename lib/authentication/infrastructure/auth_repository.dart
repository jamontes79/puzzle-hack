import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:puzzle/authentication/domain/failures/failures.dart';
import 'package:puzzle/authentication/domain/models/puzzle_user.dart';
import 'package:puzzle/authentication/domain/usecases/i_auth.dart';
import 'package:puzzle/core/domain/failures/failures.dart';
import 'package:puzzle/core/domain/usecases/i_secure_storage.dart';

@LazySingleton(as: IAuth)
class AuthRepository implements IAuth {
  AuthRepository(this._auth, this._secureStorage);

  final FirebaseAuth _auth;
  final ISecureStorage _secureStorage;
  @override
  Future<Either<Failure, PuzzleUser>> getSignedUser() async {
    if (_auth.currentUser == null) {
      if (await _secureStorage.contains(key: 'password') &&
          await _secureStorage.contains(key: 'username')) {
        final password = await _secureStorage.read(key: 'password');
        final username = await _secureStorage.read(key: 'username');
        if (username != null && password != null) {
          await _auth.signInWithEmailAndPassword(
            email: username,
            password: password,
          );
        }
      }
    }
    if (_auth.currentUser != null) {
      final username =
          _auth.currentUser!.displayName ?? _auth.currentUser!.email;
      return right(
        PuzzleUser(
          id: _auth.currentUser!.uid,
          username: username!,
        ),
      );
    }
    return left(const NotLoggedUserFailure());
  }

  @override
  Future<Unit> logout() async {
    await Future.wait([
      _secureStorage.delete(key: 'password'),
      _secureStorage.delete(key: 'username'),
      _auth.signOut(),
    ]);

    return Future.value(unit);
  }
}
