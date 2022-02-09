import 'package:puzzle/core/domain/failures/failures.dart';

class RankingFailure extends Failure {
  const RankingFailure();
  @override
  List<Object?> get props => [];
}

class UnexpectedRankingFailure extends RankingFailure {
  const UnexpectedRankingFailure();
}

class InsufficientPermissionRankingFailure extends RankingFailure {}
