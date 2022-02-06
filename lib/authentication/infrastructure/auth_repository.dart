import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:puzzle/authentication/domain/failures/failures.dart';
import 'package:puzzle/authentication/domain/models/puzzle_user.dart';
import 'package:puzzle/authentication/domain/usecases/i_auth.dart';
import 'package:puzzle/core/domain/failures/failures.dart';

@LazySingleton(as: IAuth)
class AuthRepository implements IAuth {
  AuthRepository(this._auth);

  final FirebaseAuth _auth;

  @override
  Future<Either<Failure, PuzzleUser>> getSignedUser() async {
    if (_auth.currentUser == null) {
      const storage = FlutterSecureStorage();
      if (await storage.containsKey(key: 'password') &&
          await storage.containsKey(key: 'username')) {
        final password = await storage.read(key: 'password');
        final username = await storage.read(key: 'username');
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
    const storage = FlutterSecureStorage();
    await Future.wait([
      storage.delete(key: 'password'),
      storage.delete(key: 'username'),
      _auth.signOut(),
    ]);

    return Future.value(unit);
  }
}
