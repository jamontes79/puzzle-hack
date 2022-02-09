part of 'ranking_bloc.dart';

abstract class RankingState extends Equatable {
  const RankingState();
}

class RankingInitial extends RankingState {
  @override
  List<Object> get props => [];
}

class RankingLoading extends RankingState {
  @override
  List<Object> get props => [];
}

class RankingLoadFailure extends RankingState {
  const RankingLoadFailure(this.failure);

  final RankingFailure failure;
  @override
  List<Object> get props => [];
}

class RankingLoadSuccessful extends RankingState {
  const RankingLoadSuccessful(this.list);

  final List<Ranking> list;
  @override
  List<Object> get props => [list];
}
