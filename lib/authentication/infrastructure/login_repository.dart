import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:puzzle/authentication/domain/failures/failures.dart';
import 'package:puzzle/authentication/domain/models/puzzle_user.dart';
import 'package:puzzle/authentication/domain/usecases/i_login.dart';
import 'package:puzzle/core/domain/failures/failures.dart';

@LazySingleton(as: ILogin)
class LoginRepository implements ILogin {
  LoginRepository(this._auth, this._googleSignIn);
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

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

  @override
  Future<Either<Failure, PuzzleUser>> doLoginWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      return left(const LoginFailure('cancelled'));
    }
    final googleAuthentication = await googleUser.authentication;
    final authCredential = GoogleAuthProvider.credential(
      idToken: googleAuthentication.idToken,
      accessToken: googleAuthentication.accessToken,
    );

    final userCredential = await _auth.signInWithCredential(authCredential);
    final username =
        userCredential.user!.displayName ?? userCredential.user!.email;
    return right(
      PuzzleUser(
        id: userCredential.user!.uid,
        username: username!,
      ),
    );
  }
}
