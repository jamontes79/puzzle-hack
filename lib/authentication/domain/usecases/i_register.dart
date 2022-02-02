import 'package:dartz/dartz.dart';
import 'package:puzzle/core/domain/failures/failures.dart';
import 'package:puzzle/core/domain/models/email_model.dart';
import 'package:puzzle/core/domain/models/password_model.dart';

abstract class IRegister {
  Future<Either<Failure, Unit>> register(
    Email email,
    Password password,
  );
}
