import 'package:dartz/dartz.dart';
import 'package:puzzle/authentication/domain/models/puzzle_user.dart';
import 'package:puzzle/core/domain/failures/failures.dart';

abstract class IAuth {
  Future<Either<Failure, PuzzleUser>> getSignedUser();
  Future<Unit> logout();
}
