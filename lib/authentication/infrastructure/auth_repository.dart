import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:puzzle/authentication/domain/failures/failures.dart';
import 'package:puzzle/authentication/domain/models/puzzle_user.dart';
import 'package:puzzle/authentication/domain/usecases/i_auth.dart';
import 'package:puzzle/core/domain/failures/failures.dart';

@LazySingleton(as: IAuth)
class AuthRepository implements IAuth {
  AuthRepository(this._auth, this._googleSignIn);

  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  @override
  Either<Failure, PuzzleUser> getSignedUser() {
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
      _auth.signOut(),
      _googleSignIn.signOut(),
    ]);

    return Future.value(unit);
  }
}
