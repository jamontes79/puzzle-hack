import 'package:dartz/dartz.dart';
import 'package:puzzle/ranking/domain/failures/ranking_failure.dart';
import 'package:puzzle/ranking/domain/models/ranking.dart';

abstract class IRanking {
  Stream<Either<RankingFailure, List<Ranking>>> watchAll(int level);
  Future<Either<RankingFailure, Unit>> create(Ranking ranking);
}
