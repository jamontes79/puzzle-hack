import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:puzzle/authentication/domain/failures/failures.dart';
import 'package:puzzle/authentication/domain/models/puzzle_user.dart';
import 'package:puzzle/authentication/domain/usecases/i_login.dart';
import 'package:puzzle/core/domain/failures/failures.dart';
import 'package:puzzle/core/domain/usecases/i_secure_storage.dart';

@LazySingleton(as: ILogin)
class LoginRepository implements ILogin {
  LoginRepository(this._auth, this._secureStorage);
  final FirebaseAuth _auth;
  final ISecureStorage _secureStorage;
  @override
  Future<Either<Failure, PuzzleUser>> doLogin(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _secureStorage.write(key: 'password', value: password);
      await _secureStorage.write(key: 'username', value: email);
      final username =
          userCredential.user!.displayName ?? userCredential.user!.email;
      return right(
        PuzzleUser(
          id: userCredential.user!.uid,
          username: username!,
        ),
      );
    } on FirebaseAuthException catch (e) {
      return left(LoginFailure(e.code));
    }
  }
}
