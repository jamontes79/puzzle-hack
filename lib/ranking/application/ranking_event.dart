part of 'ranking_bloc.dart';

abstract class RankingEvent extends Equatable {
  const RankingEvent();
}

class RetrieveRanking extends RankingEvent {
  const RetrieveRanking();
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
  const SaveRanking(this.numberOfMovements);
  final int numberOfMovements;
  @override
  List<Object?> get props => [];
}
