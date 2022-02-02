import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:puzzle/authentication/domain/failures/failures.dart';
import 'package:puzzle/authentication/domain/usecases/i_register.dart';
import 'package:puzzle/core/domain/failures/failures.dart';
import 'package:puzzle/core/domain/models/email_model.dart';
import 'package:puzzle/core/domain/models/password_model.dart';

@LazySingleton(as: IRegister)
class RegisterRepository implements IRegister {
  RegisterRepository(this._auth);

  final FirebaseAuth _auth;

  @override
  Future<Either<Failure, Unit>> register(
    Email email,
    Password password,
  ) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email.value,
        password: password.value,
      );
      return right(unit);
    } on FirebaseAuthException catch (e) {
      return left(RegisterFailure(e.code));
    }
  }
}
