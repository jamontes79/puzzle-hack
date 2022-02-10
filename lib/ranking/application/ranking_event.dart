part of 'ranking_bloc.dart';

abstract class RankingEvent extends Equatable {
  const RankingEvent();
}

class RetrieveRanking extends RankingEvent {
  const RetrieveRanking(this.level);
  final int level;
  @override
  List<Object?> get props => [];
}

class RankingReceived extends RankingEvent {
  const RankingReceived(this.failureOrRanking);
  final Either<RankingFailure, List<Ranking>> failureOrRanking;
  @override
  List<Object?> get props => [
        failureOrRanking,
      ];
}

class SaveRanking extends RankingEvent {
  const SaveRanking({required this.numberOfMovements, required this.level});
  final int numberOfMovements;
  final int level;
  @override
  List<Object?> get props => [];
}
