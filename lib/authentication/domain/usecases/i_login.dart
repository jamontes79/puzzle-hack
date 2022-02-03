import 'package:dartz/dartz.dart';
import 'package:puzzle/authentication/domain/models/puzzle_user.dart';
import 'package:puzzle/core/domain/failures/failures.dart';

abstract class ILogin {
  Future<Either<Failure, PuzzleUser>> doLogin(
    String email,
    String password,
  );
}
